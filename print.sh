#!/bin/bash
set -e  # Exit on any error

# Configurable paths (override via env, but default to /tmp)
PAGES=("lifting" "stretching-and-cardio")
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/full-workout.pdf}"
PRINTER="${PRINTER:-}"  # Optional printer override

# Ensure we're in the script's directory (for local file access)
cd "$(dirname "$0")"

# Check dependencies
for cmd in pandoc pdfunite lp weasyprint; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: Required tool '$cmd' not installed. Aborting." >&2
    exit 1
  fi
done

# Check input files (Markdown + CSS)
for page in "${PAGES[@]}"; do
  if [[ ! -f "${page}.md" ]]; then
    echo "Error: Missing required file '${page}.md'. Aborting." >&2
    exit 1
  fi
done

# Generate PDFs in parallel
echo "Generating PDFs..."
for page in "${PAGES[@]}"; do
  pandoc "$page.md" -o "/tmp/$page.pdf" --css "styles.css" --pdf-engine weasyprint &
done
wait

PDF_FILES=()
for page in "${PAGES[@]}"; do
    PDF_FILES+=("/tmp/${page}.pdf")
done

pdfunite "${PDF_FILES[@]}" "$OUTPUT_FILE"

if [[ "$1" == "--generate-only" ]]; then
  # --generate-only: Skip printing/cleanup
  echo "Generated files:"
  ls -l "${PDF_FILES[@]}" "$OUTPUT_FILE"
else
  # Default behavior: Print + cleanup
  echo "Printing (duplex)..."
  lp ${PRINTER:+-d "$PRINTER"} -o sides=two-sided-long-edge "$OUTPUT_FILE"
  rm "${PDF_FILES[@]}" "$OUTPUT_FILE"
fi

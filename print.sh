#!/bin/bash
set -e  # Exit on any error

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
for file in workout-routine.md stretching-routine.md \
            css/workout-routine.css css/stretching-routine.css; do
  if [[ ! -f "$file" ]]; then
    echo "Error: Missing required file '$file'. Aborting." >&2
    exit 1
  fi
done

# Configurable paths (override via env, but default to /tmp)
WORKOUT_PDF="${WORKOUT_PDF:-/tmp/workout-routine.pdf}"
STRETCHING_PDF="${STRETCHING_PDF:-/tmp/stretching-routine.pdf}"
COMBINED_PDF="${COMBINED_PDF:-/tmp/combined-routines.pdf}"
PRINTER="${PRINTER:-}"  # Optional printer override

# Generate PDFs in parallel
echo "Generating PDFs..."
pandoc workout-routine.md -o "$WORKOUT_PDF" \
  --css=css/workout-routine.css --pdf-engine=weasyprint &
pandoc stretching-routine.md -o "$STRETCHING_PDF" \
  --css=css/stretching-routine.css --pdf-engine=weasyprint &
wait

# --generate-only: Skip printing/cleanup
if [[ "$1" == "--generate-only" ]]; then
  pdfunite "$WORKOUT_PDF" "$STRETCHING_PDF" "$COMBINED_PDF"
  echo "Generated files:"
  ls -l "$WORKOUT_PDF" "$STRETCHING_PDF" "$COMBINED_PDF"
  exit 0
fi

# Default behavior: Print + cleanup
pdfunite "$WORKOUT_PDF" "$STRETCHING_PDF" "$COMBINED_PDF"
echo "Printing (duplex)..."
lp ${PRINTER:+-d "$PRINTER"} -o sides=two-sided-long-edge "$COMBINED_PDF"
rm -f "$WORKOUT_PDF" "$STRETCHING_PDF" "$COMBINED_PDF"

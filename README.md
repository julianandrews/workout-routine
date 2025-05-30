# Workout Routine PDF Generator

This repository contains a Markdown file (`workout-routine.md`) and a CSS file (`workout-routine.css`) for generating a printable PDF of a workout routine. The PDF is generated using `pandoc` and `weasyprint`.

## Prerequisites

To generate the PDF, you need the following tools installed:

1. **Pandoc**: A universal document converter.
2. **WeasyPrint**: A tool for converting HTML/CSS to PDF.

### Installation on Ubuntu/Debian

Run the following commands to install the required tools:

```bash
# Install pandoc
sudo apt update
sudo apt install pandoc weasyprint
```

## Generating the PDF and Printing

To print, navigate to the repository directory and run:

```bash
./print.sh
```

Generate the PDF without printing, navigate to the repository directory and run:

```bash
./print.sh --generate-only
```

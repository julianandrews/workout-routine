# Workout Worksheets

Weekly fitness worksheets generated using [worksheet-generator](https://github.com/julianandrews/worksheet-generator).

## Usage

```bash
# Generate and print this week's workout
worksheet-generator config.yaml
```

## Generate PDF without printing (for preview/backup)

```bash
worksheet-generator --generate-only config.yaml
```

## Weekly Workflow

1. Update the markdown files with any changes
2. Commit and push changes
3. Run `worksheet-generator config.yaml`

That's it! The tool handles PDF generation, printing, and cleanup automatically.

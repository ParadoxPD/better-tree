# Enhanced Tree - Quick Start Guide

## Installation

1. Download `better-tree.sh`
2. Make it executable:

   ```bash
   chmod +x better-tree.sh
   ```

3. Run it:

   ```bash
   ./better-tree.sh
   ```

---

## Example Commands

### Basic Usage

```bash
./better-tree.sh                    # Show current directory
./better-tree.sh /path/to/project   # Show specific directory
./better-tree.sh -L 2               # Limit to 2 levels deep
```

---

### Smart Filtering

```bash
./better-tree.sh --git              # Respect .gitignore
./better-tree.sh -e build -e dist   # Exclude specific directories
./better-tree.sh -d                 # Directories only
./better-tree.sh -a                 # Show hidden files
```

---

### Code Inspection

```bash
./better-tree.sh -c go tsx ts       # Show contents of Go and TypeScript files
./better-tree.sh -g "TODO"          # Find all TODOs
./better-tree.sh -g "API_KEY" -a    # Security scan (include hidden files)
./better-tree.sh -c go --clip 50    # Show first 50 lines per file
./better-tree.sh -c go --no-clip    # Show full file contents
```

---

### Project Analysis

```bash
./better-tree.sh --stats            # Language breakdown
./better-tree.sh --fingerprint      # Complete project profile
./better-tree.sh --big              # Highlight large files (>5MB)
./better-tree.sh --dupes            # Find duplicate files
./better-tree.sh --audit            # Security audit
```

---

### Output Formats

```bash
./better-tree.sh --md > STRUCTURE.md
./better-tree.sh --json > structure.json
./better-tree.sh --prompt -c go > ai-prompt.txt
```

---

### Visual Themes

```bash
./better-tree.sh --theme nord
./better-tree.sh --theme gruvbox
./better-tree.sh --theme dracula
```

---

### Advanced Workflows

```bash
# Complete repo overview
./better-tree.sh --git --stats --big -L 3

# Find test files
./better-tree.sh --tests --focus tsx

# Generate AI code review
./better-tree.sh --prompt -c go tsx ts py > review.txt

# Focus on backend code
./better-tree.sh --focus go --sort size

# Pre-commit security check
./better-tree.sh --audit -g "password|secret|token"
```

---

For full documentation, see `README.md`.

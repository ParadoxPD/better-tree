# Enhanced Tree - Quick Start Guide

## Installation

1. Download `tree.sh`
2. Make it executable: `chmod +x tree.sh`
3. Run it: `./tree.sh`

## Example Commands

### Basic Usage

```bash
./tree.sh                    # Show current directory
./tree.sh /path/to/project   # Show specific directory
./tree.sh -L 2               # Limit to 2 levels deep
```

### Smart Filtering

```bash
./tree.sh --git              # Auto-ignore .git, node_modules, etc.
./tree.sh -e build -e dist   # Exclude specific directories
./tree.sh -d                 # Directories only
```

### Code Inspection

```bash
./tree.sh -c go tsx ts       # Show contents of Go and TypeScript files
./tree.sh -g "TODO"          # Find all TODOs
./tree.sh -g "API_KEY"       # Security scan for sensitive data
```

### Project Analysis

```bash
./tree.sh --stats            # Language breakdown
./tree.sh --fingerprint      # Complete project profile
./tree.sh --big              # Find large files (>5MB)
./tree.sh --dupes            # Find duplicate files
./tree.sh --audit            # Security audit
```

### Output Formats

```bash
./tree.sh --md > STRUCTURE.md              # Markdown export
./tree.sh --json > structure.json          # JSON output
./tree.sh --prompt -c go > ai-prompt.txt   # AI-ready snapshot
```

### Visual Themes

```bash
./tree.sh --theme nord       # Arctic blue palette
./tree.sh --theme gruvbox    # Warm retro colors
./tree.sh --theme dracula    # Dark mode favorite
```

### Advanced Workflows

```bash
# Complete repo overview
./tree.sh --git --stats --big -L 3

# Find test files
./tree.sh --tests --focus tsx

# Generate AI code review
./tree.sh --prompt -c go tsx ts py > review.txt

# Focus on backend code
./tree.sh --focus go --sort size

# Pre-commit security check
./tree.sh --audit -g "password|secret|token"
```

## Example Output: Grep Mode

```
src/
├── auth/
│   ├── token.go
│   │   ╭── matches ──
│   │   │ 45: // TODO: rotate refresh tokens
│   │   │ 67: // TODO: add rate limiting
│   │   ╰─────────────
```

## Example Output: Fingerprint Mode

```
=== Project Fingerprint ===

Directory: ./my-app
Total Directories: 47
Total Files: 203
Total Size: 12M
Max Depth: 5

=== Language Statistics ===
  tsx: 45 files
  ts: 38 files
  go: 32 files
  json: 15 files

=== Largest Files (Top 10) ===
  5M dist/bundle.js
  2M package-lock.json
```

## Pro Tips

1. **Add to PATH**: `sudo cp tree.sh /usr/local/bin/etree`
2. **Create aliases**:
   ```bash
   alias t='./tree.sh --git -L 2'
   alias tfp='./tree.sh --fingerprint'
   ```
3. **Combine with other tools**:
   ```bash
   ./tree.sh --json | jq '.root.children'
   ./tree.sh --md | pandoc -o structure.pdf
   ```
4. **Use with AI**:
   ```bash
   ./tree.sh --prompt -c go tsx ts | pbcopy
   # Then paste into ChatGPT/Claude
   ```

## All Features at a Glance

| Feature          | Flag               | Description             |
| ---------------- | ------------------ | ----------------------- |
| Depth limit      | `-L <n>`           | Control traversal depth |
| Hidden files     | `-a`               | Show dotfiles           |
| Directories only | `-d`               | Skip files              |
| Exclude          | `-e <n>`           | Filter patterns         |
| Metadata         | `-i`               | Show permissions, dates |
| Cat files        | `-c <ext...>`      | Display file contents   |
| Grep             | `-g <pattern>`     | Search with context     |
| Git aware        | `--git`            | Respect .gitignore      |
| Stats            | `--stats`          | Language breakdown      |
| Markdown         | `--md`             | Export as Markdown      |
| JSON             | `--json`           | Machine-readable        |
| AI mode          | `--prompt`         | Claude/ChatGPT ready    |
| Large files      | `--big`            | Highlight >5MB          |
| Duplicates       | `--dupes`          | Find identical files    |
| Audit            | `--audit`          | Security check          |
| Sort             | `--sort <mode>`    | name\|size\|time        |
| Group            | `--group`          | By extension            |
| Focus            | `--focus <ext...>` | Relevant dirs only      |
| Tests            | `--tests`          | Highlight test files    |
| Fingerprint      | `--fingerprint`    | Full project profile    |
| Resolve links    | `--resolve`        | Show real paths         |
| Theme            | `--theme <n>`      | Color schemes           |

---

For complete documentation, see README.md

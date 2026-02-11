# Enhanced Tree 🌳

**The ultimate directory visualization and code inspection tool for developers**

A powerful Bash script that goes far beyond the basic `tree` command. Visualize your project structure, inspect code, analyze repositories, find issues, and generate documentation — all from one tool.

---

## 🚀 Quick Start

```bash
# Make it executable
chmod +x tree.sh

# Basic usage
./tree.sh

# With depth limit and gitignore
./tree.sh -L 2 --git

# Generate AI prompt for your codebase
./tree.sh --prompt -c go tsx ts > codebase.txt
```

---

## ✨ Features

### 📁 Core Navigation

- **Depth limiting** (`-L <n>`) - Control how deep to traverse
- **Hidden files** (`-a`) - Show dotfiles and hidden items
- **Directories only** (`-d`) - Skip files, show structure
- **Smart exclusions** (`-e <name>`) - Filter out noise (repeatable)

### 🔍 Code Inspection

- **Cat mode** (`-c <ext...>`) - Display file contents inline
- **Grep mode** (`-g <pattern>`) - Search across files with context
- **Test highlighting** (`--tests`) - Identify test files with ✓ markers

### 🌲 Git Integration

- **Auto-ignore** (`--git`) - Respect `.gitignore` automatically
- **Focus mode** (`--focus <ext...>`) - Show only directories containing specific file types

### 📊 Analysis & Intelligence

- **Language stats** (`--stats`) - Count files by extension
- **Project fingerprint** (`--fingerprint`) - Complete project profile
- **Duplicate finder** (`--dupes`) - Detect identical files via MD5 hash
- **Security audit** (`--audit`) - Flag executables and dangerous permissions
- **Size warnings** (`--big`) - Highlight files >5MB

### 🎨 Display & Formatting

- **Themes** (`--theme <name>`) - nord | gruvbox | dracula | default
- **Size display** (enabled by default, disable with `-s`)
- **Detailed metadata** (`-i`) - Show permissions, owner, date

### 📦 Output Formats

- **Markdown** (`--md`) - Export tree as Markdown for docs
- **JSON** (`--json`) - Machine-readable output
- **AI mode** (`--prompt`) - Clean, no-color output perfect for ChatGPT/Claude

### 🔧 Organization

- **Sorting** (`--sort <mode>`) - name | size | time
- **Group by extension** (`--group`) - Organize files by type
- **Symlink resolution** (`--resolve`) - Show real paths

---

## 📖 Usage Examples

### Basic Project Exploration

```bash
# Simple tree with depth limit
./tree.sh -L 3

# Respect gitignore (no node_modules, .git, etc.)
./tree.sh --git

# Show only directories
./tree.sh -d
```

### Code Inspection

```bash
# Find all TODOs in Go files
./tree.sh -g "TODO" -c go

# Display all TypeScript files inline
./tree.sh -c ts tsx

# Search for API keys (security audit)
./tree.sh -g "API_KEY\|SECRET" -a
```

### Project Analysis

```bash
# Get project overview
./tree.sh --fingerprint

# Language breakdown
./tree.sh --stats

# Find large files that shouldn't be committed
./tree.sh --big --git

# Find duplicate files
./tree.sh --dupes
```

### AI & Documentation

```bash
# Generate AI-ready codebase snapshot
./tree.sh --prompt -c go tsx ts py > prompt.txt

# Then paste prompt.txt into ChatGPT with:
# "Review this codebase and suggest improvements"

# Export tree as Markdown for README
./tree.sh --md -L 3 > STRUCTURE.md
```

### Focus & Filter

```bash
# Show only Go-related directories
./tree.sh --focus go

# Backend code only (exclude tests)
./tree.sh --focus go -e *_test.go

# Find where tests are located
./tree.sh --tests -d
```

### Security Audit

```bash
# Find all executables
./tree.sh --audit

# Check for world-writable files
./tree.sh --audit -i

# Scan for sensitive patterns
./tree.sh -g "password\|secret\|token" -a
```

### Visual Customization

```bash
# Try different themes
./tree.sh --theme nord
./tree.sh --theme gruvbox
./tree.sh --theme dracula

# Minimal output (no sizes)
./tree.sh -s

# Maximum detail
./tree.sh -i
```

---

## 🎯 Real-World Workflows

### 1. Understanding a New Codebase

```bash
# Quick overview
./tree.sh --fingerprint --git

# See the main code structure
./tree.sh -L 2 --focus go tsx

# Review critical files
./tree.sh --prompt -c go > review.txt
```

### 2. Pre-Commit Checklist

```bash
# Check for large files
./tree.sh --big --git

# Find TODOs before shipping
./tree.sh -g "TODO\|FIXME" --git

# Security scan
./tree.sh --audit -g "password\|api_key"
```

### 3. Generating Documentation

```bash
# Create structure diagram
./tree.sh --md -L 3 > docs/STRUCTURE.md

# Capture API endpoints
./tree.sh -g "router\|endpoint" -c go > docs/API_ROUTES.txt
```

### 4. Debugging & Investigation

```bash
# Find where a function is used
./tree.sh -g "calculateTotal" -c ts tsx

# Locate test files for a module
./tree.sh --tests --focus auth

# Check symlink integrity
./tree.sh --resolve
```

---

## 🎨 Themes Preview

### Default

Clean, professional colors for any terminal

### Nord

Cool arctic palette (blues, greens, purples)

### Gruvbox

Warm retro contrast (browns, oranges, greens)

### Dracula

Dark mode enthusiast favorite (purples, pinks, cyans)

```bash
./tree.sh --theme nord
./tree.sh --theme gruvbox
./tree.sh --theme dracula
```

---

## ⚙️ Options Reference

| Flag            | Argument                          | Description                          |
| --------------- | --------------------------------- | ------------------------------------ |
| `-L`            | `<depth>`                         | Limit depth (e.g., `-L 2`)           |
| `-d`            | -                                 | Directories only                     |
| `-a`            | -                                 | Show hidden files                    |
| `-e`            | `<name>`                          | Exclude pattern (repeatable)         |
| `-i`            | -                                 | Show detailed metadata               |
| `-s`            | -                                 | Hide file sizes                      |
| `-c`            | `<ext...>`                        | Display file contents for extensions |
| `-g`            | `<pattern>`                       | Grep search with context             |
| `--git`         | -                                 | Respect `.gitignore`                 |
| `--stats`       | -                                 | Show language statistics             |
| `--md`          | -                                 | Output as Markdown                   |
| `--json`        | -                                 | Output as JSON                       |
| `--prompt`      | -                                 | AI-friendly mode (no colors)         |
| `--big`         | -                                 | Highlight large files (>5MB)         |
| `--dupes`       | -                                 | Find duplicate files                 |
| `--audit`       | -                                 | Security audit mode                  |
| `--sort`        | `name\|size\|time`                | Sort files                           |
| `--group`       | -                                 | Group by extension                   |
| `--focus`       | `<ext...>`                        | Show only relevant dirs              |
| `--tests`       | -                                 | Highlight test files                 |
| `--fingerprint` | -                                 | Project summary                      |
| `--resolve`     | -                                 | Resolve symlinks                     |
| `--theme`       | `default\|nord\|gruvbox\|dracula` | Color theme                          |

---

## 💡 Pro Tips

1. **Combine flags for power**: `./tree.sh --git --stats --big -L 3`

2. **Pipe to files**: Most output works great piped to files

   ```bash
   ./tree.sh --json > structure.json
   ./tree.sh --prompt -c go > codebase.txt
   ```

3. **Use with watch** for live monitoring:

   ```bash
   watch -n 2 './tree.sh -L 2'
   ```

4. **Create aliases** for common workflows:

   ```bash
   alias t='./tree.sh --git -L 2'
   alias tfp='./tree.sh --fingerprint'
   alias tprompt='./tree.sh --prompt -c go tsx ts py'
   ```

5. **Integration with Claude/ChatGPT**:
   ```bash
   ./tree.sh --prompt -c go tsx ts | pbcopy  # macOS
   ./tree.sh --prompt -c go tsx ts | xclip   # Linux
   ```

---

## 🔧 Installation

### Option 1: Direct Download

```bash
curl -o tree.sh https://your-url/tree.sh
chmod +x tree.sh
./tree.sh
```

### Option 2: Add to PATH

```bash
sudo cp tree.sh /usr/local/bin/etree
etree --help
```

### Option 3: Development Setup

```bash
git clone your-repo
cd your-repo
chmod +x tree.sh
ln -s $(pwd)/tree.sh /usr/local/bin/etree
```

---

## 🧪 Examples Output

### Fingerprint Mode

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

=== Git Status ===
Branch: main
Commits: 487

=== Largest Files (Top 10) ===
  5M dist/bundle.js
  2M package-lock.json
  850K node_modules/...
```

### Grep Mode

```
src/
├── auth/
│   ├── token.go
│   │   ╭── matches ──
│   │   │ 45: // TODO: rotate refresh tokens
│   │   │ 67: // TODO: add rate limiting
│   │   ╰─────────────
```

---

## 🤝 Contributing

Ideas for new features? Found a bug? Contributions welcome!

---

## 📝 License

MIT License - Use freely, modify, share

---

## 🙏 Credits

Built to solve real developer pain points. Inspired by:

- The classic `tree` command
- Modern IDE file explorers
- Developer workflow optimization

---

**Happy tree-ing! 🌳**

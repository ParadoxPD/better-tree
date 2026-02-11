# 🌳 Enhanced Tree

[![Bash](https://img.shields.io/badge/Bash-5.0%2B-121011?logo=gnu-bash)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue)]()
[![GitHub stars](https://img.shields.io/github/stars/YOUR_USERNAME/YOUR_REPO?style=social)]()
[![GitHub forks](https://img.shields.io/github/forks/YOUR_USERNAME/YOUR_REPO?style=social)]()

> The ultimate directory visualization and code inspection tool for developers.

Enhanced Tree is a powerful Bash-based alternative to the classic `tree` command.
It goes beyond structure visualization — enabling code inspection, repository analysis, AI-ready exports, security scanning, and more.

---

## ✨ Why Enhanced Tree?

Traditional `tree` shows folders.

**Enhanced Tree shows insight.**

- 🔎 Search inside files
- 📄 Print source inline
- 📊 Analyze language usage
- 🔐 Run security audits
- 🤖 Generate AI-ready code snapshots
- 🎨 Beautiful themes
- 📦 Export to Markdown or JSON

All from one portable Bash script.

---

# 🚀 Installation

### Option 1 — Direct Download

```bash
chmod +x better-tree.sh
./better-tree.sh
```

### Option 2 — Add to PATH (Recommended)

```bash
sudo cp better-tree.sh /usr/local/bin/etree
etree --help
```

Now you can run:

```bash
etree
```

---

# ⚡ Quick Examples

### Basic Usage

```bash
./better-tree.sh
./better-tree.sh -L 2
./better-tree.sh --git
```

### Code Inspection

```bash
./better-tree.sh -c go tsx        # Show file contents
./better-tree.sh -g "TODO"        # Search across project
./better-tree.sh --clip 50 -c go  # Limit output lines
```

### Project Analysis

```bash
./better-tree.sh --stats
./better-tree.sh --fingerprint
./better-tree.sh --big --git
./better-tree.sh --dupes
./better-tree.sh --audit
```

### AI Mode

```bash
./better-tree.sh --prompt -c go tsx ts py > prompt.txt
```

Paste into ChatGPT/Claude for instant code review.

---

# 🧠 Feature Overview

## 📁 Core Navigation

| Feature          | Flag           |
| ---------------- | -------------- |
| Depth limit      | `-L <n>`       |
| Hidden files     | `-a`           |
| Directories only | `-d`           |
| Exclude pattern  | `-e <pattern>` |

---

## 🔍 Code Inspection

| Feature              | Flag           |
| -------------------- | -------------- |
| Print file contents  | `-c <ext...>`  |
| Search inside files  | `-g <pattern>` |
| Line clipping        | `--clip <n>`   |
| Disable clipping     | `--no-clip`    |
| Highlight test files | `--tests`      |

---

## 📊 Analysis & Intelligence

| Feature               | Flag            |
| --------------------- | --------------- |
| Language stats        | `--stats`       |
| Project fingerprint   | `--fingerprint` |
| Duplicate finder      | `--dupes`       |
| Security audit        | `--audit`       |
| Highlight large files | `--big`         |

---

## 🎨 Display Options

| Feature            | Flag                                 |
| ------------------ | ------------------------------------ |
| Themes             | `--theme nord \| gruvbox \| dracula` |
| Hide sizes         | `-s`                                 |
| Detailed metadata  | `-i`                                 |
| Resolve symlinks   | `--resolve`                          |
| Sorting            | `--sort name\|size\|time`            |
| Group by extension | `--group`                            |

---

## 📦 Output Formats

| Format      | Flag       |
| ----------- | ---------- |
| Markdown    | `--md`     |
| JSON        | `--json`   |
| AI-friendly | `--prompt` |

---

# 🎨 Themes

```bash
./better-tree.sh --theme nord
./better-tree.sh --theme gruvbox
./better-tree.sh --theme dracula
```

- **Default** — Clean professional
- **Nord** — Arctic cool blues
- **Gruvbox** — Warm retro contrast
- **Dracula** — Dark modern palette

---

# 🔥 Real-World Workflows

## Understand a New Codebase

```bash
./better-tree.sh --fingerprint --git
./better-tree.sh -L 2 --focus go tsx
```

---

## Pre-Commit Checklist

```bash
./better-tree.sh --big --git
./better-tree.sh -g "TODO|FIXME" --git
./better-tree.sh --audit -g "password|secret"
```

---

## Generate Documentation

```bash
./better-tree.sh --md -L 3 > STRUCTURE.md
./better-tree.sh --json > structure.json
```

---

## AI Code Review

```bash
./better-tree.sh --prompt -c go tsx ts py | pbcopy
```

Paste into your AI tool and ask:

> “Review this codebase and suggest improvements.”

---

# 📊 Example Output (Fingerprint Mode)

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
```

---

# 🛠 Requirements

- Bash 5+
- macOS or Linux
- Optional:
  - `git` (for `--git`)
  - `md5sum` or `md5`
  - `jq` (for JSON piping)

---

# 🤝 Contributing

Contributions welcome.

Ideas for improvement:

- Performance optimizations
- Plugin system
- Windows compatibility
- Interactive TUI mode

Open an issue or submit a PR.

---

# 📄 License

MIT License — free to use, modify, and distribute.

---

# ⭐ Support the Project

If you find this useful:

- ⭐ Star the repo
- 🍴 Fork it
- 📢 Share it with other developers

---

**Happy tree-ing.** 🌳

> Made with ❤️ by Paradox

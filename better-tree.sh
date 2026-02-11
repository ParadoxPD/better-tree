#!/usr/bin/env bash

# =========================================================
# Enhanced Tree — Ultimate Developer Tool
# =========================================================

# ---------- Colors & Themes ----------
declare -A THEMES

THEMES[default]="
C_RESET=\$'\\e[0m'
C_DIR=\$'\\e[1;34m'
C_FILE=\$'\\e[0;37m'
C_EXEC=\$'\\e[1;32m'
C_LINK=\$'\\e[1;36m'
C_SIZE=\$'\\e[0;33m'
C_META=\$'\\e[0;35m'
C_CONTENT=\$'\\e[0;96m'
C_HEADER=\$'\\e[1;95m'
C_FLAG=\$'\\e[1;32m'
C_ARG=\$'\\e[1;36m'
C_EX=\$'\\e[0;90m'
C_MATCH=\$'\\e[1;33m'
C_WARN=\$'\\e[1;31m'
C_TEST=\$'\\e[1;92m'
"

THEMES[nord]="
C_RESET=\$'\\e[0m'
C_DIR=\$'\\e[38;5;81m'
C_FILE=\$'\\e[38;5;216m'
C_EXEC=\$'\\e[38;5;150m'
C_LINK=\$'\\e[38;5;139m'
C_SIZE=\$'\\e[38;5;179m'
C_META=\$'\\e[38;5;109m'
C_CONTENT=\$'\\e[38;5;144m'
C_HEADER=\$'\\e[1;38;5;143m'
C_FLAG=\$'\\e[1;38;5;150m'
C_ARG=\$'\\e[1;38;5;109m'
C_EX=\$'\\e[38;5;242m'
C_MATCH=\$'\\e[1;38;5;222m'
C_WARN=\$'\\e[1;38;5;204m'
C_TEST=\$'\\e[1;38;5;158m'
"

THEMES[gruvbox]="
C_RESET=\$'\\e[0m'
C_DIR=\$'\\e[38;5;109m'
C_FILE=\$'\\e[38;5;223m'
C_EXEC=\$'\\e[38;5;142m'
C_LINK=\$'\\e[38;5;175m'
C_SIZE=\$'\\e[38;5;214m'
C_META=\$'\\e[38;5;167m'
C_CONTENT=\$'\\e[38;5;108m'
C_HEADER=\$'\\e[1;38;5;214m'
C_FLAG=\$'\\e[1;38;5;142m'
C_ARG=\$'\\e[1;38;5;109m'
C_EX=\$'\\e[38;5;243m'
C_MATCH=\$'\\e[1;38;5;208m'
C_WARN=\$'\\e[1;38;5;167m'
C_TEST=\$'\\e[1;38;5;142m'
"

THEMES[dracula]="
C_RESET=\$'\\e[0m'
C_DIR=\$'\\e[38;5;141m'
C_FILE=\$'\\e[38;5;117m'
C_EXEC=\$'\\e[38;5;84m'
C_LINK=\$'\\e[38;5;212m'
C_SIZE=\$'\\e[38;5;228m'
C_META=\$'\\e[38;5;61m'
C_CONTENT=\$'\\e[38;5;139m'
C_HEADER=\$'\\e[1;38;5;212m'
C_FLAG=\$'\\e[1;38;5;84m'
C_ARG=\$'\\e[1;38;5;141m'
C_EX=\$'\\e[38;5;239m'
C_MATCH=\$'\\e[1;38;5;215m'
C_WARN=\$'\\e[1;38;5;203m'
C_TEST=\$'\\e[1;38;5;120m'
"

CURRENT_THEME="default"

load_theme() {
    local theme_code="${THEMES[$1]}"
    if [[ -z "$theme_code" ]]; then
        echo "Unknown theme: $1. Using default."
        theme_code="${THEMES[default]}"
    fi
    eval "$theme_code"
}

load_theme "$CURRENT_THEME"

if [[ ! -t 1 ]]; then
    C_RESET=""
    C_DIR=""
    C_FILE=""
    C_EXEC=""
    C_LINK=""
    C_SIZE=""
    C_META=""
    C_CONTENT=""
    C_HEADER=""
    C_FLAG=""
    C_ARG=""
    C_EX=""
    C_MATCH=""
    C_WARN=""
    C_TEST=""
fi

ce() {
    printf "%s%s%s\n" "$1" "$2" "$C_RESET"
}

# ---------- Defaults ----------
MAX_DEPTH=-1
SHOW_HIDDEN=false
SHOW_SIZE=true
SHOW_INFO=false
DIR_ONLY=false
TARGET_DIR="."
EXCLUDES=()
CAT_EXTS=()
GREP_PATTERN=""
USE_GITIGNORE=false
SHOW_STATS=false
OUTPUT_MD=false
OUTPUT_JSON=false
PROMPT_MODE=false
HIGHLIGHT_BIG=false
BIG_THRESHOLD=$((5 * 1024 * 1024)) # 5MB
FIND_DUPES=false
AUDIT_MODE=false
SORT_MODE="name" # name, size, time
GROUP_BY_EXT=false
FOCUS_EXTS=()
SHOW_TESTS=false
FINGERPRINT_MODE=false
RESOLVE_SYMLINKS=false
NO_CLIP=false
CLIP=100

DIR_COUNT=0
FILE_COUNT=0
declare -A LANG_STATS
declare -A FILE_HASHES
DUPLICATE_FILES=()

# ---------- Help ----------
usage() {
    cat <<EOF
${C_HEADER}Enhanced Tree — Ultimate Developer Tool${C_RESET}

${C_FLAG}USAGE${C_RESET}
  ./tree.sh [OPTIONS] [DIRECTORY]

${C_FLAG}NAVIGATION${C_RESET}
  ${C_FLAG}-L${C_RESET} ${C_ARG}<depth>${C_RESET}        Limit depth
  ${C_FLAG}-d${C_RESET}                Directories only
  ${C_FLAG}-a${C_RESET}                Show hidden files
  ${C_FLAG}-e${C_RESET} ${C_ARG}<name>${C_RESET}         Exclude pattern (repeatable)

${C_FLAG}DISPLAY${C_RESET}
  ${C_FLAG}-i${C_RESET}                Detailed metadata (ls-like)
  ${C_FLAG}-s${C_RESET}                Disable size display
  ${C_FLAG}--theme${C_RESET} ${C_ARG}<name>${C_RESET}    Color theme (default|nord|gruvbox|dracula)

${C_FLAG}INSPECT FILES${C_RESET}
  ${C_FLAG}-c${C_RESET} ${C_ARG}<ext...>${C_RESET}       Print contents of matching extensions
                     ${C_EX}Example: -c go tsx ts py${C_RESET}
  ${C_FLAG}-g${C_RESET} ${C_ARG}<pattern>${C_RESET}      Grep mode - search inside files
  ${C_FLAG}--tests${C_RESET}            Highlight test files

${C_FLAG}GIT & FILTERING${C_RESET}
  ${C_FLAG}--git${C_RESET}              Respect .gitignore
  ${C_FLAG}--focus${C_RESET} ${C_ARG}<ext...>${C_RESET}  Show only dirs containing these extensions

${C_FLAG}ANALYSIS${C_RESET}
  ${C_FLAG}--stats${C_RESET}            Language statistics
  ${C_FLAG}--big${C_RESET}              Highlight large files (>5MB)
  ${C_FLAG}--dupes${C_RESET}            Find duplicate files
  ${C_FLAG}--audit${C_RESET}            Security audit (executables, permissions)
  ${C_FLAG}--fingerprint${C_RESET}      Project profile summary

${C_FLAG}ORGANIZATION${C_RESET}
  ${C_FLAG}--sort${C_RESET} ${C_ARG}<mode>${C_RESET}     Sort by: name|size|time
  ${C_FLAG}--group${C_RESET}            Group files by extension
  ${C_FLAG}--resolve${C_RESET}          Resolve symlinks to real paths

${C_FLAG}OUTPUT FORMATS${C_RESET}
  ${C_FLAG}--md${C_RESET}               Markdown export
  ${C_FLAG}--json${C_RESET}             JSON output
  ${C_FLAG}--prompt${C_RESET}           AI-friendly mode (no colors, with code)

${C_FLAG}EXAMPLES${C_RESET}
  ./tree.sh                                    ${C_EX}# Basic tree${C_RESET}
  ./tree.sh -L 2 --git                         ${C_EX}# Respect .gitignore, depth 2${C_RESET}
  ./tree.sh -g "TODO" -c go                    ${C_EX}# Find TODOs in Go files${C_RESET}
  ./tree.sh --stats --big                      ${C_EX}# Project overview${C_RESET}
  ./tree.sh --prompt -c go tsx > prompt.txt    ${C_EX}# Generate AI prompt${C_RESET}
  ./tree.sh --fingerprint                      ${C_EX}# Project summary${C_RESET}
  ./tree.sh --focus go tsx --theme nord        ${C_EX}# Focus on Go/TSX, Nord theme${C_RESET}
EOF
    exit 0
}

# ---------- Utils ----------
format_size() {
    local s=$1
    ((s < 1024)) && echo "${s}B" && return
    ((s < 1048576)) && echo "$((s / 1024))K" && return
    ((s < 1073741824)) && echo "$((s / 1048576))M" && return
    echo "$((s / 1073741824))G"
}

is_excluded() {
    local n=$1
    for e in "${EXCLUDES[@]}"; do
        [[ "$n" == $e ]] && return 0
    done
    return 1
}

should_cat() {
    local name=$1
    [[ ${#CAT_EXTS[@]} -eq 0 ]] && return 1
    for ext in "${CAT_EXTS[@]}"; do
        [[ "$name" == *."$ext" ]] && return 0
    done
    return 1
}

get_info() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ls -ld "$1" | awk '{print $1, $3, $6, $7, $8}'
    else
        ls -ld "$1" | awk '{print $1, $3, $6, $7, $8}'
    fi
}

get_extension() {
    local name=$1
    if [[ "$name" == *.* ]]; then
        echo "${name##*.}"
    else
        echo "no-ext"
    fi
}

is_test_file() {
    local name=$1
    [[ "$name" == *_test.* ]] && return 0
    [[ "$name" == *.test.* ]] && return 0
    [[ "$name" == *Test.* ]] && return 0
    [[ "$name" == *Spec.* ]] && return 0
    [[ "$name" == *.spec.* ]] && return 0
    return 1
}

is_git_ignored() {
    local path=$1
    [[ ! $USE_GITIGNORE == true ]] && return 1

    # Check if we're in a git repo
    if ! git rev-parse --git-dir &>/dev/null; then
        return 1
    fi

    # Use git check-ignore
    git check-ignore -q "$path" 2>/dev/null && return 0
    return 1
}

calculate_hash() {
    if command -v md5sum &>/dev/null; then
        md5sum "$1" 2>/dev/null | awk '{print $1}'
    elif command -v md5 &>/dev/null; then
        md5 -q "$1" 2>/dev/null
    else
        echo "unknown"
    fi
}

has_focus_extension() {
    local dir=$1
    [[ ${#FOCUS_EXTS[@]} -eq 0 ]] && return 0

    local found=false
    while IFS= read -r -d '' file; do
        local name
        name=$(basename "$file")
        for ext in "${FOCUS_EXTS[@]}"; do
            if [[ "$name" == *."$ext" ]]; then
                found=true
                break 2
            fi
        done
    done < <(find "$dir" -type f -print0 2>/dev/null)

    $found && return 0
    return 1
}

get_file_size() {
    local file=$1
    if [[ "$OSTYPE" == "darwin"* ]]; then
        stat -f%z "$file" 2>/dev/null || echo 0
    else
        stat -c%s "$file" 2>/dev/null || echo 0
    fi
}

get_file_mtime() {
    local file=$1
    if [[ "$OSTYPE" == "darwin"* ]]; then
        stat -f%m "$file" 2>/dev/null || echo 0
    else
        stat -c%Y "$file" 2>/dev/null || echo 0
    fi
}

# ---------- JSON Output ----------
json_escape() {
    local s=$1
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    echo "$s"
}

print_json_tree() {
    local dir=$1 depth=$2 is_last=$3

    [[ $MAX_DEPTH -ge 0 && $depth -gt $MAX_DEPTH ]] && return

    local name
    local size
    name=$(basename "$dir")
    size=$(get_file_size "$dir")
    local type="directory"

    echo -n "{"
    echo -n "\"name\":\"$(json_escape "$name")\","
    echo -n "\"type\":\"$type\","
    echo -n "\"path\":\"$(json_escape "$dir")\","
    echo -n "\"children\":["

    shopt -s nullglob
    $SHOW_HIDDEN && shopt -s dotglob || shopt -u dotglob

    local items=("$dir"/*)
    IFS=$'\n' items=($(sort <<<"${items[*]}"))
    unset IFS

    local total=${#items[@]}
    local idx=0
    local first=true

    for item in "${items[@]}"; do
        local item_name
        item_name=$(basename "$item")
        is_excluded "$item_name" && continue
        is_git_ignored "$item" && continue

        ((idx++))

        if [[ -d "$item" ]]; then
            $first || echo -n ","
            first=false
            print_json_tree "$item" $((depth + 1)) $((idx == total))
        elif [[ -f "$item" ]]; then
            $first || echo -n ","
            first=false
            local fsize
            fsize=$(get_file_size "$item")
            echo -n "{"
            echo -n "\"name\":\"$(json_escape "$item_name")\","
            echo -n "\"type\":\"file\","
            echo -n "\"path\":\"$(json_escape "$item")\","
            echo -n "\"size\":$fsize"
            echo -n "}"
        fi
    done

    echo -n "]}"
}

# ---------- Markdown Output ----------
print_md_tree() {
    local dir=$1 prefix=$2 depth=$3

    [[ $MAX_DEPTH -ge 0 && $depth -gt $MAX_DEPTH ]] && return

    shopt -s nullglob
    $SHOW_HIDDEN && shopt -s dotglob || shopt -u dotglob

    local items=("$dir"/*)
    IFS=$'\n' items=($(sort <<<"${items[*]}"))
    unset IFS

    for item in "${items[@]}"; do
        local name
        name=$(basename "$item")
        is_excluded "$name" && continue
        is_git_ignored "$item" && continue

        if [[ -d "$item" ]]; then
            echo "${prefix}- **${name}/**"
            print_md_tree "$item" "${prefix}  " $((depth + 1))
        elif [[ -f "$item" ]]; then
            echo "${prefix}- ${name}"
        fi
    done
}

# ---------- Core Tree ----------
print_tree() {
    local dir=$1 prefix=$2 depth=$3

    [[ $MAX_DEPTH -ge 0 && $depth -gt $MAX_DEPTH ]] && return

    shopt -s nullglob
    $SHOW_HIDDEN && shopt -s dotglob || shopt -u dotglob

    local items=("$dir"/*)

    # Apply sorting
    case $SORT_MODE in
    size)
        IFS=$'\n' items=($(for item in "${items[@]}"; do
            if [[ -f "$item" ]]; then
                echo "$(get_file_size "$item") $item"
            else
                echo "0 $item"
            fi
        done | sort -rn | cut -d' ' -f2-))
        unset IFS
        ;;
    time)
        IFS=$'\n' items=($(for item in "${items[@]}"; do
            echo "$(get_file_mtime "$item") $item"
        done | sort -rn | cut -d' ' -f2-))
        unset IFS
        ;;
    *)
        IFS=$'\n' items=($(sort <<<"${items[*]}"))
        unset IFS
        ;;
    esac

    local total=${#items[@]}
    local idx=0

    for item in "${items[@]}"; do
        ((idx++))
        local name
        name=$(basename "$item")

        is_excluded "$name" && continue
        is_git_ignored "$item" && continue

        if [[ ${#FOCUS_EXTS[@]} -gt 0 && -d "$item" ]]; then
            has_focus_extension "$item" || continue
        fi

        $DIR_ONLY && [[ ! -d "$item" ]] && continue

        local branch next_prefix
        if ((idx == total)); then
            branch="└── "
            next_prefix="${prefix}    "
        else
            branch="├── "
            next_prefix="${prefix}│   "
        fi

        # Print this item
        print_single_item "$item" "$prefix" "$branch" "$next_prefix"

        # Recurse ONLY here
        if [[ -d "$item" ]]; then
            ((DIR_COUNT++))
            print_tree "$item" "$next_prefix" $((depth + 1))
        else
            ((FILE_COUNT++))
        fi
    done

}

print_single_item() {
    local item=$1
    local prefix=$2
    local branch=$3
    local next_prefix=$4
    local name
    name=$(basename "$item")

    local info=""
    local size=0

    if $SHOW_INFO; then
        info+="${C_META}[$(get_info "$item")] ${C_RESET}"
    fi

    if [[ -f "$item" ]]; then
        size=$(get_file_size "$item")
        $SHOW_SIZE && info+="${C_SIZE}[$(format_size "$size")] ${C_RESET}"

        if $HIGHLIGHT_BIG && ((size > BIG_THRESHOLD)); then
            info+="${C_WARN}[LARGE] ${C_RESET}"
        fi
    fi

    echo -ne "${prefix}${C_META}${branch}${C_RESET}${info}"

    if [[ -L "$item" ]]; then
        if $RESOLVE_SYMLINKS; then
            ce "$C_LINK" "$name -> $(realpath "$item")"
        else
            ce "$C_LINK" "$name -> $(readlink "$item")"
        fi

    elif [[ -d "$item" ]]; then
        if $SHOW_TESTS && [[ "$name" == *test* || "$name" == *Test* ]]; then
            ce "$C_TEST" "$name/"
        else
            ce "$C_DIR" "$name/"
        fi

    elif [[ -f "$item" ]]; then
        if $SHOW_TESTS && is_test_file "$name"; then
            ce "$C_TEST" "$name"
        else
            if [[ -x "$item" ]]; then
                ce "$C_EXEC" "$name*"
            else
                ce "$C_FILE" "$name"
            fi
        fi
        # ---- grep ----
        if [[ -n "$GREP_PATTERN" ]] && grep -q "$GREP_PATTERN" "$item" 2>/dev/null; then
            ce "$C_CONTENT" "${next_prefix}    ╭── matches ──"
            grep -n "$GREP_PATTERN" "$item" | head -5 | while read -r line; do
                ce "$C_CONTENT" "${next_prefix}    │ $line"
            done
            ce "$C_CONTENT" "${next_prefix}    ╰─────────────"
        fi

        # ---- cat ----
        if should_cat "$name"; then
            ce "$C_CONTENT" "${next_prefix}    ╭── content of $name ──"
            if $NO_CLIP; then
                while IFS= read -r line; do
                    ce "$C_CONTENT" "${next_prefix}    │ $line"
                done <"$item"
            else
                while IFS= read -r line; do
    ce "$C_CONTENT" "${next_prefix}    │ $line"
done < <(head -n "$CLIP" "$item")
           fi
            ce "$C_CONTENT" "${next_prefix}    ╰────────────────────────"
        fi

        if $AUDIT_MODE; then
            audit_file "$item"
        fi

    fi
}

# ---------- Stats Display ----------
print_stats() {
    if [[ ${#LANG_STATS[@]} -eq 0 ]]; then
        echo "No files found."
        return
    fi

    echo
    ce "$C_HEADER" "=== Language Statistics ==="

    # Sort by count
    for ext in "${!LANG_STATS[@]}"; do
        echo "${LANG_STATS[$ext]} $ext"
    done | sort -rn | while read count ext; do
        ce "$C_META" "  $ext: ${C_FILE}$count files${C_RESET}"
    done
}

# ---------- Fingerprint ----------
print_fingerprint() {
    ce "$C_HEADER" "=== Project Fingerprint ==="
    echo
    ce "$C_META" "Directory: ${C_FILE}$TARGET_DIR${C_RESET}"
    ce "$C_META" "Total Directories: ${C_FILE}$DIR_COUNT${C_RESET}"
    ce "$C_META" "Total Files: ${C_FILE}$FILE_COUNT${C_RESET}"

    # Calculate total size
    local total_size=0
    while IFS= read -r -d '' file; do
        local fsize
        fsize=$(get_file_size "$file")
        ((total_size += fsize))
    done < <(find "$TARGET_DIR" -type f -print0 2>/dev/null)
    ce "$C_META" "Total Size: ${C_FILE}$(format_size $total_size)${C_RESET}"

    # Max depth
    local max_depth_found=0
    while IFS= read -r dir; do
        local depth
        depth=$(echo "$dir" | tr -cd '/' | wc -c)
        ((depth > max_depth_found)) && max_depth_found=$depth
    done < <(find "$TARGET_DIR" -type d 2>/dev/null)
    ce "$C_META" "Max Depth: ${C_FILE}$max_depth_found${C_RESET}"

    echo
    print_stats

    # Git status
    if git rev-parse --git-dir &>/dev/null; then
        echo
        ce "$C_HEADER" "=== Git Status ==="
        local branch
        branch=$(git branch --show-current 2>/dev/null)
        ce "$C_META" "Branch: ${C_FILE}$branch${C_RESET}"

        local commits
        commits=$(git rev-list --count HEAD 2>/dev/null)
        ce "$C_META" "Commits: ${C_FILE}$commits${C_RESET}"
    fi

    # Largest files
    echo
    ce "$C_HEADER" "=== Largest Files (Top 10) ==="
    find "$TARGET_DIR" -type f -print0 2>/dev/null | while IFS= read -r -d '' file; do
        local size
        size=$(get_file_size "$file")
        echo "$size $file"
    done | sort -rn | head -10 | while read size file; do
        local rel_path
        rel_path=${file#$TARGET_DIR/}
        ce "$C_SIZE" "  $(format_size $size) ${C_FILE}$rel_path${C_RESET}"
    done
}

print_grouped_view() {
    local dir=$1
    declare -A grouped

    while IFS= read -r -d '' file; do
        local name
        local ext
        name=$(basename "$file")
        ext=$(get_extension "$name")
        grouped[$ext]+="$file"$'\n'
    done < <(find "$dir" -type f -print0 2>/dev/null)

    ce "$C_DIR" "$dir/"
    echo

    for ext in "${!grouped[@]}"; do
        ce "$C_HEADER" "[$ext]"
        while IFS= read -r file; do
            [[ -z "$file" ]] && continue
            ce "$C_FILE" "  $(realpath --relative-to="$dir" "$file" 2>/dev/null || echo "$file")"
        done <<<"${grouped[$ext]}"
        echo
    done
}

audit_file() {
    local file=$1
    local perm
    perm=$(stat -c "%A" "$file" 2>/dev/null || stat -f "%Sp" "$file")

    # World writable
    if [[ "$perm" == *w*w* ]]; then
        ce "$C_WARN" "  ⚠ World-writable: $file"
    fi

    # Executable in weird places
    if [[ -x "$file" && "$file" != *.sh && "$file" != *.go && "$file" != *.ts ]]; then
        ce "$C_WARN" "  ⚠ Suspicious executable: $file"
    fi

    # Secrets
    if grep -qiE "password|secret|token|apikey" "$file" 2>/dev/null; then
        ce "$C_WARN" "  ⚠ Possible secret in: $file"
    fi
}

generate_prompt_dump() {
    local dir=$1

    {
        echo "# Project Structure"
        echo '```'
        print_tree "$dir" "" 0
        echo '```'
        echo

        echo "# Source Files"
        echo

        while IFS= read -r -d '' file; do
            ext="${file##*.}"
            case "$ext" in
            go | ts | tsx | js | jsx | py | json | md | yaml | yml | sh | java | dart | kt | kts)
                echo "## File: ${file#$dir/}"
                echo '```'"$ext"
                sed 's/\t/    /g' "$file"
                echo '```'
                echo
                ;;
            esac
        done < <(find "$dir" -type f -print0)
    } | tee /tmp/tree_prompt.txt

    # Copy to clipboard
    if command -v xclip &>/dev/null; then
        xclip -sel clipboard </tmp/tree_prompt.txt
        echo
        ce "$C_HEADER" "Prompt copied to clipboard ✓"
    fi
}

# ---------- Args ----------
while [[ $# -gt 0 ]]; do
    case $1 in
    -L)
        MAX_DEPTH="$2"
        shift 2
        ;;
    -e | --exclude)
        EXCLUDES+=("$2")
        shift 2
        ;;
    -a)
        SHOW_HIDDEN=true
        shift
        ;;
    -d)
        DIR_ONLY=true
        shift
        ;;
    -s)
        SHOW_SIZE=false
        shift
        ;;
    -i)
        SHOW_INFO=true
        shift
        ;;
    -c | --cat)
        shift
        while [[ $# -gt 0 && $1 != -* ]]; do
            CAT_EXTS+=("$1")
            shift
        done
        ;;
    -g | --grep)
        GREP_PATTERN="$2"
        shift 2
        ;;
    --git)
        USE_GITIGNORE=true
        shift
        ;;
    --stats)
        SHOW_STATS=true
        shift
        ;;
    --md)
        OUTPUT_MD=true
        shift
        ;;
    --json)
        OUTPUT_JSON=true
        shift
        ;;
    --clip)
        CLIP="$2"
        shift 2
        ;;
    --nc | --no-clip)
        NO_CLIP=true
        shift
        ;;
    --prompt)
        PROMPT_MODE=true
        # Disable colors for AI consumption
        C_RESET=""
        C_DIR=""
        C_FILE=""
        C_EXEC=""
        C_LINK=""
        C_SIZE=""
        C_META=""
        C_CONTENT=""
        C_HEADER=""
        C_FLAG=""
        C_ARG=""
        C_EX=""
        C_MATCH=""
        C_WARN=""
        C_TEST=""
        shift
        ;;
    --big)
        HIGHLIGHT_BIG=true
        shift
        ;;
    --dupes)
        FIND_DUPES=true
        shift
        ;;
    --audit)
        AUDIT_MODE=true
        shift
        ;;
    --sort)
        SORT_MODE="$2"
        shift 2
        ;;
    --group)
        GROUP_BY_EXT=true
        shift
        ;;
    --focus)
        shift
        while [[ $# -gt 0 && $1 != -* ]]; do
            FOCUS_EXTS+=("$1")
            shift
        done
        ;;
    --tests)
        SHOW_TESTS=true
        shift
        ;;
    --fingerprint)
        FINGERPRINT_MODE=true
        shift
        ;;
    --resolve)
        RESOLVE_SYMLINKS=true
        shift
        ;;
    --theme)
        CURRENT_THEME="$2"
        load_theme "$CURRENT_THEME"
        shift 2
        ;;
    -h | --help)
        usage
        ;;
    --)
        shift
        break
        ;;
    -*)
        echo "Unknown option: $1"
        usage
        ;;
    *)
        TARGET_DIR="$1"
        shift
        ;;
    esac
done

# ---------- Validation ----------
[[ ! -d "$TARGET_DIR" ]] && {
    echo "Directory not found: $TARGET_DIR"
    exit 1
}

# ---------- Run ----------
if $PROMPT_MODE; then
    generate_prompt_dump "$TARGET_DIR"
    exit 0
elif $OUTPUT_JSON; then
    echo "{"
    echo "\"root\":"
    print_json_tree "$TARGET_DIR" 0 true
    echo "}"
elif $OUTPUT_MD; then
    echo "# Directory Structure: $TARGET_DIR"
    echo
    print_md_tree "$TARGET_DIR" "" 0
elif $FINGERPRINT_MODE; then
    # First collect the data
    if $GROUP_BY_EXT; then
        print_grouped_view "$TARGET_DIR"
        exit 0
    fi

    print_tree "$TARGET_DIR" "" 0 >/dev/null
    print_fingerprint
else
    # Normal tree output
    ce "$C_DIR" "$TARGET_DIR/"
    if $GROUP_BY_EXT; then
        print_grouped_view "$TARGET_DIR"
        exit 0
    fi

    print_tree "$TARGET_DIR" "" 0
    echo

    if $DIR_ONLY; then
        ce "$C_META" "$DIR_COUNT directories"
    else
        ce "$C_META" "$DIR_COUNT directories, $FILE_COUNT files"
    fi

    if $SHOW_STATS; then
        print_stats
    fi

    if $FIND_DUPES && [[ ${#DUPLICATE_FILES[@]} -gt 0 ]]; then
        echo
        ce "$C_HEADER" "=== Duplicate Files ==="
        for dup in "${DUPLICATE_FILES[@]}"; do
            ce "$C_WARN" "  $dup"
        done
    fi
fi

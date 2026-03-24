#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: $0 <team-name> <project-path>"
  echo ""
  echo "  <team-name>     Team to assign (e.g. dev)"
  echo "  <project-path>  Target project directory to configure with the team's agents"
  exit 1
}

if [[ $# -lt 2 ]]; then
  usage
fi

TEAM_NAME="$1"
TEAM_DIR="$SCRIPT_DIR/teams/$TEAM_NAME"

if [[ ! -d "$TEAM_DIR" ]]; then
  echo "Error: team '$TEAM_NAME' not found in $SCRIPT_DIR/teams/" >&2
  exit 1
fi

PROJECT_DIR="$(cd "$2" && pwd)"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "Error: '$2' is not a valid directory" >&2
  exit 1
fi

CLAUDE_DIR="$PROJECT_DIR/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
SKILLS_DIR="$CLAUDE_DIR/skills"

# Create .claude/agents and .claude/skills directories
mkdir -p "$AGENTS_DIR"
mkdir -p "$SKILLS_DIR"

# Copy agent definitions
echo "Copying agent definitions..."
for agent_file in "$TEAM_DIR/agents/"*.md; do
  agent_name="$(basename "$agent_file")"
  target="$AGENTS_DIR/$agent_name"
  if [[ -f "$target" ]]; then
    read -r -p "Warning: .claude/agents/$agent_name already exists. Overwrite? [y/N] " answer
    case "$answer" in
      [yY]) ;;
      *) echo "  Skipped .claude/agents/$agent_name"; continue ;;
    esac
  fi
  cp "$agent_file" "$target"
  echo "  -> .claude/agents/$agent_name"
done

# Copy team SKILL.md to .claude/skills/<skill-name>/SKILL.md
TEAM_SKILL="$TEAM_DIR/SKILL.md"
if [[ -f "$TEAM_SKILL" ]]; then
  skill_name="$(grep '^name:' "$TEAM_SKILL" | head -1 | sed 's/^name:[[:space:]]*//')"
  TARGET_SKILL_DIR="$SKILLS_DIR/$skill_name"
  TARGET_SKILL="$TARGET_SKILL_DIR/SKILL.md"
  if [[ -f "$TARGET_SKILL" ]]; then
    echo ""
    echo "Warning: .claude/skills/$skill_name/SKILL.md already exists."
    read -r -p "Overwrite? [y/N] " answer
    case "$answer" in
      [yY]) ;;
      *) echo "Skipped .claude/skills/$skill_name/SKILL.md"; exit 0 ;;
    esac
  fi
  mkdir -p "$TARGET_SKILL_DIR"
  cp "$TEAM_SKILL" "$TARGET_SKILL"
  echo "Copying team skill..."
  echo "  -> .claude/skills/$skill_name/SKILL.md"
fi

echo ""
echo "Done. $TEAM_NAME team configured in: $PROJECT_DIR"

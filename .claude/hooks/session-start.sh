#!/bin/bash
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

SKILLS_DIR="$HOME/.claude/skills"
SKILLS=(dumbify storytelling viral-hooks anti-ai-writing)

missing=0
for skill in "${SKILLS[@]}"; do
  if [ ! -f "$SKILLS_DIR/$skill/SKILL.md" ]; then
    missing=1
    break
  fi
done

if [ "$missing" -eq 0 ]; then
  exit 0
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

git clone --depth 1 https://github.com/artemnovitckii/content-skills.git "$TMP_DIR/content-skills" >/dev/null 2>&1

mkdir -p "$SKILLS_DIR"
for skill in "${SKILLS[@]}"; do
  if [ -f "$TMP_DIR/content-skills/$skill/SKILL.md" ]; then
    rm -rf "$SKILLS_DIR/$skill"
    cp -r "$TMP_DIR/content-skills/$skill" "$SKILLS_DIR/$skill"
  fi
done

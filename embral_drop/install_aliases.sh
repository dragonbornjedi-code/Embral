#!/bin/bash
# Embral — One-time alias installation script
# Run once on Crucible as your user (joshuar)
# Usage: bash install_aliases.sh

set -e

EMBRAL_DIR="/var/lib/phoenix-ai/workspace/embral"
ALIAS_FILE="$HOME/.embral_aliases.sh"

echo "🔥 Installing Embral AI Aliases..."
echo ""

# ─────────────────────────────────────────
# Step 1: Copy alias file to home directory
# ─────────────────────────────────────────
if [ ! -f ./embral_aliases.sh ]; then
    echo "❌ embral_aliases.sh not found in current directory."
    echo "   Run this script from the folder where you downloaded the files."
    exit 1
fi

cp ./embral_aliases.sh "$ALIAS_FILE"
chmod +x "$ALIAS_FILE"
echo "✅ Copied embral_aliases.sh to $ALIAS_FILE"

# ─────────────────────────────────────────
# Step 2: Add to .bashrc if not already there
# ─────────────────────────────────────────
BASHRC="$HOME/.bashrc"
MARKER="# Embral AI aliases"

if grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
    echo "✅ .bashrc already has Embral aliases sourced."
else
    echo "" >> "$BASHRC"
    echo "$MARKER" >> "$BASHRC"
    echo "source $ALIAS_FILE" >> "$BASHRC"
    echo "✅ Added 'source $ALIAS_FILE' to $BASHRC"
fi

# ─────────────────────────────────────────
# Step 3: Push docs files to repo
# ─────────────────────────────────────────
echo ""
echo "Copying context docs to Embral repo..."

# Copy docs that belong in the repo
mkdir -p "$EMBRAL_DIR/docs"

[ -f ./SESSION.md ]    && cp ./SESSION.md    "$EMBRAL_DIR/docs/SESSION.md"    && echo "✅ SESSION.md"
[ -f ./AI_CONTEXT.md ] && cp ./AI_CONTEXT.md "$EMBRAL_DIR/docs/AI_CONTEXT.md" && echo "✅ AI_CONTEXT.md"
[ -f ./AGENTS.md ]     && cp ./AGENTS.md     "$EMBRAL_DIR/AGENTS.md"          && echo "✅ AGENTS.md"
[ -f ./manifest.yaml ] && cp ./manifest.yaml "$EMBRAL_DIR/manifest.yaml"      && echo "✅ manifest.yaml"
[ -f ./roadmap.md ]    && cp ./roadmap.md    "$EMBRAL_DIR/docs/roadmap.md"    && echo "✅ roadmap.md"

# ─────────────────────────────────────────
# Step 4: Create .cursorrules for Windsurf
# ─────────────────────────────────────────
cat > "$EMBRAL_DIR/.cursorrules" << 'EOF'
Read AGENTS.md before every action.
Read manifest.yaml before creating any file.
Read docs/SESSION.md to understand current state.
Never install dependencies not in manifest.yaml.
Never add SQLite, Ollama, ChromaDB, or any backend AI. SQLite broke the project.
Edit existing files. Never create _fixed _v2 _clean *(1) variants.
Register in manifest.yaml BEFORE creating any file.
Update docs/SESSION.md at end of every session.
Check git status and last 3 commits before writing any code.
EOF
echo "✅ .cursorrules created"

# ─────────────────────────────────────────
# Step 5: Create .kiro/steering.md for Kiro
# ─────────────────────────────────────────
mkdir -p "$EMBRAL_DIR/.kiro"
cat > "$EMBRAL_DIR/.kiro/steering.md" << 'EOF'
# Kiro Steering — Embral

Read docs/AI_CONTEXT.md first.
Read AGENTS.md completely.
Read manifest.yaml completely.
Read docs/SESSION.md for current state.
Run git log --oneline -10 and git status.
Report findings before doing anything.

Core rules:
- SQLite permanently banned. Removed godot-sqlite. Do not re-add.
- No RAG, Ollama, or backend AI.
- Register in manifest.yaml before creating files.
- Edit existing files. Never create variants.
- Hardware always has keyboard fallback.
- Update docs/SESSION.md at session end.
EOF
echo "✅ .kiro/steering.md created"

# ─────────────────────────────────────────
# Step 6: Commit all docs to repo
# ─────────────────────────────────────────
cd "$EMBRAL_DIR"
git add .
git commit -m "chore: install AI alias system and update all foundation docs

- AGENTS.md v2.0: SQLite ban, SESSION.md law, Windsurf-damage notes
- manifest.yaml v2.0: SQLite removed, boot registered, all statuses corrected
- docs/roadmap.md: expanded to phases 0-13 with 130+ steps
- docs/SESSION.md: established session handoff protocol
- docs/AI_CONTEXT.md: master context prompt for all AI CLI tools
- .cursorrules: Windsurf/Cursor compliance rules
- .kiro/steering.md: Kiro steering rules" 2>/dev/null || echo "(nothing new to commit)"

git push 2>/dev/null || echo "(push skipped — run manually if needed)"

# ─────────────────────────────────────────
# Step 7: Source the aliases now
# ─────────────────────────────────────────
source "$ALIAS_FILE"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ INSTALLATION COMPLETE"
echo ""
echo "Available commands (active NOW in this shell):"
echo "  embral          → help + current status"
echo "  gemini          → Gemini CLI with Embral context"
echo "  ccode           → Claude Code in Embral repo"
echo "  kiro            → Kiro with Embral context"
echo "  windsurf        → Windsurf in Embral directory"
echo "  copilot         → GitHub Copilot CLI"
echo "  embral-status   → quick status check"
echo "  embral-session  → update SESSION.md after a session"
echo ""
echo "For ALL future terminals, they load automatically from .bashrc."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

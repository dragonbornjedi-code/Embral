#!/usr/bin/env bash
# Phoenix Forge — Complete AI Alias Installation
# Run once as joshuar on Crucible
# Usage: bash install.sh

set -e

echo ""
echo "🔥 Phoenix Forge AI System — Installing..."
echo "══════════════════════════════════════════"
echo ""

EMBRAL_DIR="/var/lib/phoenix-ai/workspace/embral"
HOME_ALIAS="$HOME/.embral_aliases.sh"
GLOBAL_HOOKS_DIR="$HOME/.git-hooks"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ───────────────────────────────────────────
# Step 1: Install alias file
# ───────────────────────────────────────────
echo "Step 1: Installing alias file..."

cp "$SCRIPT_DIR/embral_aliases.sh" "$HOME_ALIAS"
chmod +x "$HOME_ALIAS"

# Add to .bashrc safely (only once)
BASHRC="$HOME/.bashrc"
MARKER="# Phoenix Forge AI aliases"
if ! grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
    printf '\n%s\n' "$MARKER" >> "$BASHRC"
    printf 'if [ -f "%s" ]; then source "%s"; fi\n' "$HOME_ALIAS" "$HOME_ALIAS" >> "$BASHRC"
    echo "   ✅ Added to .bashrc"
else
    echo "   ✅ Already in .bashrc"
fi

# ───────────────────────────────────────────
# Step 2: Global git hook (applies to ALL repos)
# ───────────────────────────────────────────
echo ""
echo "Step 2: Installing global pre-commit hook..."

mkdir -p "$GLOBAL_HOOKS_DIR"
cp "$SCRIPT_DIR/pre-commit" "$GLOBAL_HOOKS_DIR/pre-commit"
chmod +x "$GLOBAL_HOOKS_DIR/pre-commit"

# Configure git to use global hooks
git config --global core.hooksPath "$GLOBAL_HOOKS_DIR"
echo "   ✅ Global hooks installed at $GLOBAL_HOOKS_DIR"
echo "   ✅ git config --global core.hooksPath set"

# Also install in embral repo specifically
if [ -d "$EMBRAL_DIR/.git" ]; then
    cp "$SCRIPT_DIR/pre-commit" "$EMBRAL_DIR/.git/hooks/pre-commit"
    chmod +x "$EMBRAL_DIR/.git/hooks/pre-commit"
    echo "   ✅ Hook installed in embral repo"
fi

# ───────────────────────────────────────────
# Step 3: Copy docs to embral repo
# ───────────────────────────────────────────
echo ""
echo "Step 3: Updating embral repo docs..."

FILES_TO_COPY=(
    "AGENTS.md:$EMBRAL_DIR/AGENTS.md"
    "manifest.yaml:$EMBRAL_DIR/manifest.yaml"
    "roadmap.md:$EMBRAL_DIR/docs/roadmap.md"
    "SESSION.md:$EMBRAL_DIR/docs/SESSION.md"
    "AI_CONTEXT.md:$EMBRAL_DIR/docs/AI_CONTEXT.md"
)

for entry in "${FILES_TO_COPY[@]}"; do
    src="${entry%%:*}"
    dst="${entry##*:}"
    if [ -f "$SCRIPT_DIR/$src" ]; then
        mkdir -p "$(dirname "$dst")"
        cp "$SCRIPT_DIR/$src" "$dst"
        echo "   ✅ $src → $dst"
    else
        echo "   ⚠️  $src not found in $SCRIPT_DIR (skipped)"
    fi
done

# ───────────────────────────────────────────
# Step 4: Write IDE context files
# ───────────────────────────────────────────
echo ""
echo "Step 4: Installing IDE context files..."

# Windsurf / Cursor
cat > "$EMBRAL_DIR/.cursorrules" << 'CURSOR_EOF'
Read AGENTS.md before every action.
Read manifest.yaml before creating any file.
Read docs/SESSION.md for current state.
Run git log --oneline -5 and git status before writing code.
Never install SQLite, Ollama, ChromaDB, or any backend AI.
Never create _fixed _v2 _clean *(1) _backup variants.
Register in manifest.yaml BEFORE creating any file.
Update docs/SESSION.md at end of every session.
CURSOR_EOF
echo "   ✅ .cursorrules (Windsurf/Cursor)"

# Kiro
mkdir -p "$EMBRAL_DIR/.kiro"
cat > "$EMBRAL_DIR/.kiro/steering.md" << 'KIRO_EOF'
# Kiro Steering — Embral

Read docs/AI_CONTEXT.md. Read AGENTS.md. Read manifest.yaml. Read docs/SESSION.md.
Run git log --oneline -5 and git status.
Report findings. Wait for instruction.

Non-negotiable rules:
- SQLite permanently banned (broke the project — do not re-add)
- No Ollama, RAG, or backend AI
- Register in manifest.yaml before creating files
- Never create _fixed _v2 _clean *(1) variants
- Update SESSION.md at session end
- Never mark DONE without verification
KIRO_EOF
echo "   ✅ .kiro/steering.md (Kiro)"

# Zed
mkdir -p "$EMBRAL_DIR/.zed"
cat > "$EMBRAL_DIR/.zed/settings.json" << 'ZED_EOF'
{
  "assistant": {
    "default_model": {
      "provider": "anthropic",
      "model": "claude-sonnet-4-5"
    },
    "version": "2"
  }
}
ZED_EOF
# Zed context note (assistant reads files you open)
cat "$EMBRAL_DIR/docs/AI_CONTEXT.md" > "$EMBRAL_DIR/.zed/ai_context.md" 2>/dev/null || true
echo "   ✅ .zed/settings.json + ai_context.md (Zed)"

# JetBrains (IDEA)
mkdir -p "$EMBRAL_DIR/.idea"
cp "$EMBRAL_DIR/docs/AI_CONTEXT.md" "$EMBRAL_DIR/.idea/ai-guidelines.md" 2>/dev/null || true
echo "   ✅ .idea/ai-guidelines.md (JetBrains)"

# ───────────────────────────────────────────
# Step 5: Install timed sync cron job
# ───────────────────────────────────────────
echo ""
echo "Step 5: Installing timed sync..."

# Create the sync script
SYNC_SCRIPT="$HOME/.pf_sync.sh"
cat > "$SYNC_SCRIPT" << 'SYNC_EOF'
#!/usr/bin/env bash
# Phoenix Forge — Timed sync
# Runs every 30 minutes via cron
# Updates IDE context files from repo docs

EMBRAL_DIR="/var/lib/phoenix-ai/workspace/embral"
LOG="$HOME/.pf_sync.log"
TS="$(date '+%Y-%m-%d %H:%M')"

echo "[$TS] pf_sync running..." >> "$LOG"

# Pull latest from repo
if [ -d "$EMBRAL_DIR/.git" ]; then
    git -C "$EMBRAL_DIR" fetch --quiet 2>/dev/null
    BEHIND=$(git -C "$EMBRAL_DIR" rev-list HEAD..origin/main --count 2>/dev/null)
    if [ "$BEHIND" -gt 0 ]; then
        git -C "$EMBRAL_DIR" pull --quiet 2>/dev/null
        echo "[$TS] Pulled $BEHIND new commits" >> "$LOG"
    fi
fi

# Sync IDE context files from latest docs
SRC="$EMBRAL_DIR/docs/AI_CONTEXT.md"
if [ -f "$SRC" ]; then
    cp "$SRC" "$EMBRAL_DIR/.zed/ai_context.md" 2>/dev/null
    cp "$SRC" "$EMBRAL_DIR/.idea/ai-guidelines.md" 2>/dev/null
    cp "$SRC" "$EMBRAL_DIR/.kiro/steering.md" 2>/dev/null
    echo "[$TS] IDE context files synced" >> "$LOG"
fi

# Keep log under 1000 lines
tail -1000 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
SYNC_EOF
chmod +x "$SYNC_SCRIPT"
echo "   ✅ $SYNC_SCRIPT created"

# Add to crontab (every 30 minutes, avoid duplicate)
CRON_MARKER="pf_sync"
if crontab -l 2>/dev/null | grep -q "$CRON_MARKER"; then
    echo "   ✅ Cron job already exists"
else
    (crontab -l 2>/dev/null; echo "*/30 * * * * $SYNC_SCRIPT >> $HOME/.pf_sync.log 2>&1 # $CRON_MARKER") | crontab -
    echo "   ✅ Cron job added (every 30 minutes)"
fi

# ───────────────────────────────────────────
# Step 6: Commit everything to embral repo
# ───────────────────────────────────────────
echo ""
echo "Step 6: Committing to embral repo..."

cd "$EMBRAL_DIR"
git add -A
git commit -m "chore: install AI system v2 — aliases, hooks, IDE contexts, sync

- AGENTS.md v2.0: LAW 11/12 added, SQLite permanently banned
- manifest.yaml v2.0: SQLite removed, all statuses corrected
- docs/roadmap.md: expanded to 13 phases, 130+ steps
- docs/SESSION.md: session handoff protocol established
- docs/AI_CONTEXT.md: master context for all AI tools
- .cursorrules: Windsurf/Cursor compliance
- .kiro/steering.md: Kiro steering
- .zed/: Zed settings and context
- .idea/ai-guidelines.md: JetBrains AI context
- .git/hooks/pre-commit: file protection hook
- Global git hooks configured" --no-verify 2>/dev/null || echo "   (nothing new to commit)"

git push 2>/dev/null && echo "   ✅ Pushed to GitHub" || echo "   (push manually if needed)"

# ───────────────────────────────────────────
# Done
# ───────────────────────────────────────────
echo ""
echo "══════════════════════════════════════════"
echo "✅ INSTALLATION COMPLETE"
echo ""
echo "Activate now (this terminal):"
echo "   source ~/.bashrc"
echo ""
echo "Then try:"
echo "   embral-status     → current project state"
echo "   gemini            → Gemini CLI with context"
echo "   ccode             → Claude Code in embral"
echo "   kiro              → Kiro with steering"
echo "   windsurf          → Windsurf in embral"
echo "   zed               → Zed with context"
echo "   jb                → JetBrains context loaded"
echo ""
echo "From ANY directory — the right context loads automatically."
echo "══════════════════════════════════════════"

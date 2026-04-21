#!/bin/bash
# Embral AI Aliases
# Automatically loads Embral context when you open any AI tool.
#
# INSTALL (run once):
#   echo "source ~/.embral_aliases.sh" >> ~/.bashrc
#   source ~/.bashrc
#
# USAGE:
#   embral          → shows help and current status
#   gemini          → opens Gemini CLI with Embral context loaded
#   kiro            → opens Kiro with Embral context loaded
#   windsurf        → opens Windsurf in Embral directory
#   ccode           → opens Claude Code with Embral context loaded
#   copilot         → opens GitHub Copilot CLI with Embral context
#   embral-status   → quick git status + last session summary
#   embral-session  → opens SESSION.md for editing after a session ends

EMBRAL_DIR="/var/lib/phoenix-ai/workspace/embral"
EMBRAL_CONTEXT="$EMBRAL_DIR/docs/AI_CONTEXT.md"
EMBRAL_SESSION="$EMBRAL_DIR/docs/SESSION.md"
EMBRAL_AGENTS="$EMBRAL_DIR/AGENTS.md"

# ═══════════════════════════════════════════
# CORE HELPER — called by every alias
# ═══════════════════════════════════════════

_embral_orient() {
    echo ""
    echo "🔥 EMBRAL — AI Context Loading"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Repo:  $EMBRAL_DIR"
    echo "Phase: $(grep 'Current Phase:' "$EMBRAL_DIR/docs/roadmap.md" 2>/dev/null | head -1 | sed 's/.*Phase: //')"
    echo ""
    echo "Last 3 commits:"
    git -C "$EMBRAL_DIR" log --oneline -3 2>/dev/null | sed 's/^/  /'
    echo ""
    echo "Git status:"
    git -C "$EMBRAL_DIR" status --short 2>/dev/null | head -10 | sed 's/^/  /'
    if [ -z "$(git -C "$EMBRAL_DIR" status --short 2>/dev/null)" ]; then
        echo "  (clean)"
    fi
    echo ""
    echo "Next tasks (from SESSION.md):"
    # Extract the "What to do first" section from SESSION.md
    awk '/## WHAT TO DO FIRST/,/^---/' "$EMBRAL_SESSION" 2>/dev/null | \
        grep "^\*\*Priority\|^[0-9]\." | head -6 | sed 's/^/  /'
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Context file: $EMBRAL_CONTEXT"
    echo ""
}

# ═══════════════════════════════════════════
# GEMINI CLI
# ═══════════════════════════════════════════

gemini() {
    cd "$EMBRAL_DIR" || return 1
    _embral_orient
    echo "Opening Gemini CLI with Embral context..."
    echo ""
    # Gemini CLI: pass context as initial system message
    # gemini reads the context file and waits for your instruction
    if [ -f "$EMBRAL_CONTEXT" ]; then
        command gemini --system "$(cat "$EMBRAL_CONTEXT")" "$@"
    else
        echo "⚠️  AI_CONTEXT.md not found at $EMBRAL_CONTEXT"
        echo "    Run: cd $EMBRAL_DIR && gemini"
        command gemini "$@"
    fi
}

# ═══════════════════════════════════════════
# CLAUDE CODE
# ═══════════════════════════════════════════

ccode() {
    cd "$EMBRAL_DIR" || return 1
    _embral_orient
    echo "Opening Claude Code in Embral directory..."
    echo "(Claude Code reads CLAUDE.md automatically)"
    echo ""
    # Claude Code reads CLAUDE.md from repo root automatically
    # Ensure CLAUDE.md exists and is current
    if [ ! -f "$EMBRAL_DIR/CLAUDE.md" ]; then
        echo "⚠️  CLAUDE.md not found. Copying AI_CONTEXT.md as CLAUDE.md..."
        cp "$EMBRAL_CONTEXT" "$EMBRAL_DIR/CLAUDE.md"
    fi
    command claude "$@"
}

# ═══════════════════════════════════════════
# KIRO
# ═══════════════════════════════════════════

kiro() {
    cd "$EMBRAL_DIR" || return 1
    _embral_orient
    echo "Opening Kiro with Embral context..."
    echo ""
    # Kiro reads .kiro/steering.md if present
    # Ensure it exists and points to our context
    mkdir -p "$EMBRAL_DIR/.kiro"
    if [ ! -f "$EMBRAL_DIR/.kiro/steering.md" ]; then
        cat > "$EMBRAL_DIR/.kiro/steering.md" << 'KIRO_EOF'
# Kiro Steering — Embral

Read docs/AI_CONTEXT.md before every action.
Read AGENTS.md before every action.
Read manifest.yaml before creating any file.
Read docs/SESSION.md to understand current state.

Follow all laws in AGENTS.md exactly.
Update docs/SESSION.md at the end of every session.
Never create files not registered in manifest.yaml.
Never add SQLite, Ollama, or any backend AI dependency.
KIRO_EOF
    fi
    command kiro "$@"
}

# ═══════════════════════════════════════════
# WINDSURF (opens in Embral directory)
# ═══════════════════════════════════════════

windsurf() {
    cd "$EMBRAL_DIR" || return 1
    _embral_orient
    echo "Opening Windsurf in Embral directory..."
    echo "(.cursorrules and AGENTS.md auto-loaded by Windsurf)"
    echo ""
    # Windsurf reads .cursorrules automatically
    # Ensure it exists
    if [ ! -f "$EMBRAL_DIR/.cursorrules" ]; then
        cat > "$EMBRAL_DIR/.cursorrules" << 'CURSOR_EOF'
Read AGENTS.md before every action.
Read manifest.yaml before creating any file.
Read docs/SESSION.md to understand current state.
Never install dependencies not in manifest.yaml.
Never add SQLite, Ollama, ChromaDB, or any backend AI.
Edit existing files. Never create _fixed _v2 _clean *(1) variants.
Register in manifest.yaml BEFORE creating any file.
Update docs/SESSION.md at end of every session.
CURSOR_EOF
        git -C "$EMBRAL_DIR" add .cursorrules
        git -C "$EMBRAL_DIR" commit -m "chore: add .cursorrules for Windsurf compliance" --no-verify
    fi
    command windsurf . "$@"
}

# ═══════════════════════════════════════════
# GITHUB COPILOT CLI
# ═══════════════════════════════════════════

copilot() {
    cd "$EMBRAL_DIR" || return 1
    _embral_orient
    echo "Opening GitHub Copilot CLI..."
    echo ""
    # Copilot CLI: context loaded via --context flag or stdin
    local context_summary
    context_summary=$(cat "$EMBRAL_CONTEXT" 2>/dev/null | head -40)
    echo "$context_summary" | command gh copilot suggest "$@"
}

# ═══════════════════════════════════════════
# EMBRAL STATUS — quick overview
# ═══════════════════════════════════════════

embral-status() {
    cd "$EMBRAL_DIR" || return 1
    echo ""
    echo "🔥 EMBRAL STATUS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Phase from roadmap
    echo "📍 Current Phase:"
    grep "Current Phase:" "$EMBRAL_DIR/docs/roadmap.md" | head -1 | sed 's/#.*Phase:/  Phase:/'
    echo ""

    # Recent commits
    echo "📦 Last 5 Commits:"
    git -C "$EMBRAL_DIR" log --oneline -5 | sed 's/^/  /'
    echo ""

    # Git status
    echo "📝 Uncommitted Changes:"
    STATUS=$(git -C "$EMBRAL_DIR" status --short)
    if [ -z "$STATUS" ]; then
        echo "  (clean)"
    else
        echo "$STATUS" | sed 's/^/  /'
    fi
    echo ""

    # Known broken items from SESSION.md
    echo "⚠️  Known Broken Items:"
    awk '/## KNOWN ISSUES/,/^---/' "$EMBRAL_SESSION" 2>/dev/null | \
        grep "| OPEN" | sed 's/^/  /' | head -10
    echo ""

    # Next tasks
    echo "⏭️  Next Tasks:"
    awk '/## WHAT TO DO FIRST/,/---/' "$EMBRAL_SESSION" 2>/dev/null | \
        grep "^[0-9]\." | sed 's/^/  /' | head -5
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# ═══════════════════════════════════════════
# EMBRAL SESSION — update SESSION.md
# ═══════════════════════════════════════════

embral-session() {
    cd "$EMBRAL_DIR" || return 1
    echo ""
    echo "🔥 Updating SESSION.md..."
    echo "This should be done at the END of every AI session."
    echo "File: $EMBRAL_SESSION"
    echo ""
    # Open SESSION.md in default editor
    "${EDITOR:-nano}" "$EMBRAL_SESSION"
    echo ""
    echo "Committing SESSION.md update..."
    git -C "$EMBRAL_DIR" add docs/SESSION.md
    git -C "$EMBRAL_DIR" commit -m "docs: update SESSION.md after session $(date +%Y-%m-%d)"
    git -C "$EMBRAL_DIR" push
    echo "✅ Session log committed and pushed."
}

# ═══════════════════════════════════════════
# EMBRAL — main help command
# ═══════════════════════════════════════════

embral() {
    echo ""
    echo "🔥 EMBRAL AI COMMAND CENTER"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "  gemini          Open Gemini CLI with Embral context"
    echo "  ccode           Open Claude Code in Embral repo"
    echo "  kiro            Open Kiro with Embral context"
    echo "  windsurf        Open Windsurf in Embral directory"
    echo "  copilot         Open GitHub Copilot CLI"
    echo ""
    echo "  embral-status   Quick git + session status overview"
    echo "  embral-session  Update SESSION.md after a session ends"
    echo ""
    echo "  All tools auto-load: AGENTS.md + manifest.yaml + SESSION.md"
    echo "  All tools start in: $EMBRAL_DIR"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    embral-status
}

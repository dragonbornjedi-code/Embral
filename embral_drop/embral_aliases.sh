#!/usr/bin/env bash
# Embral AI Command Center
# ~/.embral_aliases.sh
# Sourced by ~/.bashrc — must be pure bash, no syntax errors

# Guard: only run in bash, silently skip in sh
if [ -z "$BASH_VERSION" ]; then
    return 0 2>/dev/null || exit 0
fi

# ═══════════════════════════════════════════
# PATHS
# ═══════════════════════════════════════════
export EMBRAL_DIR="/var/lib/phoenix-ai/workspace/embral"
export EMBRAL_DOCS="$EMBRAL_DIR/docs"
export EMBRAL_CONTEXT="$EMBRAL_DOCS/AI_CONTEXT.md"
export EMBRAL_SESSION="$EMBRAL_DOCS/SESSION.md"
export EMBRAL_AGENTS="$EMBRAL_DIR/AGENTS.md"
export EMBRAL_MANIFEST="$EMBRAL_DIR/manifest.yaml"

# Phoenix Forge workspaces (add more as needed)
export PF_WORKSPACE="/var/lib/phoenix-ai/workspace"
export HA_DIR="/var/lib/phoenix-ai/workspace/ha-green"
export QUESTARIA_DIR="/var/lib/phoenix-ai/workspace/legacy_quarantine_questaria"

# ═══════════════════════════════════════════
# DIRECTORY DETECTOR
# Returns a project tag based on current directory
# ═══════════════════════════════════════════
_pf_detect_project() {
    local cwd
    cwd="$(pwd)"
    case "$cwd" in
        *embral*)       echo "embral" ;;
        *ha-green*)     echo "ha_green" ;;
        *phoenix-ai*)   echo "phoenix_ai" ;;
        *questaria*)    echo "questaria_legacy" ;;
        "$HOME"*)       echo "home" ;;
        *)              echo "unknown" ;;
    esac
}

# ═══════════════════════════════════════════
# CONTEXT LOADER
# Loads the right prompt based on detected project
# ═══════════════════════════════════════════
_pf_load_context() {
    local project="$1"
    case "$project" in
        embral)
            cat "$EMBRAL_CONTEXT" 2>/dev/null
            ;;
        ha_green)
            cat << 'HA_CTX'
You are working on Home Assistant Green (HA Green) for the Phoenix Forge smart home.
Device: ha-green. Always-on. ARM Cortex-A53. HAOS.
Rules:
- Never commit real IPs or tokens.
- Use environment variables for all secrets.
- HA Green runs: Mosquitto, Node-RED, Piper TTS, Whisper STT, all smart integrations.
- Crucible does NOT run HA services.
- Victoria (Ollama on Crucible) calls HA REST API for smart home control.
Read AGENTS.md and docs/SESSION.md if they exist. Report current state. Wait for instruction.
HA_CTX
            ;;
        phoenix_ai)
            cat << 'PF_CTX'
You are working on the Phoenix Forge ecosystem on Crucible.
Crucible: AMD Ryzen 7, 27GB RAM, primary orchestrator.
Rules:
- No vaultwarden. KeePassXC handles secrets.
- Max model size: 7B.
- All ports registered in phoenix-forge-ops/registry/ports.yaml.
Read any AGENTS.md or SESSION.md present. Report current state. Wait for instruction.
PF_CTX
            ;;
        *)
            echo "No specific context for directory: $(pwd)"
            echo "Read any AGENTS.md or README.md present and report what you find."
            ;;
    esac
}

# ═══════════════════════════════════════════
# LAUNCH QUESTIONNAIRE
# Asks 2-3 yes/no questions, returns a task tag
# ═══════════════════════════════════════════
_pf_questionnaire() {
    local project="$1"
    local task="general"

    echo ""
    echo "🔥 Quick orientation (y/n questions)"
    echo "─────────────────────────────────────"

    local ans

    # Question 1: Fixing something or building something?
    read -r -p "  Fixing a bug or broken thing? [y/n] " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        task="fix"
    else
        # Question 2: Writing new code/content?
        read -r -p "  Writing new code or content? [y/n] " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            task="build"
        else
            # Question 3: Reviewing/auditing?
            read -r -p "  Reviewing or auditing existing work? [y/n] " ans
            if [[ "$ans" =~ ^[Yy]$ ]]; then
                task="audit"
            else
                task="general"
            fi
        fi
    fi

    echo "  Task mode: $task"
    echo ""
    echo "$task"
}

# ═══════════════════════════════════════════
# TASK PROMPT GENERATOR
# Returns task-specific instructions appended to context
# ═══════════════════════════════════════════
_pf_task_prompt() {
    local task="$1"
    local project="$2"

    case "$task" in
        fix)
            cat << 'FIX'

## YOUR TASK MODE: FIX
1. Run git status and git log --oneline -5 first.
2. Read docs/SESSION.md — look at the Known Issues table.
3. Pick the HIGHEST severity OPEN issue.
4. State which issue you are targeting.
5. Do NOT fix anything else until that one is DONE and verified.
6. After fixing: run headless verify. Update SESSION.md known issues table.
FIX
            ;;
        build)
            cat << 'BUILD'

## YOUR TASK MODE: BUILD
1. Run git status first. Confirm clean working tree.
2. Read docs/roadmap.md — find the first [ ] unchecked item in current phase.
3. Read manifest.yaml — confirm the component you are building is registered.
4. If it is NOT in manifest.yaml: register it FIRST, commit, then build.
5. Build the smallest thing that makes the item checkable.
6. Verify in headless Godot before marking done.
BUILD
            ;;
        audit)
            cat << 'AUDIT'

## YOUR TASK MODE: AUDIT
1. Run git log --oneline -20 to see all recent activity.
2. Check every file modified in last 5 commits against manifest.yaml.
3. Report any file that exists on disk but is NOT in manifest.yaml.
4. Report any autoload in project.godot not in manifest.yaml.
5. Report any banned dependency (SQLite, Ollama, ChromaDB) found anywhere.
6. Do NOT change anything until you report your findings.
AUDIT
            ;;
        *)
            echo ""
            echo "## YOUR TASK MODE: GENERAL"
            echo "Read AGENTS.md, manifest.yaml, and docs/SESSION.md."
            echo "Report what you find. Wait for my instruction."
            ;;
    esac
}

# ═══════════════════════════════════════════
# STATUS DISPLAY
# ═══════════════════════════════════════════
_pf_status() {
    local project
    project="$(_pf_detect_project)"
    local dir
    dir="$(pwd)"

    echo ""
    echo "🔥 Phoenix Forge — $(echo "$project" | tr '_' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')"
    echo "📁 $dir"
    echo "───────────────────────────────────────────"

    # Git info if in a repo
    if git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
        echo "📦 Last 3 commits:"
        git -C "$dir" log --oneline -3 2>/dev/null | sed 's/^/   /'
        echo ""
        local gstatus
        gstatus="$(git -C "$dir" status --short 2>/dev/null)"
        if [ -z "$gstatus" ]; then
            echo "📝 Working tree: clean"
        else
            echo "📝 Uncommitted:"
            echo "$gstatus" | head -8 | sed 's/^/   /'
        fi
    else
        echo "  (not a git repo)"
    fi

    # SESSION.md next tasks if in embral
    if [ "$project" = "embral" ] && [ -f "$EMBRAL_SESSION" ]; then
        echo ""
        echo "⏭️  Next tasks:"
        awk '/## WHAT TO DO FIRST/,/^---/' "$EMBRAL_SESSION" 2>/dev/null \
            | grep "^[0-9]\." | head -4 | sed 's/^/   /'
    fi

    echo "───────────────────────────────────────────"
    echo ""
}

# ═══════════════════════════════════════════
# AI LAUNCHER — core function used by all aliases
# ═══════════════════════════════════════════
_pf_launch() {
    local ai_name="$1"
    local ai_cmd="$2"
    shift 2
    local project
    project="$(_pf_detect_project)"

    # Show status
    _pf_status

    echo "🤖 Launching $ai_name for project: $project"
    echo ""

    # Run questionnaire unless --skip flag
    local task="general"
    if [[ "$*" != *"--skip"* ]]; then
        task="$(_pf_questionnaire "$project")"
    fi

    # Build full context
    local context
    context="$(_pf_load_context "$project")$(_pf_task_prompt "$task" "$project")"

    # Add universal closing instruction
    context="$context

---
UNIVERSAL RULES (always apply):
- After every 5 responses, run: git status and report any uncommitted changes.
- Before creating ANY file: check if it already exists. If it does, EDIT it, do not create a new one.
- Before creating: check manifest.yaml. If not registered, register FIRST.
- At session end: update docs/SESSION.md with what was done, what is broken, what to do next.
- Never mark anything DONE without verification evidence.
"

    # Launch the AI with context
    echo "─────────────────────────────────────────────────"
    case "$ai_name" in
        "Gemini CLI")
            command gemini --system "$context" "$@"
            ;;
        "Claude Code")
            # Claude Code reads CLAUDE.md automatically from repo root
            # Write context to CLAUDE.md temporarily if needed
            local cwd
            cwd="$(pwd)"
            if [ -d "$cwd/.git" ] && [ ! -f "$cwd/CLAUDE.md" ]; then
                echo "$context" > "$cwd/CLAUDE.md"
            fi
            command claude "$@"
            ;;
        "Kiro")
            mkdir -p .kiro
            echo "$context" > .kiro/steering.md
            command kiro "$@"
            ;;
        "Windsurf")
            echo "$context" > .cursorrules
            command windsurf . "$@"
            ;;
        "Zed")
            # Zed reads .zed/settings.json and supports assistant context
            mkdir -p .zed
            # Write context as a note Zed assistant can see
            echo "$context" > .zed/ai_context.md
            command zed . "$@"
            ;;
        "JetBrains")
            # JetBrains AI reads from .idea/ai-guidelines.md in some versions
            mkdir -p .idea
            echo "$context" > .idea/ai-guidelines.md
            echo "✅ Context written to .idea/ai-guidelines.md"
            echo "   Paste it into JetBrains AI Assistant prompt if needed."
            echo "$context"
            ;;
        *)
            echo "$context"
            command $ai_cmd "$@"
            ;;
    esac
}

# ═══════════════════════════════════════════
# PUBLIC ALIASES — one per AI tool
# ═══════════════════════════════════════════

alias gemini='_pf_launch "Gemini CLI" gemini'
alias ccode='_pf_launch "Claude Code" claude'
alias kiro='_pf_launch "Kiro" kiro'
alias windsurf='_pf_launch "Windsurf" windsurf'
alias zed='_pf_launch "Zed" zed'
alias jb='_pf_launch "JetBrains" idea'

# ═══════════════════════════════════════════
# UTILITY ALIASES
# ═══════════════════════════════════════════

alias embral='cd "$EMBRAL_DIR" && _pf_status'
alias embral-status='_pf_status'
alias pf-status='_pf_status'

embral-session() {
    local target_session="$EMBRAL_SESSION"
    if [ -f "$(pwd)/docs/SESSION.md" ]; then
        target_session="$(pwd)/docs/SESSION.md"
    fi
    echo "Opening $target_session..."
    "${EDITOR:-nano}" "$target_session"
    echo "Committing session update..."
    local repo_dir
    repo_dir="$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null || echo "$EMBRAL_DIR")"
    git -C "$repo_dir" add docs/SESSION.md
    git -C "$repo_dir" commit -m "docs: session update $(date +%Y-%m-%d-%H%M)" --no-verify 2>/dev/null
    git -C "$repo_dir" push 2>/dev/null && echo "✅ Pushed." || echo "(push manually if needed)"
}

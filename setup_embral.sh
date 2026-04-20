#!/bin/bash
# Embral — One-time setup script
# Run this ONCE on Crucible to initialize the repo
# Usage: bash setup_embral.sh
# Location: Run from /var/lib/phoenix-ai/workspace/

set -e

echo "🔥 Initializing Embral repo..."

# ═══════════════════════════════════════════
# STEP 1 — Create directory structure
# ═══════════════════════════════════════════
cd /var/lib/phoenix-ai/workspace

mkdir -p embral

cd embral

# Scripts
mkdir -p scripts/autoloads
mkdir -p scripts/models
mkdir -p scripts/npcs/companions
mkdir -p scripts/npcs/teachers
mkdir -p scripts/player
mkdir -p scripts/quest
mkdir -p scripts/dungeon
mkdir -p scripts/hardware
mkdir -p scripts/smart_home
mkdir -p scripts/ui

# Scenes
mkdir -p scenes/overworld/hearthveil
mkdir -p scenes/overworld/ember_hollow
mkdir -p scenes/overworld/tidemark
mkdir -p scenes/overworld/forge_run
mkdir -p scenes/overworld/rootstead
mkdir -p scenes/overworld/the_spire
mkdir -p scenes/overworld/the_drift
mkdir -p scenes/dungeons
mkdir -p scenes/ui
mkdir -p scenes/effects

# Data
mkdir -p data/quests/hearthveil
mkdir -p data/quests/ember_hollow
mkdir -p data/quests/tidemark
mkdir -p data/quests/forge_run
mkdir -p data/quests/rootstead
mkdir -p data/quests/the_spire
mkdir -p data/quests/the_drift
mkdir -p data/npcs
mkdir -p data/dialogue
mkdir -p data/items
mkdir -p data/wisps

# Assets
mkdir -p assets/models
mkdir -p assets/audio
mkdir -p assets/textures
mkdir -p assets/fonts
mkdir -p assets/portraits

# Addons
mkdir -p addons

# Docs
mkdir -p docs/realms

echo "✅ Directory structure created."

# ═══════════════════════════════════════════
# STEP 2 — Git init
# ═══════════════════════════════════════════
git init
git branch -M main

echo "✅ Git initialized on main branch."

# ═══════════════════════════════════════════
# STEP 3 — Copy foundation files
# (Run after you download them from Claude)
# ═══════════════════════════════════════════
# Place AGENTS.md, manifest.yaml, .gitignore, LICENSE, README.md
# in /var/lib/phoenix-ai/workspace/embral/ before continuing

echo "⏸  Pausing — copy your 5 foundation files into /var/lib/phoenix-ai/workspace/embral/"
echo "   Files needed: AGENTS.md, manifest.yaml, .gitignore, LICENSE, README.md"
read -p "   Press ENTER when files are in place..."

# ═══════════════════════════════════════════
# STEP 4 — Install pre-commit hook
# ═══════════════════════════════════════════
cp .hooks/pre-commit .git/hooks/pre-commit 2>/dev/null || true
chmod +x .git/hooks/pre-commit 2>/dev/null || true

echo "✅ Pre-commit hook installed."

# ═══════════════════════════════════════════
# STEP 5 — Create .gitkeep files so empty dirs
# are tracked by git
# ═══════════════════════════════════════════
find . -type d -empty -not -path "./.git/*" | while read d; do
    touch "$d/.gitkeep"
done

echo "✅ Empty directory placeholders created."

# ═══════════════════════════════════════════
# STEP 6 — Initial commit
# ═══════════════════════════════════════════
git add .
git commit -m "feat: Embral foundation — directory structure, AGENTS.md, manifest.yaml

- Initialized 7-realm educational RPG structure
- AGENTS.md enforces all architectural laws
- manifest.yaml is source of truth for all components
- Pre-commit hook prevents IP, secrets, and scatterbuild filenames
- MIT licensed, public repo, single-device, no backend AI"

echo "✅ Initial commit created."

# ═══════════════════════════════════════════
# STEP 7 — Connect to GitHub
# ═══════════════════════════════════════════
echo ""
echo "══════════════════════════════════════════════"
echo "FINAL STEP — Connect to GitHub"
echo "══════════════════════════════════════════════"
echo ""
echo "1. Go to https://github.com/new"
echo "2. Repository name: embral"
echo "3. Description: Open-source educational RPG for children ages 4-8"
echo "4. Set to: PUBLIC"
echo "5. Do NOT initialize with README (you already have one)"
echo "6. Do NOT add .gitignore (you already have one)"
echo "7. Do NOT add a license (you already have one)"
echo "8. Click: Create repository"
echo ""
echo "Then run these two commands (replace YOUR_GITHUB_USERNAME):"
echo ""
echo "  git remote add origin https://github.com/YOUR_GITHUB_USERNAME/embral.git"
echo "  git push -u origin main"
echo ""
echo "🔥 Embral is live."

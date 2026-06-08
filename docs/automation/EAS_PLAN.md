# Embral Universal Automation (EAS): The Hermes Army Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Establish a tool-agnostic "Agent Army" that automates research, summarizes innovation, and proves implementation every morning at 6 AM.

**Architecture:** A protocol-based systemd loop. It doesn't matter which AI (Gemini, Claude, Cursor, etc.) is active; the protocol remains the same.
- **Memory:** `docs/automation/MEMORY.md` (Facts) & `docs/automation/FEATURE_INDEX.md` (Scouting history).
- **Soul:** `docs/missions/` define the "Personalities" of the roles.
- **Crons:** `systemd` handles the daily 6 AM pulse.
- **Skills:** `scripts/automation/` provides the executable playbooks.

---

### Task 1: The Agnostic Foundation
Shift from specific AI names to "Universal Roles."

**Files:**
- Create: `docs/automation/ROLES.md`
- Create: `docs/automation/FEATURE_INDEX.md`
- Create: `docs/automation/SOUL.md`

- [ ] **Step 1: Define Universal Roles**
```markdown
# EAS Universal Roles
1. **THE PROPHET (Scout):** Discovers 2 unique repos/Discord trends daily.
2. **THE JUDGE (Summarizer):** Distills findings and triggers the phone alarm.
3. **THE PROVER (Implementation Team):** 20 minutes to demonstrate a working prototype.
```

- [ ] **Step 2: Initialize the Canonical Index**
This registry ensures we cross-off features so NO agent repeats a failed or completed idea.
```markdown
| Date | Role | Feature | Source | Status | Implementation Proof |
|------|------|---------|--------|--------|----------------------|
```

- [ ] **Step 3: Commit Foundation**
```bash
git add docs/automation/
git commit -m "feat: EAS - Initialize agent-agnostic foundation and roles"
```

---

### Task 2: The ntfy Urgent Loudspeaker
Ensure the user is woken up by a literal alarm on their phone when the summary is ready.

**Files:**
- Create: `scripts/automation/alarm.sh`

- [ ] **Step 1: Create the alarm script**
Uses `ntfy` with high-priority tags to bypass silent modes.
```bash
#!/bin/bash
# scripts/automation/alarm.sh
TOPIC="embral_hermes_army"
TITLE="EMBRAL INNOVATION ALERT"
MESSAGE=$1

curl -H "Title: $TITLE" \
     -H "Priority: 5" \
     -H "Tags: warning,loudspeaker,fire_engine" \
     -d "$MESSAGE" \
     "https://ntfy.sh/$TOPIC"
```

- [ ] **Step 2: Commit Alarm Script**
```bash
chmod +x scripts/automation/alarm.sh
git add scripts/automation/alarm.sh
git commit -m "feat: EAS - Add ntfy loudspeaker alarm protocol"
```

---

### Task 3: The 6 AM Scouting Ritual (Round 1)
Orchestrate the multi-agent scouting phase with 3 retries and AI-fallback.

**Files:**
- Create: `scripts/automation/ritual_6am.sh`

- [ ] **Step 1: Create the ritual script**
This script checks for any available AI CLI.
```bash
#!/bin/bash
# scripts/automation/ritual_6am.sh

# Function to run search with any available agent
run_agnostic_search() {
    local prompt=$1
    if command -v gemini &> /dev/null; then gemini "$prompt";
    elif command -v claude &> /dev/null; then claude "$prompt";
    elif command -v aider &> /dev/null; then aider --message "$prompt";
    else echo "No agents found"; exit 1; fi
}

# Round 1: Two Scouts find 2 repos each
run_agnostic_search "ROLE: PROPHET. Find 2 unique Godot 4.6/AI repos. Log to FEATURE_INDEX.md."
```

- [ ] **Step 2: Commit Ritual Script**
```bash
chmod +x scripts/automation/ritual_6am.sh
git add scripts/automation/ritual_6am.sh
git commit -m "feat: EAS - Add 6 AM ritual script with AI-fallback"
```

---

### Task 4: The 20-Minute Prover Competition (Round 2)
The "Team of 3" proves implementation for the top 2 user-selected features.

**Files:**
- Create: `scripts/automation/prove_it.sh`

- [ ] **Step 1: Create the prover protocol**
```bash
#!/bin/bash
# scripts/automation/prove_it.sh
# Usage: ./prove_it.sh "Feature Name" "Repo URL"

# Start 20-min timer
timeout 20m aider --message "ROLE: PROVER. Implement a demo of $1 from $2. Must be 100% offline-compatible. Proof of work required."
```

- [ ] **Step 2: Commit Prover Protocol**
```bash
chmod +x scripts/automation/prove_it.sh
git add scripts/automation/prove_it.sh
git commit -m "feat: EAS - Add 20-minute Prover competition script"
```

---

### Task 5: Systemd & Hardware Pulse
Set the heartbeat and the BIOS power-on recovery documentation.

**Files:**
- Create: `systemd/embral-hermes.service`
- Create: `systemd/embral-hermes.timer`
- Create: `docs/automation/POWER_ON.md`

- [ ] **Step 1: Create systemd timer**
```ini
[Unit]
Description=Embral Hermes Army Morning Ritual

[Timer]
OnCalendar=*-*-* 06:00:00
RandomizedDelaySec=5m
Persistent=true

[Install]
WantedBy=timers.target
```

- [ ] **Step 2: Document BIOS Power Routine**
Instructions for enabling "AC Power Loss: Power On" so the ritual never fails.
```markdown
# BIOS Power Routine
1. Enter BIOS.
2. Navigate to Power Management.
3. Set 'Restore on AC Power Loss' to [Power On].
4. Enable Wake-on-LAN if available.
```

- [ ] **Step 3: Commit and Deploy (Local Instructions)**
```bash
# User to run: sudo cp systemd/* /etc/systemd/system/ && sudo systemctl enable --now embral-hermes.timer
git add systemd/ docs/automation/POWER_ON.md
git commit -m "feat: EAS - Deploy systemd heartbeats and power routine docs"
```

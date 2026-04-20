# Embral — Source of Truth Hierarchy

> **Rule for all AI tools and contributors:** When there is a conflict between
> any two sources of information, the higher-ranked source wins. Never invent
> state that does not exist in a higher-ranked source.

---

## Hierarchy (highest → lowest authority)

### 1. Live Runtime Logs
**What it is:** Output from a running Godot instance — `print()`, `push_error()`,
`push_warning()`, and the Godot debugger console.

**Why it wins:** The engine is the ground truth. If the log says a node is missing,
it is missing — regardless of what any file or document claims.

**When to use:** Debugging, verifying autoload health, confirming hardware detection,
checking save/load success.

---

### 2. Files on Disk (committed to Git)
**What it is:** The actual `.gd`, `.tscn`, `.json`, `.yaml`, and `.md` files in
the repository at the current HEAD commit.

**Why it ranks here:** Files are what the engine actually loads. A doc that
describes a feature that doesn't exist in a `.gd` file is wrong.

**Sub-ranking within files:**
1. `project.godot` — autoload registrations, main scene, feature flags
2. `manifest.yaml` — canonical registry of every file that belongs in the repo
3. `scripts/autoloads/*.gd` — singleton behavior
4. All other scripts and scenes
5. `data/` JSON/YAML — quest and NPC content
6. `docs/` — documentation (describes reality, does not define it)

---

### 3. Project Documentation
**What it is:** `docs/roadmap.md`, `docs/compatibility.md`, `AGENTS.md`,
`docs/naming_conventions.md`, `docs/source_of_truth.md`, and realm docs.

**Why it ranks here:** Docs describe intent and conventions. They are correct
until a file on disk contradicts them — at which point the file is authoritative
and the doc needs updating.

**AGENTS.md is special:** Its Laws are constraints on what files may contain.
A file that violates a Law is wrong even if it exists on disk.

---

### 4. Model Assumptions
**What it is:** Anything an AI tool (Kiro, Gemini, Cline, Copilot, etc.) infers,
generates, or assumes without reading a higher-ranked source first.

**Why it ranks last:** Models hallucinate. A model that has not read the actual
file does not know what is in it.

**Rule:** Before asserting that a file, node, signal, or feature exists, read it.
If you cannot read it, say so. Never present an assumption as a fact.

---

## Conflict Resolution Examples

| Situation | Resolution |
|-----------|-----------|
| Log says autoload missing, roadmap says it's done | Log wins. Fix the autoload. |
| `manifest.yaml` has a file, disk doesn't | Disk wins. Either create the file or remove the manifest entry. |
| Doc says signal is `quest_done`, code says `quest_completed` | Code wins. Update the doc. |
| AGENTS.md Law forbids a pattern, a script uses it | Law wins. Fix the script. |
| Model claims a feature exists without reading the file | Assume it doesn't exist until verified. |

---

## For AI Tools

Before taking any action in this repository:
1. Read `AGENTS.md` — Laws are hard constraints.
2. Read `manifest.yaml` — if a file isn't registered, register it before creating it.
3. Read the actual file you intend to edit — do not assume its contents.
4. Check the live Godot log if the editor is running — it outranks everything else.
5. If uncertain, ask. Do not invent.

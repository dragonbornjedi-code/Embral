
## FORGE GUARDIAN — MANDATORY FIRST ACTION

Before ANY code change, call the `forge_check` MCP tool:
```
forge_check("describe what you are about to build")
```

If it returns BLOCKED: stop and read the injected context.
If it returns WARN: read the context, then proceed carefully.
If it returns INJECT: context has been added, proceed with it in mind.

Do NOT skip this step. It exists because AIs in this project have previously:
- Rebuilt the voice bridge that already exists on HA Green
- Used capsule placeholders when 30+ GLB models are on disk
- Started tutorial flows from scratch when one is already designed
- Added SQLite which broke the project startup

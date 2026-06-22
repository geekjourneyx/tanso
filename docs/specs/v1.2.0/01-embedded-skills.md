# Spec 01: Bundled Agent Skills

## Goal

Ship `tanso v1.2.0` with a self-describing Agent SOP bundled with the CLI package.

The problem is version drift: an agent may read an external skill, README, or repository checkout that does not match the executable on `PATH`. The installed CLI package must expose its own current instructions without network access or browser scraping.

## Commands

```bash
tanso skills list --json
tanso skills read tanso
tanso skills read tanso --json
tanso skills read tanso/SKILL.md --json
tanso skills read tanso SKILL.md --json
```

## Contract

- `skills list` returns JSON even when `--json` is omitted.
- `skills read <name>` defaults to raw Markdown on stdout.
- `skills read <name> --json` returns JSON with `version`, `skill`, `path`, `content`, and `guidance`.
- Diagnostics go to stderr.
- Unknown skills, missing paths, directories, and invalid relative paths return exit code `2`.
- Bundled paths use slash-separated relative paths only.
- Absolute paths, `..`, and backslashes are rejected.

## JSON Shapes

`tanso skills list --json`:

```json
{
  "version": "1.2.0",
  "skills": [
    {
      "name": "tanso",
      "description": "Use Tanso, an Agent Native Go CLI for Chinese internet research."
    }
  ],
  "count": 1
}
```

`tanso skills read tanso --json`:

```json
{
  "version": "1.2.0",
  "skill": "tanso",
  "path": "SKILL.md",
  "content": "---\nname: tanso\n...",
  "guidance": "Read this skill from the installed tanso package with `tanso skills read tanso --json` so the SOP stays in sync with this CLI version."
}
```

## Non-Goals

- No skill installer.
- No runtime-specific platform metadata.
- No reads from user skill directories such as `~/.claude/skills` or `~/.openclaw/skills`.
- No network fetches.
- No arbitrary filesystem reads.
- No plugin runtime.

## Tests

Required coverage:

- List bundled skills and parse frontmatter description.
- Read raw `SKILL.md`.
- Read JSON-wrapped `SKILL.md`.
- Reject unknown skills.
- Reject path traversal and absolute paths.
- Include the command in release checks so README and bundled SOP do not drift.

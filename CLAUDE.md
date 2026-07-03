# Project guidance for Claude Code

## Workflows

- Always use Fable 5 subagents in workflows. When authoring a `Workflow`
  script, pass `model: 'fable'` to every `agent()` call (and set
  `model: 'fable'` on `meta.phases` entries) so all subagents run on
  Claude Fable 5.

## Installed skills

Project skills live in `.claude/skills/`:

- `stop-slop` — remove AI writing patterns from prose
  (from https://github.com/hardikpandya/stop-slop)
- Superpowers skills — TDD, debugging, planning, code review, and
  collaboration workflows (from https://github.com/obra/superpowers).
  Note: only the skill files are vendored here; the plugin's auto-running
  SessionStart hook was intentionally not installed.

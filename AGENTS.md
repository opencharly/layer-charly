# AGENTS.md — layer-charly

Standalone candy repo for the `charly` layer — the full on-`$PATH` charly
toolchain. The candy lives in `charly.yml` at the repo root: the `charly:` candy
entity (composed `candy:` dependencies, the per-distro `package:`/`repo:` pins,
the `packaging:` metadata, and the `plan:` checks) and the embedded
`charly-skill:` entity that is projected into the marketplace corpus as
`/charly-tools:charly`. The `test-depends.sh` script asserts the dependency
contract.

Canonical files:

- `charly.yml` — the `charly:` candy entity and the `charly-skill:` skill entity.
- `test-depends.sh` — the dependency assertion script.
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.
- `README.md` — user overview only; never agent guidance.

## Load these skills first (R0)

- `/charly-tools:charly` — the owning skill. What the candy installs, the
  published per-distro package repos, the in-development `charly-dev` variant,
  and the on-demand copy path. Load before editing or troubleshooting the candy.
- `/charly-image:layer` — the candy authoring reference (`charly.yml` schema,
  `plan:` step verbs incl. `check:`, package sections, service declarations).
  Load before editing any entity field or plan step.

## Build / validate / test

- `charly box validate` at the repo root — the structural check: the manifest
  must parse and validate at the installed charly.
- The merge gate is the **org-wide** `charly/pr-validator` (required check
  `validate / validate`, defined in `opencharly/.github`); this repo has no
  per-repo candy gate.
- The candy's `plan:` asserts `charly version` prints a CalVer stamp, the
  composed binaries exist (`gocryptfs`, `socat`, `virsh`, `qemu-system-x86_64`),
  `charly doctor` emits its `Summary:` line, and `command -v charly` resolves.

## Modify this repo

- Edit the `charly:` candy entity AND the `charly-skill:` skill entity in
  `charly.yml` together. The skill is the projected usage source, so an install
  or behaviour change not mirrored in the skill leaves the corpus stale.
- The per-distro `package:` literals are the version pins that bust the install
  layer. Bump them (and only them) to the version the distro repos serve; the
  `packaging:` section is the single metadata source those repos build from.
- Behaviour claims go in `plan:` as observable `check:` steps.

## Landing

- PR-only. Every change lands through a pull request; the org-required
  `charly/pr-validator` validates the diff and body and arms native auto-merge
  on PASS. Direct pushes to `main` are blocked.
- History lives in `CHANGELOG/` (written by `tag-on-merge` at merge time); the
  PR body IS the changelog.
- The authoritative rulebook is the umbrella `AGENTS.md` in
  `opencharly/opencharly` and `charly/AGENTS.md` in the charly repo. Do not
  restate its rules here.

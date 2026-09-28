# charly

The full charly toolchain for OpenCharly deployments.

The `charly` candy is the single canonical layer that places the on-`$PATH`
`charly` CLI — plus its composed VM, encrypted-storage, and console-relay stack —
into an image. It installs the **published per-distro package** (from the
charly-{alpine,arch,fedora,ubuntu,debian,openwrt} repos) and composes the
`virtualization` (QEMU/libvirt), `gocryptfs`, and `socat` layers, so a
deployment that bakes this layer has a persistent, fully-featured `charly` inside
it. Bake it where the image needs the toolchain — the `charly-mcp` server, the
`*-charly` showcases, nested-pod orchestrators. Images that only need transient
in-container `charly` need not bake it: the host copies its own binary in on
demand (`EnsureCharlyInDeployVenue`).

## What it provides

| Property | Value |
|---|---|
| Layer / candy | `charly` |
| Binary | `/usr/bin/charly` (native package) |
| Composes | `pod-virtualization`, `layer-gocryptfs`, `layer-socat` |
| Packaging metadata | `packaging:` section (`charly generate-packages`, sdk/packagekit) |
| Service / port | none of its own |

The per-distro installs are pinned to an exact released charly so the install
RUN text carries the version — a version bump invalidates exactly this layer
while every layer above stays cached.

## How to use it

Compose the layer by pinning this repo in a box's `candy:` list:

```yaml
my-box:
  candy:
    base: fedora
    candy:
      - '@github.com/opencharly/layer-charly:v2026.269.2324'
```

Then, inside the built image:

```bash
charly version
charly doctor
```

## Layout

- `charly.yml` — the candy manifest: the `charly:` candy entity (composed
  `candy:` deps, per-distro `package:`/`repo:` pins, the `packaging:` metadata,
  and `plan:` checks) and the embedded `charly-skill:` entity.
- `test-depends.sh` — the repo's dependency assertion script.
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.
- `README.md` — this user overview.

## Related

- Owning skill: `/charly-tools:charly`
- Composed layers: `/charly-infrastructure:virtualization`, `/charly-infrastructure:gocryptfs`, `/charly-infrastructure:socat`
- MCP gateway composition: `/charly-coder:charly-mcp`
- [`opencharly/charly`](https://github.com/opencharly/charly) — the charly CLI and image builder
- [`opencharly/opencharly`](https://github.com/opencharly/opencharly) — the umbrella

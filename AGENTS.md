# Repository guidance

Before working, read these optional instruction files in order,
resolving these paths from this repository's root:

1. `.agents/organization/AGENTS.md`
2. `.agents/workspace/AGENTS.md`

Read each file if it resolves to a readable regular file.
Skip absent files; report broken or unreadable links.
Read each resolved file only once to avoid duplicate loading and cycles.

Resolve references inside imported files relative to their real target
directory after following symlinks.

Apply organization guidance, then workspace guidance, then the repository
instructions below. More specific applicable instructions take precedence.

## Repository scope

- This repository builds the bootable Fedora CoreOS derivative used for K3s
  nodes. `Dockerfile`, `conf/`, `docker-bake.hcl`, and the publish workflow jointly
  define its packages, SELinux behavior, architectures, and release channels.
- Published image references are consumed by infrastructure automation. Preserve
  architecture parity and channel semantics; coordinate any channel or digest
  change with `ansible-collection-infra` and the infrastructure repositories.

## Validation

- Use `docker buildx bake --print` for a side-effect-free bake expansion check.
  Perform full multi-architecture/boot validation through the publish workflow or
  an isolated builder.
- Never publish or rebase production nodes as part of local validation.

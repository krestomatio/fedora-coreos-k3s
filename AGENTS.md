# Repository guidance

## Repository scope

- This repository builds the bootable Fedora CoreOS derivative used for K3s
  nodes. `Dockerfile`, `conf/`, `docker-bake.hcl`, and the publish workflow jointly
  define its packages, SELinux behavior, architectures, and release channels.
- Published image references are consumed by infrastructure automation. Preserve
  architecture parity and channel semantics; coordinate any channel or digest
  change with `kio-web-app-infra`, whose K3s node Terraform modules rebase onto
  this image, and the other infrastructure repositories.

## Validation

- Use `docker buildx bake --print` for a side-effect-free bake expansion check.
  Perform full multi-architecture/boot validation through the publish workflow or
  an isolated builder.
- Never publish or rebase production nodes as part of local validation.

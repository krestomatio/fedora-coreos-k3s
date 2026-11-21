# Fedora CoreOS K3s
This is a bootable derivative Fedora CoreOS container image for installing and running K3s clusters.

## Tags

The publish workflow maps each K3s release channel to a Fedora CoreOS major version in
`.github/workflows/publish.yml`. Each image builds on the newest stable Fedora CoreOS release of
that major still available in `quay.io/fedora/fedora-coreos`. The value `stable` uses that tag as is.

- `<k3s channel>_f<major>`, for example `v1.30_f42`, from pushes to `main` and manual runs.
- `<k3s channel>_f<major>-weekly` from the weekly scheduled build.
- `<k3s channel>_f<major>-sha-<commit>` from every build.

With `stable` instead of a major, `_f<major>` becomes `_stable`, as in `stable_stable`. Tags without
a Fedora CoreOS part, such as `v1.30` or `stable`, are no longer updated.

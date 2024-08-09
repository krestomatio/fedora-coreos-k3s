#!/bin/bash
set -eu

# Set environment variables
INSTALL_K3S_CHANNEL=${INSTALL_K3S_CHANNEL:-stable}
INSTALL_K3S_SKIP_START=true
INSTALL_K3S_SKIP_ENABLE=true
INSTALL_K3S_BIN_DIR=/usr/bin/k3s
if [[ "$INSTALL_K3S_CHANNEL" =~ ^v(.*) ]]; then
    K3S_SCRIPT_BRANCH="release-${BASH_REMATCH[1]}"
else
    K3S_SCRIPT_BRANCH="master"
fi
K3S_SCRIPT_URL="https://raw.githubusercontent.com/k3s-io/k3s/${K3S_SCRIPT_BRANCH}/install.sh"
K3S_SCRIPT_FILE="${INSTALL_K3S_BIN_DIR}/k3s-installer.sh"

mkdir -p "${INSTALL_K3S_BIN_DIR}"
curl -sfL "${K3S_SCRIPT_URL}" -o "${K3S_SCRIPT_FILE}"
chmod 0700 "${K3S_SCRIPT_FILE}"
chown root:root -R "${INSTALL_K3S_BIN_DIR}"

# Install k3s binary
source <(sed 's/^set -e/#set -e/; /include env command/q' "${K3S_SCRIPT_FILE}")
{
  set +ue
  verify_system
  setup_env "$@"
  download_and_verify
}

# Install k3s-selinux
case ${INSTALL_K3S_CHANNEL} in
  *testing) rpm_channel=testing ;;
  *latest) rpm_channel=latest ;;
  *) rpm_channel=stable ;;
esac

[ "${rpm_channel}" = "testing" ] && rpm_site="rpm-testing.rancher.io" || rpm_site="rpm.rancher.io"

cat << _EOF > /etc/yum.repos.d/rancher-k3s-common.repo
[rancher-k3s-common-${rpm_channel}]
name=Rancher K3s Common (${rpm_channel})
baseurl=https://${rpm_site}/k3s/${rpm_channel}/common/coreos/noarch
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://${rpm_site}/public.key
_EOF
rpm-ostree install -y k3s-selinux

# Create necessary directories and set correct SELinux context
mkdir -p "/var/lib/rancher/k3s"
restorecon -R "/var/lib/rancher/k3s"

# Clean up RPM-OSTree and commit the changes
rpm-ostree cleanup -m
ostree container commit

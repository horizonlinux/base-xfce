#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
bash -c 'cat <<EOF > /etc/sysusers.d/custom-users.conf
# Groups
g abrt
g nm-fortisslvpn
g nm-openconnect
g nm-openvpn
g sstpc

# Users
u abrt - - "ABRT system user" - -
u nm-fortisslvpn - - "Fortisslvpn user" - -
u nm-openconnect - - "Openconnect user" - -
u nm-openvpn - - "Openvpn user" - -
u sstpc - - "SSTP client user" - -
EOF'
systemd-sysusers /etc/sysusers.d/custom-users.conf
sudo rm -rf /var/run
sudo ln -s /run /var/run
sudo bash -c 'cat <<EOF > /etc/tmpfiles.d/custom-var.conf
d /run/pptp 0750 root root -
d /var/account 0755 root root -
d /var/crash 0755 root root -
d /var/lib/AccountsService 0775 root root -
d /var/lib/AccountsService/icons 0775 root root -
EOF'
systemd-tmpfiles --create /etc/tmpfiles.d/custom-var.conf

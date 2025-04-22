#!/bin/bash

set -ouex pipefail

wget https://download.opensuse.org/repositories/home:Alxhr0/Fedora_41/home:Alxhr0.repo -P /etc/yum.repos.d

rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo
dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf5 copr -y enable sentry/kernel-blu

dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-steam.repo

dnf5 install -y intel-media-driver

# Kernel BLU
rpm-ostree override replace --experimental --freeze --from repo='copr:copr.fedorainfracloud.org:sentry:kernel-blu' kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra

#dnf5 install -y greeter-default-helper
dnf5 install -y nvtop java-latest-openjdk.x86_64 kitty vlc distrobox mangohud hourglass glibc-all-langpacks fastfetch btop vorta

# ZSH
dnf5 install -y zsh zoxide fzf

# Fonts
dnf5 install -y google-noto-fonts-all

# Darkmatter things
dnf5 install -y nebula-manager

# Programming
dnf5 install -y code nodejs pnpm git gh python3 python3-pip

# Flatpak
dnf5 install -y flatpak fedora-flathub-remote

# Virtual
dnf5 install -y virt-manager virt-install libvirt-daemon-config-network libvirt-daemon-kvm qemu-kvm virt-viewer libguestfs-tools python3-libguestfs virt-top swtpm edk2-ovmf

dnf5 install -y tailscale

# Gaming
dnf5 -y --setopt=install_weak_deps=False install steam gamemode lutris waydroid bottles corectrl

systemctl enable podman.socket
systemctl enable libvirtd.service
systemctl enable umbra-update.timer
systemctl enable umbra-flatpak-manager.service
systemctl enable --global umbra-theme-manager.service

#!/bin/bash

set -ouex pipefail

rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo

dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-steam.repo

dnf5 install -y virt-manager virt-install libvirt-daemon-config-network libvirt-daemon-kvm qemu-kvm virt-viewer libguestfs-tools python3-libguestfs virt-top swtpm edk2-ovmf fastfetch nvtop btop zsh zoxide fzf java-latest-openjdk.x86_64 code kitty flatpak fedora-flathub-remote just nodejs pnpm

dnf5 -y --setopt=install_weak_deps=False install steam

systemctl enable podman.socket
systemctl enable libvirtd.service
systemctl enable umbra-flatpak-manager.service

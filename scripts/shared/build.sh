#!/bin/bash

set -ouex pipefail

# Remove Horizon's stuff
#rm -rf /usr/share/horizon
#rm -r /etc/profile.d/horizon-aliases.sh
#rm -rf /etc/profile.d/console-login-helper-messages-profile.sh
#rm -rf /usr/share/console-login-helper-messages
#rm -r /usr/lib/systemd/system/horizon-flatpak-manager.service
#rm -r /usr/libexec/horizon-flatpak-manager

#dnf5 install -y wget dnf5-plugins

wget https://download.opensuse.org/repositories/home:Alxhr0/Fedora_41/home:Alxhr0.repo -P /etc/yum.repos.d

rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo
dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf5 copr -y enable sentry/kernel-blu

dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-steam.repo

#dnf5 -y install ffmpeg

#rpm-ostree override remove libavdevice-free ffmpeg-free libavcodec-free libavfilter-free libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free --install ffmpeg

dnf5 install -y intel-media-driver

# Kernel BLU
rpm-ostree override replace --experimental --freeze --from repo='copr:copr.fedorainfracloud.org:sentry:kernel-blu' kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra

dnf5 install - greeter-default-helper
dnf5 install -y  virt-manager virt-install libvirt-daemon-config-network libvirt-daemon-kvm qemu-kvm virt-viewer libguestfs-tools python3-libguestfs virt-top swtpm edk2-ovmf nvtop zsh zoxide fzf java-latest-openjdk.x86_64 code kitty flatpak fedora-flathub-remote nodejs pnpm gh vlc distrobox mangohud hourglass glibc-all-langpacks python3-pip google-noto-fonts-all fastfetch btop

dnf5 -y --setopt=install_weak_deps=False install steam gamemode lutris waydroid bottles

systemctl enable podman.socket
systemctl enable libvirtd.service
systemctl enable disable-audit.service
systemctl enable umbra-update.timer
systemctl enable umbra-flatpak-manager.service
systemctl enable --global umbra-theme-manager.service
systemctl enable greeter-default.service

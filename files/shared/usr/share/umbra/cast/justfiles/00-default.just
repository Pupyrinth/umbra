# Boot into this device's BIOS/UEFI screen
bios:
    #!/usr/bin/bash
    if [ -d /sys/firmware/efi ]; then
        systemctl reboot --firmware-setup
    else
        echo "Rebooting to legacy BIOS from OS is not supported."
    fi

alias upgrade := update

# Update user, system or both
update choice="":
    #!/usr/bin/bash
    OPTION={{ choice }}

    if [ "${OPTION,,}" == "user" ]; then
      nebula update-system
    elif [ "${OPTION,,}" == "system" ]; then
      sudo nebula update-system
    elif [ "${OPTION,,}" == "both" ]; then
      sudo nebula update-system
      nebula update-system
    else
      echo "Usage: cast update <option>"
      echo "  <option>: Specify the quick option - 'user' or 'system' or 'all'"
      echo "  Use 'user' to Update Distrobox, Node and Python packages."
      echo "  Use 'system' to Update Flatpaks, Snaps and Image."
      echo "  Use 'both' to Update both User and System."
      exit 0
    fi

alias auto-update := toggle-updates

# Turn automatic updates on or off
toggle-updates ACTION="prompt":
    #!/usr/bin/bash
    source /usr/lib/cast/cast.sh
    CURRENT_STATE="Disabled"
    if systemctl is-enabled umbra-update.timer | grep -q enabled; then
      CURRENT_STATE="Enabled"
    fi

    OPTION={{ ACTION }}
    if [ "$OPTION" == "prompt" ]; then
      echo "Automatic updates are currently: ${bold}${CURRENT_STATE}${normal}"
      echo "Enable or Disable automatic updates?"
      OPTION=$(ugum choose Enable Disable)
    elif [ "$OPTION" == "help" ]; then
      echo "Usage: cast toggle-updates <option>"
      echo "  <option>: Specify the quick option - 'enable' or 'disable'"
      echo "  Use 'enable' to Enable automatic updates."
      echo "  Use 'disable' to Disable automatic updates."
      exit 0
    fi

    if [ "${OPTION,,}" == "enable" ]; then
      sudo systemctl enable umbra-update.timer
    elif [ "${OPTION,,}" == "disable" ]; then
      sudo systemctl disable umbra-update.timer
    fi

# Clean up old up unused podman images, volumes, flatpak packages and rpm-ostree content
clean-system:
    #!/usr/bin/bash
    podman image prune -af
    podman volume prune -f
    flatpak uninstall --unused
    rpm-ostree cleanup -bm

# toggles password prompt feedback in terminal, where sudo password prompts will display asterisks when enabled
toggle-password-feedback ACTION="":
    #!/usr/bin/bash
    PWFEEDBACK_FILE="/etc/sudoers.d/enable-pwfeedback"
    OPTION={{ ACTION }}
    if [ "$OPTION" = "on" ]; then
      echo 'Defaults pwfeedback' | sudo tee $PWFEEDBACK_FILE
      echo "enabled, restart terminal to see changes"
    elif [ "$OPTION" = "off" ]; then
      sudo rm -f $PWFEEDBACK_FILE
      echo "disabled pwfeedback. restart your terminal to see changes"
    elif sudo test -f $PWFEEDBACK_FILE; then
      sudo rm -f $PWFEEDBACK_FILE
      echo "disabled pwfeedback. restart your terminal to see changes"
    else
      echo 'Defaults pwfeedback' | sudo tee $PWFEEDBACK_FILE
      echo "enabled, restart terminal to see changes"
    fi

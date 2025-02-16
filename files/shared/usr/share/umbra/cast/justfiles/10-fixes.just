# Fix Vesktop flatpak RPC
fix-vesktop-flatpak-rpc:
    mkdir -p ~/.config/user-tmpfiles.d
    echo 'L %t/discord-ipc-0 - - - - .flatpak/dev.vencord.Vesktop/xdg-run/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf
    systemctl --user enable --now systemd-tmpfiles-setup.service

    ln -s /run/user/1000/.flatpak/dev.vencord.Vesktop/xdg-run/discord-ipc-0 /run/user/1000/discord-ipc-0

    @echo -e "\033[34mNeed to use sudo...\033[0m"
    sudo flatpak override --filesystem=xdg-run/discord-ipc-*
    sudo flatpak override --filesystem=xdg-run/.flatpak/dev.vencord.Vesktop:create

    @echo -e "\033[34mAdding the fix to autostart...\033[0m"
    mkdir -pv ~/.config/autostart

    echo -e "[Desktop Entry]\nCategories=Utility;\nComment=Symlink for Vesktop discord RPC\nIcon=vesktop\nName=VesktopRPC\nStartupNotify=true\nTerminal=false\nType=Application\nExec=ln -s /run/user/1000/.flatpak/dev.vencord.Vesktop/xdg-run/discord-ipc-0 /run/user/1000/discord-ipc-0" >> ~/.config/autostart/vesktop-rpc.desktop

# Fix Discord flatpak RPC
fix-discord-flatpak-rpc:
    mkdir -p ~/.config/user-tmpfiles.d
    echo 'L %t/discord-ipc-0 - - - - app/com.discordapp.Discord/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf
    systemctl --user enable --now systemd-tmpfiles-setup.service

    ln -s /run/user/1000/.flatpak/com.discordapp.Discord/xdg-run/discord-ipc-0 /run/user/1000/discord-ipc-0

    @echo -e "\033[34mNeed to use sudo...\033[0m"
    sudo flatpak override --filesystem=xdg-run/discord-ipc-*
    sudo flatpak override --filesystem=xdg-run/.flatpak/com.discordapp.Discord:create

    @echo -e "\033[34mAdding the fix to autostart...\033[0m"
    mkdir -pv ~/.config/autostart

    echo -e "[Desktop Entry]\nCategories=Utility;\nComment=Symlink for Discord RPC\nIcon=discord\nName=DiscordRPC\nStartupNotify=true\nTerminal=false\nType=Application\nExec=ln -s /run/user/1000/.flatpak/com.discordapp.Discord/xdg-run/discord-ipc-0 /run/user/1000/discord-ipc-0" >> ~/.config/autostart/discord-rpc.desktop

alias patch-gmod := fix-gmod

# Patch GMod's 64-bit beta to work properly on Linux (https://github.com/solsticegamestudios/GModCEFCodecFix)
fix-gmod:
    #!/usr/bin/bash
    mkdir -p /tmp/patch-gmod
    wget \
      $(curl -s https://api.github.com/repos/solsticegamestudios/GModCEFCodecFix/releases/latest | \
      jq -r ".assets[] | select(.name | test(\"GModCEFCodecFix-Linux\")) | .browser_download_url") \
      -P /tmp/patch-gmod
    chmod +x /tmp/patch-gmod/GModCEFCodecFix-Linux
    /tmp/patch-gmod/GModCEFCodecFix-Linux
    rm -rf /tmp/patch-gmod

# Kills all processes related to wine and proton. This forces it to restart next time you launch the game (you might still have to press STOP in steam to kill the game binary)
fix-proton-hang:
    #!/usr/bin/bash
    PROTONCORE=(pv-bwrap pressure-vessel reaper explorer.exe rpcss.exe plugplay.exe services.exe svchost.exe winedevice.exe winedevice.exe wineserver)
    for PROG in "${PROTONCORE[@]}"; do
      killall -9 "$PROG"
    done

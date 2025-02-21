# Install or Remove rustup
rustup choice="prompt":
  #!/usr/bin/bash
  source /usr/lib/ujust/ujust.sh

  CURRENT_STATE="Not Installed"
  if command -v rustup 2>&1 >/dev/null; then
    CURRENT_STATE="Installed"
  fi

  OPTION={{ choice }}
  if [ "$OPTION" == "prompt" ]; then
    echo "Rustup is currently: ${bold}${CURRENT_STATE}${normal}"
    echo "Install or Remove rustup?"
    OPTION=$(ugum choose Install Remove)
  elif [ "$OPTION" == "help" ]; then
    echo "Usage: cast rustup <option>"
    echo "  <option>: Specify the quick option - 'install' or 'remove'"
    echo "  Use 'install' to Install rustup."
    echo "  Use 'remove' to Remove rustup."
    exit 0
  fi

  if [ "${OPTION,,}" == "Install" ]; then
    if [ "${CURRENT_STATE}" == "Install" ]; then
      echo "Rustup is already installed."
      exit 0
    else
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -- -y
    fi
  elif [ "${OPTION,,}" == "Remove" ]; then
    if [ "${CURRENT_STATE}" == "Not Installed" ]; then
      echo "Rustup is not on the system."
      exit 0
    else
      rustup self uninstall -y
    fi
  fi


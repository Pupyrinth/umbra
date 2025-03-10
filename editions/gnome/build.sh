#!/bin/bash

set -ouex pipefail

dnf5 install -y gtk-murrine-engine gnome-tweaks

### Remove packages
dnf5 remove -y firefox firefox-langpacks

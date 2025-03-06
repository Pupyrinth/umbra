#!/bin/bash

set -ouex pipefail

### Remove packages
dnf5 remove -y firefox firefox-langpacks

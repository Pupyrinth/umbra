#!/bin/bash

set -ouex pipefail

### Install packages
dnf5 install -y kate

### Remove packages
dnf5 remove -y firefox firefox-langpacks

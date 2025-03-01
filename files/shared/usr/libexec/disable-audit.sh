#!/usr/bin/env bash
#local kernel_cmdline

#kernel_cmdline=$(cat /proc/cmdline | grep -o "audit=[0-1]" | cut -d= -f2)

#get_status() {
#   if [[-z "$kernel_cmdline"]]; then
#       echo "Audit not disabled!"
#   else
#       echo "$kernel_cmdline"
#   fi
#}

#current_status=$(get_status)

# Disable Audit
rpm-ostree kargs --replace "audit=0"

# Disable systemd serivce
systemctl disable disable-audit

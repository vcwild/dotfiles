#!/bin/bash
set -e

# Variables
SCRIPT_PATH="$HOME/backup_dotfiles.sh"
SERVICE_NAME="backup-dotfiles"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"

# Check if the backup script exists and is executable
if [[ ! -f "$SCRIPT_PATH" ]]; then
  echo "Error: Backup script $SCRIPT_PATH not found."
  exit 1
fi

if [[ ! -x "$SCRIPT_PATH" ]]; then
  echo "Making $SCRIPT_PATH executable."
  chmod +x "$SCRIPT_PATH"
fi

# Create systemd user directory if not exists
mkdir -p "$SYSTEMD_USER_DIR"

# Create the service unit file
cat > "$SYSTEMD_USER_DIR/$SERVICE_NAME.service" <<EOF
[Unit]
Description=Backup dotfiles weekly

[Service]
Type=oneshot
ExecStart=$SCRIPT_PATH
EOF

# Create the timer unit file
cat > "$SYSTEMD_USER_DIR/$SERVICE_NAME.timer" <<EOF
[Unit]
Description=Run dotfiles backup script every Friday at 10 AM

[Timer]
OnCalendar=Fri 10:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Reload systemd user daemons
systemctl --user daemon-reload

# Enable and start the timer
systemctl --user enable --now "$SERVICE_NAME.timer"

echo "Setup complete. Timer enabled and started."
echo "Use 'systemctl --user list-timers' to verify."

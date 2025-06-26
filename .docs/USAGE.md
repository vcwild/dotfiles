# Dotfiles Backup & Restore Guide

This guide explains how to set up, use, and automate your dotfiles backup using a bare Git repository and systemd timers on Fedora.

---

## 📦 Initial Setup (Fresh Installation)

1. **Clone your dotfiles bare repository:**

   ```bash
   git clone --bare git@github.com:<your-username>/dotfiles.git $HOME/.dotfiles
   ```

2. **Define the alias:**

   ```bash
   alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
   ```

3. **Checkout your dotfiles:**

   ```bash
   dotfiles checkout
   ```

   If files already exist and cause conflicts, manually back them up or remove them before running checkout again.

4. **Hide untracked files in status output:**

   ```bash
   dotfiles config --local status.showUntrackedFiles no
   ```

---

## 💾 Manual Backup

To manually run a backup:

```bash
bash $HOME/.scripts/backup_dotfiles.sh
```

This will:
- Stage only **modified tracked files** (`git add -u`)
- Commit them with a timestamped message
- Push to your remote repository
- Do nothing if there are no changes

---

## 🕒 Automating with systemd Timer (Fedora)

A systemd timer is recommended for weekly backups.

### 1. Run the setup script:

```bash
bash $HOME/.scripts/setup_dotfiles_backup_timer.sh
```

This script will:
- Create a `dotfiles-backup.service`
- Create a `dotfiles-backup.timer`
- Enable and start the timer

### 2. Check the timer status:

```bash
systemctl --user list-timers
```

The backup will run **every Friday at 10:00 AM**.

---

## 📝 Notes

- Only tracked files are backed up. Untracked files are ignored.
- Store `.scripts` and `.docs` inside your dotfiles to simplify new installations.
- You can modify the timer schedule by editing `$HOME/.config/systemd/user/dotfiles-backup.timer`.

---

## 🔧 Troubleshooting

If you get errors about existing files during checkout:
- Move conflicting files elsewhere
- Or, remove them if they're not needed
- Re-run `dotfiles checkout`

If systemd timers aren't working:
- Ensure `systemd --user` is running
- Check logs with:

```bash
journalctl --user -u dotfiles-backup.service
```

---

## ✅ Recommended Aliases

Add this to your `.bashrc` or `.config/fish/config.fish`:

```bash
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

---

## 🗂️ Example Directory Structure

```
~/
├── .dotfiles/         # Bare Git repo
├── .scripts/          # Backup and setup scripts
├── .docs/             # Documentation
└── (your dotfiles)    # Regular dotfiles
```

---

## 🔒 Security Reminder

- Never track private keys or sensitive files in your dotfiles repo unless it's encrypted.

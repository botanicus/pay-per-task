cd /etc
git init

# For this repository only.
# Original error was:
# fatal: unable to auto-detect email address
# (got 'root@packer-virtualbox-iso-1420196094.(none)')
git config user.email "root@localhost"
git config user.name "Root"

git add .
git commit -m "Blankslate."

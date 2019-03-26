#!/bin/bash
# This script install lemp-manager on your computer

# Base folder
. .env

# Remove previous install
rm -rf "$ROOT"
sed -i "/$MODULE_NAME/d" "$HOME/.bashrc"

# Create root folders
mkdir -p "$ROOT" "$BIN" "$ETC" "$TMP" "$CONF"

# Copy env to ROOT
cp .env "$ROOT"

# Copy <bin> to ROOT, and prefix with module name
cp bin/* "$BIN"

# Copy src to /etc/lemp-manager
cp -r src/* "$ETC"

# Edit filenames
cd "$BIN"
for f in * ; do mv -- "$f" "$MODULE_NAME-$f" ; done
mv "$MODULE_NAME-main" "$MODULE_NAME"

# Edit script to place env correctly
for file in "$BIN/"*; do
    sed -i "s@{ENV_LOCATION}@$ROOT/.env@" "$file"
    sed -i "s@{MODULE_NAME}@$MODULE_NAME@" "$file"
done

# Edit vagrant file to set ansible files correctly
sed -i "s@{ANSIBLE_PLAYBOOK}@$ANSIBLE_PLAYBOOK@" "$VAGRANT_FILE.base"
sed -i "s@{ANSIBLE_INVENTORY}@$ANSIBLE_INVENTORY@" "$VAGRANT_FILE.base"

# Change access right
chmod -R 755 "$ROOT"

# Add bin to .bashrc
echo "PATH=\$PATH:$BIN" >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# Show next instructions
echo "Success ! Now, run 'source $HOME/.bashrc' in order to have commands globally"
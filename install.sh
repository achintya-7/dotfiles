#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting Arch system setup script..."

# Get the script directory (assuming this script is in the repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Script directory: $SCRIPT_DIR"

# --- System Update ---
read -p "Do you want to update system packages first? (y/n): " update_system
if [[ $update_system =~ ^[Yy]$ ]]; then
    echo "Updating system packages..."
    sudo pacman -Syu --noconfirm
else
    echo "Skipping system update."
fi

# --- Essential Build Tools (for Paru/Paruz) ---
# base-devel includes make, gcc, etc., required for compiling AUR packages.
# git is needed to clone the AUR repositories.
# rust is needed to build paru.
echo "Installing essential build tools: git, rust, and base-devel..."
sudo pacman -S --noconfirm git rust base-devel

# --- Git Configuration ---
echo ""
read -p "Do you want to configure Git user name and email? (y/n): " configure_git
if [[ $configure_git =~ ^[Yy]$ ]]; then
    read -p "Enter your Git user name: " git_name
    read -p "Enter your Git email: " git_email
    
    if [ -n "$git_name" ] && [ -n "$git_email" ]; then
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        echo "Git configured with name: $git_name and email: $git_email"
    else
        echo "Git name or email was empty. Skipping Git configuration."
    fi
else
    echo "Skipping Git configuration."
fi

# --- Paru and Paruz (AUR Helpers) ---
echo ""
read -p "Do you want to update packages after installing git? (y/n): " update_after_git
if [[ $update_after_git =~ ^[Yy]$ ]]; then
    echo "Updating system packages after git installation..."
    sudo pacman -Syu --noconfirm
else
    echo "Skipping update after git installation."
fi

echo "Installing Paru and Paruz (AUR helpers)..."
mkdir -p "$HOME/builds"
cd "$HOME/builds"

# Install Paru
if [ ! -d "paru" ]; then
    echo "Cloning paru AUR repository..."
    git clone https://aur.archlinux.org/paru.git
fi
cd paru
echo "Building and installing paru..."
makepkg -si --noconfirm
cd "$HOME/builds"

# Install Paruz
if [ ! -d "paruz" ]; then
    echo "Cloning paruz AUR repository..."
    git clone https://aur.archlinux.org/paruz.git
fi
cd paruz
echo "Building and installing paruz..."
makepkg -si --noconfirm
cd "$HOME" # Return to home directory

# --- Now using paru for subsequent installations ---

# --- GoLang ---
# GoLang is needed for gopls and air.
echo "Installing GoLang..."
sudo pacman -S --noconfirm go

# --- NVM (Node Version Manager) via Paru ---
echo "Installing NVM (Node Version Manager) via paru..."
paru -S --noconfirm nvm

# --- Neovim and related tools ---
echo "Installing Neovim and bat..."
sudo pacman -S --noconfirm neovim bat

# --- NvChad Installation ---
echo "Installing NvChad..."
# Backup existing nvim config if it exists
if [ -d "$HOME/.config/nvim" ]; then
    if [ ! -d "$HOME/.config/nvim/.git" ] || [ ! -f "$HOME/.config/nvim/init.lua" ]; then
        echo "Backing up existing Neovim configuration..."
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        git clone https://github.com/NvChad/NvChad "$HOME/.config/nvim" --depth 1
    else
        echo "NvChad already installed, skipping."
    fi
else
    git clone https://github.com/NvChad/NvChad "$HOME/.config/nvim" --depth 1
fi

# --- GitHub CLI ---
echo "Installing GitHub CLI..."
sudo pacman -S --noconfirm github-cli

# --- Slack Desktop App ---
echo "Installing Slack Desktop App..."
paru -S --noconfirm slack-desktop

# --- Editors (Zed and VSCode) ---
echo "Installing Zed and VSCode..."
sudo pacman -S --noconfirm zed  # Official Arch repo
paru -S --noconfirm visual-studio-code-bin  # AUR - Microsoft official version

# --- Shell Enhancement Tools ---
echo "Installing shell enhancement tools (starship, eza, zoxide, atuin)..."
sudo pacman -S --noconfirm starship eza zoxide atuin

# --- Go Development Tools (gopls, air) ---
# These depend on GoLang, which was installed earlier.
echo "Installing Go development tools..."
if ! command -v gopls >/dev/null 2>&1; then
    echo "Installing gopls..."
    go install golang.org/x/tools/gopls@latest
else
    echo "gopls already installed, skipping."
fi

if ! command -v air >/dev/null 2>&1; then
    echo "Installing air..."
    go install github.com/air-verse/air@latest
else
    echo "air already installed, skipping."
fi

# --- Docker ---
echo "Installing Docker..."
sudo pacman -S --noconfirm docker docker-compose
sudo systemctl enable docker
sudo usermod -aG docker "$USER" # Add current user to docker group

# --- Guake Terminal ---
echo "Installing Guake..."
sudo pacman -S --noconfirm guake

# --- Tmux ---
echo "Installing Tmux..."
sudo pacman -S --noconfirm tmux

# --- Configure Tmux ---
echo "Setting up Tmux configuration..."
if [ -f "$SCRIPT_DIR/tmux/tmux.conf" ]; then
    mkdir -p "$HOME/.config/tmux"
    cp "$SCRIPT_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
    echo "Tmux configuration copied from repo."
else
    echo "Warning: tmux.conf not found in $SCRIPT_DIR/tmux/"
fi

# --- Fish Shell ---
echo "Installing and setting up Fish Shell..."
sudo pacman -S --noconfirm fish

# --- Configure Fish Shell ---
echo "Setting up Fish Shell configuration..."
mkdir -p "$HOME/.config/fish"

# Copy config.fish from repo if it exists, otherwise create a basic one
if [ -f "$SCRIPT_DIR/config.fish" ]; then
    cp "$SCRIPT_DIR/config.fish" "$HOME/.config/fish/config.fish"
    echo "Fish configuration copied from repo."
else
    echo "Creating basic Fish configuration with environment variables..."
    cat > "$HOME/.config/fish/config.fish" << 'EOF'
# Auto-generated by setup script
set fish_greeting

# Go environment variables
set -gx GOPATH $HOME/go
set -gx GOBIN $GOPATH/bin
fish_add_path $GOBIN
fish_add_path /usr/local/go/bin

# NVM setup for Fish
set -gx NVM_DIR $HOME/.nvm

# Function to load NVM (call this manually when needed)
function load_nvm
    if test -s "$NVM_DIR/nvm.sh"
        bass source "$NVM_DIR/nvm.sh"
    end
end

# Atuin integration
if command -q atuin
    atuin init fish | source
end

# Starship prompt
if command -q starship
    starship init fish | source
end

# Zoxide integration
if command -q zoxide
    zoxide init fish | source
end

# Add local bin to PATH
fish_add_path $HOME/.local/bin

# Cargo (Rust) bin path
fish_add_path $HOME/.cargo/bin

# Docker completion
if command -q docker
    docker completion fish | source
end
EOF
fi

# Set fish as default shell for the current user
chsh -s "$(which fish)"

# --- Set up Fish shell environment ---
echo "Setting up Fish shell environment..."

# --- Tailscale ---
echo "Installing Tailscale..."
sudo pacman -S --noconfirm tailscale
sudo systemctl enable --now tailscaled

# --- Create Go workspace directories ---
echo "Creating Go workspace directories..."
mkdir -p "$HOME/go/"{bin,pkg,src}

# --- Source the Fish environment ---
echo "Fish shell setup complete."

echo "Setup script finished!"
echo ""
echo "=== IMPORTANT POST-SETUP STEPS ==="
echo "1. Log out and back in to apply all changes (Docker group, Fish shell, environment variables)"
echo "2. For NVM in Fish shell, you may need to install 'bass' for better compatibility:"
echo "   fisher install edc/bass"
echo "3. After logging back in, install Node.js with NVM:"
echo "   nvm install node"
echo "4. Configure your terminal emulator to use a Nerd Font (Fira Code Nerd Font is installed)"
echo "5. Run 'nvim' to complete NvChad setup (it will install plugins on first run)"
echo "6. To connect to Tailscale, run: sudo tailscale up"
echo ""
echo "=== CONFIGURATION FILES ==="
if [ -f "$SCRIPT_DIR/tmux/tmux.conf" ]; then
    echo "✓ Tmux config: ~/.config/tmux/tmux.conf"
else
    echo "⚠ Tmux config: Not found in repo, using default"
fi

if [ -f "$SCRIPT_DIR/config.fish" ]; then
    echo "✓ Fish config: ~/.config/fish/config.fish (from repo)"
else
    echo "✓ Fish config: ~/.config/fish/config.fish (auto-generated with env vars)"
fi

echo "✓ NvChad config: ~/.config/nvim/"
echo ""
echo "Environment variables have been set up in ~/.config/fish/config.fish"

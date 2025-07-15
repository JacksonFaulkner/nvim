# Neovim Configuration

A personal Neovim configuration optimized for Mac.

## Installation

### Prerequisites

- [Homebrew](https://brew.sh/)
- Git
- Neovim (version 0.8.0 or higher)
- A terminal with a [Nerd Font](https://www.nerdfonts.com/) installed

### Installing Dependencies

1. Install Homebrew if you don't have it already:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install required packages with Homebrew:
```bash
# Install Neovim
brew install neovim

# Install additional dependencies
brew install ripgrep fzf fd node
```

3. Install a Nerd Font for proper icons:
```bash
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```
(Remember to configure your terminal to use the Nerd Font after installation)

### Plugin Manager Setup

This configuration uses Packer as the plugin manager. It will be automatically installed when you first open Neovim with this configuration, but you can also install it manually:

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

### Setup Instructions

1. Clone this repository:
```bash
git clone https://github.com/YOUR_USERNAME/nvim.git
```

2. Create a backup of your existing Neovim configuration (if any):
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

3. Copy this configuration to your Neovim config location:
```bash
cp -r ./nvim ~/.config/
```

4. Open Neovim and install plugins:
```bash
nvim +PackerSync
```

## Updating

To update your Neovim configuration with the latest changes from this repository:

1. Navigate to your local clone of the repository:
```bash
cd path/to/your/local/nvim/repo
```

2. Pull the latest changes:
```bash
git pull origin main
```

3. Copy the updated files to your Neovim config location:
```bash
cp -r ./* ~/.config/nvim/
```

4. Restart Neovim and update plugins:
```bash
nvim +PackerSync
```

You may also want to create a simple update script:

```bash
#!/bin/zsh
# update_nvim_config.sh
cd path/to/your/local/nvim/repo
git pull origin main
cp -r ./* ~/.config/nvim/
echo "Neovim configuration updated successfully!"
echo "Now run 'nvim +PackerSync' to update plugins."
```

Make it executable with `chmod +x update_nvim_config.sh` and run it whenever you want to update.

## Customization

Feel free to modify the configuration to suit your needs by editing the files in the `~/.config/nvim` directory.

## License

MIT

# SketchyBar

## Installation

```sh
brew tap FelixKratz/formulae
brew install sketchybar
```

## Configuration

I use [sketchybar config](https://github.com/PraveenGongada/dotfiles/tree/main/sketchybar) as an example.

```sh
brew install font-sf-pro
brew install --cask sf-symbols
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.32/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.32/icon_map.sh -o $HOME/.config/sketchybar/icon_map.sh
```

The configuration files are organized as follows:

+ `sketchybarrc` - Main configuration file
+ `colors.sh` - Color definitions
+ `items/` - Individual component configurations
+ `plugins/` - Interactive plugin scripts

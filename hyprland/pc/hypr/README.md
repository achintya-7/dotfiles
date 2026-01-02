# Hyprland Configuration Guide

This README provides a comprehensive overview of the Hyprland configuration structure, explaining what each file manages and where to add your customizations.

## 📋 Table of Contents

- [Main Configuration](#main-configuration)
- [User Configuration Files](#user-configuration-files)
- [Other Configuration Files](#other-configuration-files)
- [Waybar Configuration](#waybar-configuration)
- [Scripts Directory](#scripts-directory)
- [Quick Reference](#quick-reference)

---

## 🎯 Main Configuration

### `hyprland.conf`
**Purpose**: Main entry point that sources all other configuration files.

**What it does**:
- Runs `initial-boot.sh` on first boot (one-time setup)
- Sources all configuration files in order
- Loads monitor and workspace configurations

**Key sections**:
- `exec-once`: Runs `initial-boot.sh` for first-time setup
- `source`: Loads configs from `configs/` and `UserConfigs/` directories
- Monitor and workspace configs loaded at the end

**⚠️ Note**: Generally, you don't need to edit this file. Add your customizations in the `UserConfigs/` directory instead.

---

## 📁 User Configuration Files

All user-customizable files are in the `UserConfigs/` directory. These files are **NOT** overwritten during updates (when using `upgrade.sh`).

### `01-UserDefaults.conf`
**Purpose**: Define your default applications and settings.

**What to add here**:
- Default terminal: `$term = kitty`
- Default file manager: `$files = thunar`
- Default editor: `$edit = ${EDITOR:-nano}`
- Default search engine for Rofi: `$Search_Engine = "https://www.google.com/search?q={}"`

**Used by**:
- Waybar modules (via `WaybarScripts.sh`)
- User keybinds
- Various scripts

**Example**:
```conf
$term = kitty
$files = thunar
$edit = nvim
$Search_Engine = "https://www.google.com/search?q={}"
```

---

### `ENVariables.conf`
**Purpose**: Environment variables for Wayland/X11 compatibility and system settings.

**What to configure**:
- Toolkit backends (GDK, QT, SDL)
- XDG specifications
- Cursor theme (Hyprcursor)
- Display scaling
- NVIDIA settings (if applicable)
- Firefox Wayland support

**Key variables**:
- `GDK_BACKEND`: Wayland/X11 backend
- `QT_QPA_PLATFORM`: Qt platform
- `HYPRCURSOR_THEME`: Cursor theme name
- `GDK_SCALE` / `QT_SCALE_FACTOR`: Display scaling

**⚠️ Note**: Uncomment NVIDIA variables only if you have an NVIDIA GPU.

---

### `Startup_Apps.conf`
**Purpose**: Applications and services to launch when Hyprland starts.

**What to add here**:
- Wallpaper daemon (swww)
- System tray apps (nm-applet, blueman, etc.)
- Waybar
- Notification daemon (swaync)
- Clipboard manager (cliphist)
- Polkit agent
- Hypridle (idle daemon)

**Current startup apps**:
- `swww-daemon`: Wallpaper manager
- `waybar`: Status bar
- `swaync`: Notification center
- `nm-applet`: Network manager
- `blueman-applet`: Bluetooth manager
- `hypridle`: Idle daemon (locks screen)

**Example**:
```conf
exec-once = waybar
exec-once = nm-applet --indicator
exec-once = your-app-here
```

---

### `UserSettings.conf`
**Purpose**: Core Hyprland behavior and settings.

**What to configure**:
- **Layouts**: `dwindle` or `master`
- **Input settings**: Keyboard layout, repeat rate, mouse sensitivity
- **Touchpad**: Natural scroll, tap-to-click, etc.
- **Gestures**: Workspace swipe gestures
- **Misc settings**: VRR, DPMS, window swallowing, etc.
- **Cursor**: Sync with gsettings, hardware cursors, warping

**Key sections**:
- `dwindle`: Tiling layout settings
- `master`: Master layout settings
- `input`: Keyboard, mouse, touchpad configuration
- `gestures`: Workspace swipe gestures
- `misc`: Various system behaviors
- `cursor`: Cursor behavior

**Example customization**:
```conf
input {
  kb_layout = us
  repeat_rate = 50
  repeat_delay = 300
  sensitivity = 0
}
```

---

### `UserDecorations.conf`
**Purpose**: Visual appearance of windows and desktop.

**What to configure**:
- Border size and colors
- Gaps (in/out)
- Window rounding
- Opacity (active/inactive/fullscreen)
- Dimming inactive windows
- Shadows
- Blur effects

**Color sources**:
- Colors are sourced from `wallust` (wallpaper color scheme)
- Located in: `~/.config/hypr/wallust/wallust-hyprland.conf`

**Key settings**:
- `border_size`: Window border width
- `gaps_in` / `gaps_out`: Gaps between windows
- `rounding`: Corner radius
- `blur`: Blur effect settings
- `shadow`: Shadow configuration

**Example**:
```conf
decoration {
  rounding = 10
  active_opacity = 1.0
  inactive_opacity = 0.9
  blur {
    enabled = true
    size = 6
    passes = 2
  }
}
```

---

### `UserAnimations.conf`
**Purpose**: Window and workspace animations.

**What to configure**:
- Bezier curves (animation easing)
- Window animations (in, out, move)
- Workspace animations
- Border animations
- Fade animations

**Available bezier curves**:
- `myBezier`, `linear`, `wind`, `winIn`, `winOut`
- `slow`, `overshot`, `bounce`, `sligshot`, `nice`

**Animation types**:
- `windowsIn` / `windowsOut`: Window open/close
- `windowsMove`: Window movement
- `workspaces`: Workspace switching
- `fade`: Fade transitions
- `border`: Border animations

**Example**:
```conf
animation = windowsIn, 1, 5, slow, popin
animation = windowsOut, 1, 5, winOut, popin
animation = workspaces, 1, 5, wind
```

**💡 Tip**: You can also use animation presets from the `animations/` directory by sourcing them.

---

### `UserKeybinds.conf`
**Purpose**: Your custom keyboard shortcuts and keybindings.

**What to add here**:
- Application launchers
- Window management shortcuts
- Media controls
- Waybar controls
- Custom scripts
- Feature toggles

**⚠️ Important**: Check `configs/Keybinds.conf` to avoid conflicts with default keybinds.

**Common keybind patterns**:
- `bind = $mainMod, KEY, exec, command` - Execute command
- `bind = $mainMod, KEY, action` - Window action
- `bindr = $mainMod, KEY, exec, command` - Repeatable bind

**Example**:
```conf
bind = $mainMod, D, exec, rofi -show drun
bind = $mainMod, Return, exec, $term
bind = $mainMod, SPACE, togglefloating
```

**Waybar keybinds**:
- `SUPER CTRL ALT B`: Toggle hide/show waybar
- `SUPER CTRL B`: Waybar styles menu
- `SUPER ALT B`: Waybar layout menu
- `SUPER ALT R`: Refresh waybar, swaync, rofi

---

### `WindowRules.conf`
**Purpose**: Window behavior rules - how specific applications should behave.

**What to configure**:
- **Tags**: Group applications (browser, terminal, games, etc.)
- **Floating**: Which apps should float
- **Opacity**: Per-application opacity
- **Size/Position**: Window size and position
- **Workspace assignment**: Which workspace apps open on
- **Layer rules**: Rules for rofi, notifications, etc.

**Tag system**:
Applications are tagged and then rules apply to tags:
- `browser`: Firefox, Chrome, etc.
- `terminal`: Kitty, Alacritty, etc.
- `games`: Steam games, gamescope
- `im`: Discord, Telegram, etc.
- `settings`: System settings apps
- `viewer`: Image/document viewers

**Rule types**:
- `windowrule = tag +browser, class:^Firefox$` - Tag assignment
- `windowrule = float, tag:settings*` - Float all settings apps
- `windowrule = opacity 0.9 0.7, tag:browser*` - Opacity rules
- `windowrule = workspace 2, tag:browser*` - Workspace assignment
- `layerrule = blur, rofi` - Layer rules for overlays

**Example**:
```conf
# Tag browsers
windowrule = tag +browser, class:^Firefox$

# Float settings apps
windowrule = float, tag:settings*

# Set opacity
windowrule = opacity 0.9 0.7, tag:browser*

# Assign to workspace
windowrule = workspace 2, tag:browser*
```

---

### `Laptops.conf`
**Purpose**: Laptop-specific settings and keybinds.

**What to configure**:
- Touchpad device name and settings
- Function key bindings (brightness, volume, etc.)
- Keyboard backlight
- Lid switch behavior
- Laptop-specific shortcuts

**Key features**:
- Touchpad toggle: `xf86TouchpadToggle`
- Brightness controls: `xf86MonBrightnessUp/Down`
- Keyboard brightness: `xf86KbdBrightnessUp/Down`
- Screenshot keybinds (if no PrintScreen key)

**Touchpad configuration**:
```conf
$Touchpad_Device=asue1209:00-04f3:319f-touchpad

device {
  name = $Touchpad_Device
  enabled = $TOUCHPAD_ENABLED
}
```

**⚠️ Note**: Get your touchpad device name with: `hyprctl devices`

**Lid switch behavior**:
- See comments in file for lid-closed behavior
- Can disable laptop display when lid is closed
- Uses `LaptopDisplay.conf` for dynamic monitor config

---

### `LaptopDisplay.conf`
**Purpose**: Dynamic laptop display configuration.

**What it does**:
- Used when laptop lid is closed (if configured in `Laptops.conf`)
- Can be dynamically written by lid switch bindings
- Prevents laptop monitor from waking unintentionally

**⚠️ Note**: This file is managed automatically when lid switch bindings are enabled in `Laptops.conf`.

---

## 🔧 Other Configuration Files

### `monitors.conf`
**Purpose**: Monitor configuration (resolution, scale, position).

**What to configure**:
- Monitor resolution and refresh rate
- Display scaling
- Monitor positioning
- Multi-monitor setup
- 10-bit color support (if supported)

**⚠️ Note**: This file can be overwritten by `nwg-displays` when you use the GUI tool.

**Example**:
```conf
monitor = eDP-1, 2560x1440@165, 0x0, 1
monitor = DP-1, 1920x1080@60, auto, 1
```

**Get monitor info**:
```bash
hyprctl monitors
```

---

### `workspaces.conf`
**Purpose**: Workspace rules and assignments.

**What to configure**:
- Workspace-to-monitor assignments
- Workspace-specific behaviors (rounding, gaps, borders)
- Default workspaces
- Special workspace configuration

**⚠️ Note**: This file can be overwritten by `nwg-displays`.

**Example**:
```conf
workspace = 1, monitor:eDP-1
workspace = 2, monitor:DP-1
workspace = 3, rounding:false, decorate:false
```

---

### `application-style.conf`
**Purpose**: Qt application styling (for Hyprland Qt support).

**What to configure**:
- Window roundness
- Border width
- Motion reduction

**Settings**:
- `roundness`: Corner radius for Qt apps
- `border_width`: Border width
- `reduce_motion`: Disable animations

---

### `hypridle.conf`
**Purpose**: Idle daemon configuration - monitors user activity and triggers actions.

**What it does**:
- Monitors idle time
- Shows notifications when idle
- Locks screen after inactivity
- Manages screen power (optional)

**Current configuration**:
- **9 minutes**: Shows "You are idle!" notification
- **10 minutes**: Locks screen via `loginctl lock-session`

**Available listeners** (some disabled):
- Idle warning notification
- Screen lock
- Screen off (disabled)
- System suspend (disabled)

**Customization**:
```conf
listener {
    timeout = 600  # 10 minutes
    on-timeout = loginctl lock-session
    on-resume = notify-send "Welcome back!"
}
```

---

### `hyprlock.conf` / `hyprlock-2k.conf`
**Purpose**: Lock screen appearance and layout.

**Differences**:
- `hyprlock.conf`: For resolutions < 1080p (smaller fonts, adjusted positions)
- `hyprlock-2k.conf`: For 2K+ resolutions (larger fonts, adjusted positions)

**What to configure**:
- Background (wallpaper with effects)
- Time display (hour, minute, seconds)
- Date display
- User information
- Password input field
- System info (uptime, battery, weather)
- Keyboard layout indicator

**Features**:
- Blurred background with effects
- Large time display
- Weather information (from cache)
- Battery status
- System uptime
- Colors from wallust

**To use**:
Copy the appropriate file to `~/.config/hyprlock/config`:
```bash
# For 2K+ monitors
cp ~/.config/hypr/hyprlock-2k.conf ~/.config/hyprlock/config

# For < 1080p monitors
cp ~/.config/hypr/hyprlock.conf ~/.config/hyprlock/config
```

---

### `configs/Keybinds.conf`
**Purpose**: Default/pre-configured keybinds.

**What it contains**:
- Window management (close, kill, move, resize)
- Workspace navigation
- Layout controls (master/dwindle)
- Media keys
- Screenshot keybinds
- Special workspace controls

**⚠️ Note**: Don't edit this file directly. Add your custom keybinds in `UserKeybinds.conf` instead.

---

## 🎨 Waybar Configuration

Waybar is configured using a **symlink system** for easy switching between layouts and styles.

### Configuration Structure

```
~/.config/waybar/
├── config          # Symlink to active config (in configs/)
├── configs/        # Multiple layout/config files
├── style.css       # Symlink to active style (in style/)
└── style/          # Multiple CSS style files
```

### Waybar Management

**Layouts** (`SUPER ALT B`):
- Switch between config files in `~/.config/waybar/configs/`
- Script: `scripts/WaybarLayout.sh`
- Updates the `config` symlink

**Styles** (`SUPER CTRL B`):
- Switch between CSS files in `~/.config/waybar/style/`
- Script: `scripts/WaybarStyles.sh`
- Updates the `style.css` symlink

**Refresh** (`SUPER ALT R`):
- Reloads waybar, swaync, and rofi
- Script: `scripts/Refresh.sh`

**Toggle** (`SUPER CTRL ALT B`):
- Hide/show waybar

### Waybar Integration

- **Default apps**: Uses `01-UserDefaults.conf` for terminal/file manager
- **Scripts**: `WaybarScripts.sh` provides helper functions for modules
- **Weather**: `UserScripts/Weather.py` outputs JSON for waybar modules
- **Startup**: Launched in `Startup_Apps.conf`

---

## 📜 Scripts Directory

The `scripts/` directory contains utility scripts for various functions:

### Key Scripts

- **`WaybarStyles.sh`**: Switch waybar styles
- **`WaybarLayout.sh`**: Switch waybar layouts
- **`Refresh.sh`**: Reload waybar, swaync, rofi
- **`LockScreen.sh`**: Lock screen
- **`Volume.sh`**: Volume control
- **`Brightness.sh`**: Screen brightness
- **`ScreenShot.sh`**: Screenshot tool
- **`MediaCtrl.sh`**: Media player controls
- **`Animations.sh`**: Animation preset selector
- **`ChangeBlur.sh`**: Toggle blur settings
- **`GameMode.sh`**: Toggle animations for gaming
- **`RofiSearch.sh`**: Web search via Rofi
- **`ClipManager.sh`**: Clipboard manager
- And many more...

### User Scripts

The `UserScripts/` directory is for your custom scripts:
- **`Weather.py`**: Weather information (for waybar/hyprlock)
- **`WallpaperSelect.sh`**: Wallpaper selector
- **`WallpaperEffects.sh`**: Apply effects to wallpapers
- **`RofiBeats.sh`**: Online music player
- **`RofiCalc.sh`**: Calculator

**⚠️ Note**: Files in `UserScripts/` are **NOT** overwritten during updates.

---

## 🚀 Quick Reference

### Where to Add What

| What to Configure | File to Edit |
|-------------------|--------------|
| Default apps (terminal, file manager) | `UserConfigs/01-UserDefaults.conf` |
| Environment variables | `UserConfigs/ENVariables.conf` |
| Startup applications | `UserConfigs/Startup_Apps.conf` |
| Core Hyprland settings | `UserConfigs/UserSettings.conf` |
| Window appearance (borders, blur, opacity) | `UserConfigs/UserDecorations.conf` |
| Animations | `UserConfigs/UserAnimations.conf` |
| Custom keybinds | `UserConfigs/UserKeybinds.conf` |
| Window rules (floating, workspace, opacity) | `UserConfigs/WindowRules.conf` |
| Laptop-specific settings | `UserConfigs/Laptops.conf` |
| Monitor configuration | `monitors.conf` |
| Workspace rules | `workspaces.conf` |
| Idle behavior | `hypridle.conf` |
| Lock screen | `hyprlock.conf` or `hyprlock-2k.conf` |

### Important Keybinds

| Keybind | Action |
|---------|--------|
| `SUPER D` | Rofi app launcher |
| `SUPER Return` | Open terminal |
| `SUPER E` | File manager |
| `SUPER ALT R` | Refresh waybar, swaync, rofi |
| `SUPER CTRL B` | Waybar styles menu |
| `SUPER ALT B` | Waybar layout menu |
| `SUPER CTRL ALT B` | Toggle waybar |
| `CTRL ALT L` | Lock screen |
| `CTRL ALT Delete` | Exit Hyprland |

### File Protection

**Files that are NOT overwritten during updates**:
- All files in `UserConfigs/` directory
- All files in `UserScripts/` directory
- Your custom modifications

**Files that MAY be overwritten**:
- `configs/Keybinds.conf` (default keybinds)
- `monitors.conf` (if using nwg-displays)
- `workspaces.conf` (if using nwg-displays)

---

## 📝 Notes

1. **Initial Boot**: The `initial-boot.sh` script runs once on first boot to set up wallpapers, themes, and initial settings. It creates a marker file to prevent re-running.

2. **Color Scheme**: Colors are managed by `wallust` and sourced from `~/.config/hypr/wallust/wallust-hyprland.conf`. This file is generated automatically based on your wallpaper.

3. **Animation Presets**: Multiple animation presets are available in the `animations/` directory. You can source them in `UserAnimations.conf` or use the `Animations.sh` script.

4. **Monitor Profiles**: Monitor profiles can be managed via `Monitor_Profiles/` directory and the `MonitorProfiles.sh` script.

5. **Updates**: When using `upgrade.sh`, your customizations in `UserConfigs/` and `UserScripts/` are preserved.

---

## 🔗 Additional Resources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Documentation](https://github.com/Alexays/Waybar/wiki)
- [Hyprlock Documentation](https://github.com/hyprwm/hyprlock)

---

**Last Updated**: Based on current configuration structure
**Config Source**: JaKooLit's Hyprland-Dots


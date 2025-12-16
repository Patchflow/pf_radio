# pf_radio

A modern radio script for FiveM with a clean UI and smooth animations.

## Features

- Custom NUI interface with drag and resize support
- Power on/off animations and states
- Recent frequency history (stores last 3 channels)
- Quick channel switching with keybinds (PAGEUP/PAGEDOWN)
- Multiple radio animations (face, shoulder, chest, ear)
- Restricted channels for specific jobs/gangs
- Volume control and click sound toggle
- Settings persist between sessions
- Works with ESX, QBX, OX Core, vRP, or standalone

## Requirements

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [pma-voice](https://github.com/AvarianKnight/pma-voice)

## Installation

1. Download and extract to your resources folder
2. Add `ensure pf_radio` to your server.cfg
3. Configure `shared/config.lua` to match your framework
4. Set up restricted channels if needed
5. Restart your server

## Configuration

Edit `shared/config.lua`:

```lua
framework = "qbx"  -- standalone, esx, ox, qbx, vrp05
item = "radio"     -- your radio item name

restrictedChannels = {
    [1] = { "police", "ambulance" }  -- locks 1.00-1.99 to these jobs
}
```

## Usage

- Use the radio item from your inventory
- Enter a frequency and click connect
- Hold push-to-talk to transmit
- Use PAGEUP/PAGEDOWN for quick channel switching
- Type `/radioanim` to change your animation style

## Keybinds

- **PAGEUP** - Jump channel up by configured amount
- **PAGEDOWN** - Jump channel down by configured amount
- **ESC** - Close radio interface

## Restricted Channels

You can lock entire frequency ranges to specific jobs:

```lua
restrictedChannels = {
    [1] = { "police", "ambulance" },  -- 1.00-1.99
    [10] = { "gang_leader" },         -- 10.00-10.99
}
```

Players without the required job will get an error when trying to connect.

## Localization

Locale files are in `locales/`. Currently includes:
- English (`en.json`)
- Danish (`da.json`)

The script automatically uses ox_lib's locale system.

## Support

Found a bug or want a feature? Open an issue on GitHub or hit us up on Discord [https://discord.gg/XwtVC9wvc8]
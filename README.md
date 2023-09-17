# hypr-xkb
This Neovim plugin is designed to assist users who frequently switch between multiple keyboard layouts and want a seamless transition between normal (visual) mode and insert mode without manual language switching. You won't need to specify a langmap either. This plugin is specifically tailored for the Hyprland window manager and utilizes the `hyprctl switchxkblayout` command to handle language switching under the hood.

## Table of Contents
- [Installation](#installation)
    - [Lazy.nvim](#lazy.nvim)
    - [Packer.nvim](#packer.nvim)
    - [vim-plug](#vim-plug)
- [Configuration](#configuration)
    - [Default Options](#default-options)
    - [Config Example](#config-example-with-comments)
- [Logic](#logic)
- [Acknowledgements](#acknowledgements)

##  Installation
Install the plugin with your favourite package manager:

### Lazy.nvim
```lua
{
    "nestermaks/hypr-xkb",
    event = {"VeryLazy"},
    opts = {
        -- write configs here
        -- or leave it empty for default values
    },
}
```

### Packer.nvim
```lua
use({
    "nestermaks/hypr-xkb",
    config = function()
        require("hypr-xkb").setup {
            -- write configs here
            -- or leave it empty for default values
        }
    end,
})
```
### vim-plug
```lua
Plug "nestermaks/hypr-xkb"
lua << EOF
    require("hypr-xkb").setup {
        -- write configs here
        -- or leave it empty for default values
    }
EOF
```

## Configuration

### Default Options
```lua
{
    device = "at-translated-set-2-keyboard",
    normal_layout = "us",
    check = true,
    lang_codes = nil,
    layout_ids = nil,
  }

```

### Config Example With Comments
```lua
{
    device = "at-translated-set-2-keyboard", -- Find the name of your keyboard device
    -- using terminal command: "hyprctl devices"
    normal_layout = "us", -- Choose the layout you use in normal mode
    check = false, -- OPTIONAL - This option is for speed optimization.
    -- You can slightly improve plugin startup speed by disabling this option,
    -- but it can help you troubleshoot configuration issues.
    lang_codes = {"us","ua"}, -- OPTIONAL - This option is for speed optimization.
    -- Provide a list of your keyboard layout codes in the order you use them.
    -- You can find valid codes and names in /usr/share/X11/xkb/rules/base.lst.
    -- Without this option, the plugin will parse them automatically on every startup.
    layout_ids = {
      ["English (US)"] = 0,
      Ukrainian = 1,
      normal = 0
    } -- OPTIONAL - This option is for speed optimization.
    -- Provide a list of key-value pairs, where the key is the name of the layout
    -- and the value is the index of your current layout set (starting from zero).
    -- Use brackets and quotes for keys if they have additional symbols in the layout name.
    -- You MUST include a key "normal" for the layout used in normal mode.
    -- You can find valid codes and names in /usr/share/X11/xkb/rules/base.lst.
    -- Without this option, the plugin will parse them automatically on every startup.
}
```

## Logic
- When you switch from insert mode to normal mode, the plugin saves your current layout to a variable and switches to the default English (US) layout or the layout specified in the configuration.
- Under the hood it uses, `hyprctl switchxkblayout [your keyboard device name] [your layout id (e.g 0)]`. 
- When you switch back to insert mode, it automatically switches to the layout previously used in insert mode.
- To parse the output of hyprctl devices, we use a preconfigured ripgrep command. If you don't have the ripgrep package installed, the plugin will use a similar grep command.
 
## Acknowledgements
- This plugin was inspired by [ivanesmantovich](https://github.com/ivanesmantovich)'s plugin [xkbswitch.nvim](https://github.com/ivanesmantovich/xkbswitch.nvim).
- I also used [okuuva](https://github.com/okuuva)'s plugin [auto-save.nvim](https://github.com/okuuva/auto-save.nvim) as an example of a well-structured code and README.





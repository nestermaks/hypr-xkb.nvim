local M = {}
-- nvim_create_autocmd shortcut
local autocmd = vim.api.nvim_create_autocmd
local cnf = require("hypr-xkb.config")
local layouts = require('hypr-xkb.utils.kb-layouts')
local bash_commands = require("hypr-xkb.utils.bash-commands")

local layout_ids = {}
local lang_codes = {}

local get_current_layout = function()
  return bash_commands:execute('current_layout', cnf.opts.device)
end

local NORMAL_LAYOUT = "normal"
local saved_layout = get_current_layout()

local change_layout = function(layout)
  vim.fn.jobstart(string.format("hyprctl switchxkblayout %s %s", cnf.opts.device, layout_ids[layout]))
end

local manage_layout = function(current_layout, layout_to_change)
  if layout_ids[current_layout] ~= layout_ids[layout_to_change] then
    change_layout(layout_to_change)
  end
end

M.setup = function(custom_opts)
  cnf:set_options(custom_opts)

  -- Checks if lang codes set in config, otherwise parses from hyprctl devices
  if cnf.opts.lang_codes then
    lang_codes = cnf.opts.lang_codes
  else
    lang_codes = layouts.get_lang_codes(cnf.opts.device)
  end
  
  -- If "check" field is set in config it will check your device name and lang for normal layout
  if cnf.opts.check then
    local check = require("hypr-xkb.utils.check")
    check.device(cnf.opts.device)
    check.normal_layout(cnf.opts.normal_layout, lang_codes)
  end
  
  -- Checks if lang ids set in config, otherwise parses from /usr/share/X11/xkb/rules/base.lst
  if cnf.opts.layout_ids then
    layout_ids = cnf.opts.layout_ids
  else
    layout_ids = layouts.get_layout_ids(lang_codes, cnf.opts.normal_layout)
  end
  
  -- When leaving Insert Mode:
  -- 1. Save the current layout
  -- 2. Switch to the US layout
  autocmd(
    'InsertLeave',
    {
      pattern = "*",
      callback = function()
        vim.schedule(function()
          saved_layout = get_current_layout()
          manage_layout(saved_layout, NORMAL_LAYOUT)
        end)
      end
    }
  )

  -- When Neovim gets focus:
  -- 1. Save the current layout
  -- 2. Switch to the US layout if Normal Mode or Visual Mode is the current mode
  autocmd(
    { 'FocusGained', 'CmdlineLeave' },
    {
      pattern = "*",
      callback = function()
        vim.schedule(function()
          saved_layout = get_current_layout()
          local current_mode = vim.api.nvim_get_mode().mode
          if current_mode == "n" or current_mode == "no" or current_mode == "v" or current_mode == "V" or current_mode == "^V" then
            manage_layout(saved_layout, NORMAL_LAYOUT)
          end
        end)
      end
    }
  )

  -- When Neovim loses focus
  -- When entering Insert Mode:
  -- 1. Switch to the previously saved layout
  autocmd(
    { 'FocusLost', 'InsertEnter' },
    {
      pattern = "*",
      callback = function()
        vim.schedule(function()
          manage_layout(NORMAL_LAYOUT, saved_layout)
        end)
      end
    }
  )
end

return M

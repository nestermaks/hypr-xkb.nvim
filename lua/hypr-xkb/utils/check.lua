local M = {}

local bash_commands = require("hypr-xkb.utils.bash-commands")
local has_notify_plugin = pcall(require, "notify")

local TITLE = "hypr-nvim-xkb";

local show_error = function(msg)
  if has_notify_plugin then
    vim.notify(msg, vim.log.levels.ERROR, {
      title = TITLE,
    })
  else
    vim.notify(("%s: %s"):format(TITLE, msg), vim.log.levels.ERROR)
  end
end

M.device = function(device)
  local err = not bash_commands:execute('check_device', device)
  if err then
    local error_string = string.format(
      'Cannot find a keyboard device with name %s. Try bash command "hyprctl devices" to find one and add it to plugin config',
      device
    )
    show_error(error_string)
  end
end

M.normal_layout = function(normal_layout, lang_codes)
  local err = true
  for _, code in pairs(lang_codes) do
    if code == normal_layout then
      err = false
    end
  end
  if err then
    local error_string = string.format(
      'Cannot set layout with code %s for the normal mode. Check your layout list and add a respective layout code to plugins config.',
      normal_layout
    )
    show_error(error_string)
  end
end

return M

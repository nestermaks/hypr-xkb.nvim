local M = {}
local bash_commands = require("hypr-xkb.utils.bash-commands")

M.get_layout_ids = function(lang_codes, normal_layout)
  local file = io.open("/usr/share/X11/xkb/rules/base.lst", "r")
  if not file then
    vim.notify("Error: Could not open the file", vim.log.levels.ERROR)
  else
    local lang_ids = {}
    local xkb_base = file:read("*a")
    local layout_found = false
    local variant_found = false

    for line in xkb_base:gmatch("[^\r\n]+") do
        if not layout_found and line:match("^! layout$") then
            layout_found = true
        elseif layout_found and not variant_found and line:match("^! variant$") then
            variant_found = true
        elseif layout_found and not variant_found then
          for i, v in ipairs(lang_codes) do
            local code, name = line:match("(%S+)%s+(.+)$")
            if code == v then
              if v == normal_layout then
                lang_ids['normal'] = i - 1
              end
              lang_ids[name] = i - 1
            end
          end
        end
    end
    file:close()
    return lang_ids
  end
end

M.get_lang_codes = function(device)
  local lang_codes = {}
  for value in bash_commands:execute('lang_codes', device):gmatch("[^,]+") do
    table.insert(lang_codes, value)
  end
  return lang_codes
end

return M

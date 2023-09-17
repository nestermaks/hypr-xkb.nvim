local M = {}

local function hasRipgrep()
  local exit_code = os.execute("rg --version >/dev/null 2>&1")
  return exit_code == 0
end

M.commands = {
  check_device = "";
  lang_codes = "";
  current_layout = ""
}

if hasRipgrep() then
  M.commands = require("hypr-xkb.utils.ripgrep-commands")
else
  M.commands = require("hypr-xkb.utils.grep-commands")
end

M.execute =  function (self, command, ...)
  local command_string = ''
  local arg = {...}
  if not arg then
    command_string = self.commands[command]
  else
    command_string = string.format(self.commands[command], unpack(arg))
  end
  local file = io.popen(command_string)
  local output = file:read()
  file:close()
  return output
end

return M

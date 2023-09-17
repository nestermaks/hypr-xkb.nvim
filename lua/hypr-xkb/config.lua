--- @class Config
Config = {
  opts = {
    device = "at-translated-set-2-keyboard",
    normal_layout = "us",
    check = true,
    lang_codes = nil,
    layout_ids = nil,
  },
}

function Config:set_options(opts)
  opts = opts or {}
  self.opts = vim.tbl_deep_extend("keep", opts, self.opts)
end

function Config:get_options()
  return self.opts
end

return Config

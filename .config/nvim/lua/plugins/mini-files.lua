return {
  'echasnovski/mini.files',
  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
  },
  version = '*',
  config = function()
    local mini_files = require('mini.files')
    mini_files.setup()
    vim.keymap.set("n", "-", mini_files.open, { desc = "Open parent directory " })
  end
}


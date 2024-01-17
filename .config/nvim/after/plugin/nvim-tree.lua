vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
-- https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
require("nvim-tree").setup({
  view = {
   width = 35,
   number = true,
   relativenumber = true,
  },
  filters = {
    dotfiles = true,
  },
  renderer = {

  }
})


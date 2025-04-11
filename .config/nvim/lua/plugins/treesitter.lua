return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    priority = 999,
    dependencies = {
      --- Auto-close / change html-like tags
      'windwp/nvim-ts-autotag',
    },
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = {
          -- Web Dev --
          "html",
          "css",
          "javascript",
          "typescript",
          "tsx",
          "svelte",
          "scss",
          "graphql",
          -- Game Dev --
          "gdscript",
          "gdshader",
          "godot_resource",
          "glsl",
          "hlsl",
          -- Other --
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "python",
          "rust",
          "dockerfile",
          "json",
          "json5",
          "yaml",
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = false,

        highlight = {
          enable = true,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context"
  },
}

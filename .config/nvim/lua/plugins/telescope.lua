return {
  {
    "nvim-telescope/telescope.nvim", branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local builtin = require('telescope.builtin')
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local custom_actions = {}

      function custom_actions.fzf_multi_select(prompt_bufnr)
        local function get_table_size(t)
          local count = 0
          for _ in pairs(t) do
            count = count + 1
          end
          return count
        end

        local picker = action_state.get_current_picker(prompt_bufnr)
        local num_selections = get_table_size(picker:get_multi_selection())

        if num_selections > 1 then
          actions.send_selected_to_qflist(prompt_bufnr)
          actions.open_qflist()
        else
          actions.file_edit(prompt_bufnr)
        end
      end

      telescope.setup({
        defaults = {
          mappings = {
            n = {
              ["<cr>"] = custom_actions.fzf_multi_select,
            },
          },
        },
      })

      vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
      vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
      vim.keymap.set('n', '<leader>pp', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, {})
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      local tel = require('telescope')

      tel.setup {
        extensions = {
          file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = { prompt_position = "top" },
            border = true,
            mappings = {
              ["i"] = {
                -- your custom insert mode mappings
              },
              ["n"] = {
                -- your custom normal mode mappings

              },
            },
          },
        },
      }

      tel.load_extension "file_browser"

      vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
    end,
  },
}

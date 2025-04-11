return {
  {
    -- LSP config + plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", cmd = "Mason", build = ":MasonUpdate" },
      { "williamboman/mason-lspconfig.nvim", config = true },
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        lua_ls = {
          settings = { Lua = { diagnostics = { globals = { "vim" } } } },
        },
      },
    },
    config = function(_, opts)
      require("mason").setup()
      local mason_lspconfig = require("mason-lspconfig")
      local lsp_config = require("lspconfig")

      local lsp_capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      local lsp_attach = function(client, bufnr)
        local key_opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, key_opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, key_opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, key_opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, key_opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, key_opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, key_opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, key_opts)
        vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, key_opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, key_opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, key_opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, key_opts)
      end

      -- Ensure the servers above are installed
      mason_lspconfig.setup({
        ensure_installed = {
          "eslint",
          "cssls",
          "svelte",
          "html",
          "ts_ls",
          "lua_ls",
        }
      })

      mason_lspconfig.setup_handlers({
        function (server_name)
          lsp_config[server_name].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            settings = opts.servers[server_name] and opts.servers[server_name].settings or {},
          })
        end
      })

      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
        },
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    end,
  },
  {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    build = (not jit.os:find("Windows"))
        and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
      or nil,
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      {
        -- Adds a number of user-friendly snippets
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
          -- this loads friendly-snippets
          -- this loads custom user defined snippets
          --require('luasnip.loaders.from_vscode').lazy_load {
           -- paths = { './snippets' },
          --}
        end,
      }

    }
  },
  {
    -- Auto-completion (cmp) for both insert and command line modes --
    'hrsh7th/nvim-cmp',
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      -- Math auto-complete
      'hrsh7th/cmp-calc',

      -- Path autocomplete
      'FelipeLema/cmp-async-path',
    },
    config = function ()
      --NOTE: requires a nerdfont to be rendered
      local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
      }

      local cmp = require('cmp')
      local cmp_select = {behavior = cmp.SelectBehavior.Select}
      local luasnip = require('luasnip')
      cmp.setup({
        -- Set luasnip as our snippet engine --
        experimental = { ghost_text = true },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- Defines the look of our completion window --
        -- See https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/window.lua for details --
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item(cmp_select)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<CR>'] = cmp.mapping.confirm(cmp_select),
          ['<S-CR>'] = cmp.mapping.complete(),
          ['<C-c>'] = cmp.mapping.abort(),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif cmp.visible() then
              cmp.select_next_item(cmp_select)
            elseif luasnip.expandable() then
              luasnip.expand()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif cmp.visible() then
              cmp.select_prev_item(cmp_select)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        -- Define sources for autocomplete --
        sources = {
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = 'async_path' },
          { name = 'calc' },
        },
        -- Add icons next to auto complete entries --
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local icon = kind_icons[vim_item.kind] or ""
            if entry.source.name == "calc" then
              icon = "󰃬 "
            end

            vim_item.menu = "   (" .. (vim_item.kind) .. ")"
            vim_item.kind = "" .. (icon) .. " "

            return vim_item
          end
        },
      })
    end,
  },
}

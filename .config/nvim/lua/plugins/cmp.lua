return {
  -- Auto-completion (cmp) for both insert and command line modes --
  'hrsh7th/nvim-cmp',
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
     -- Snippet Engine & its associated nvim-cmp source
    { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
    'saadparwaiz1/cmp_luasnip',
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
    -- this loads friendly-snippets
    require('luasnip.loaders.from_vscode').lazy_load()
    -- this loads my custom snippets
    -- require('luasnip.loaders.from_vscode').lazy_load {
      -- paths = { './snippets' },
    -- }
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
        { name = 'async_path' },
        { name = 'calc' },
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
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
}

-- Requires https://github.com/Scony/godot-gdscript-toolkit

vim.api.nvim_create_augroup("AutoFormatGD", {})
vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.gd",
        group = "AutoFormatGD",
        callback = function()
            vim.cmd("silent !gdformat % --line-length 100")
            vim.cmd("edit")
        end,
    }
)


require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Toggle file tree with Ctrl-b
map("n", "<C-b>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
map("i", "<C-b>", "<Esc><cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree (from insert)" })

-- LSP hover/peek definition
map("n", "gk", vim.lsp.buf.hover, { desc = "LSP hover" })

-- LSP go to implementation
map("n", "gI", vim.lsp.buf.implementation, { desc = "LSP go to implementation" })

-- LSP go to reference
map("n", "gr", vim.lsp.buf.references, { desc = "LSP go to reference" })

-- GitHub Copilot
map("i", "<C-j>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false, desc = "Copilot accept" })
map("i", "<C-l>", "<Plug>(copilot-accept-word)", { desc = "Copilot accept word" })
map("i", "<C-h>", "<Plug>(copilot-dismiss)", { desc = "Copilot dismiss" })
map("i", "<C-n>", "<Plug>(copilot-next)", { desc = "Copilot next" })
map("i", "<C-p>", "<Plug>(copilot-previous)", { desc = "Copilot previous" })

-- CopilotChat
map("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Copilot Chat toggle" })
map("v", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Copilot explain" })
map("v", "<leader>cf", "<cmd>CopilotChatFix<cr>", { desc = "Copilot fix" })

-- Go: Save and organize imports
map("n", "<leader>go", function()
    vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
    vim.cmd("write")
end, { desc = "Go organize imports and save" })

-- Reload Neovim configuration
map("n", "<leader>r", function()
    vim.cmd("source ~/.config/nvim/init.lua")
    vim.notify("Configuration reloaded!", vim.log.levels.INFO)
end, { desc = "Reload Neovim config" })

-- Unmap NvChad's default terminal mappings first
vim.keymap.del("n", "<leader>v")
vim.keymap.del("n", "<leader>h")

-- Split buffer and move it to new window
map("n", "<leader>v", function()
    local current_buf = vim.api.nvim_get_current_buf()
    vim.cmd("vsplit")
    -- Move to new window (it's on the right for vsplit) - buffer is already there
    vim.cmd("wincmd l")
    -- Go back to original window and replace with empty buffer
    vim.cmd("wincmd h")
    vim.cmd("enew")
    -- Return to new window with the buffer
    vim.cmd("wincmd l")
end, { desc = "Split buffer vertically and move to new window" })

map("n", "<leader>h", function()
    local current_buf = vim.api.nvim_get_current_buf()
    vim.cmd("split")
    -- Move to new window (it's below for split) - buffer is already there
    vim.cmd("wincmd j")
    -- Go back to original window and replace with empty buffer
    vim.cmd("wincmd k")
    vim.cmd("enew")
    -- Return to new window with the buffer
    vim.cmd("wincmd j")
end, { desc = "Split buffer horizontally and move to new window" })

-- Window navigation with Ctrl+w + Arrow keys (move between windows/planes)
map("n", "<C-w><Left>", "<C-w>h", { desc = "Navigate to left window" })
map("n", "<C-w><Right>", "<C-w>l", { desc = "Navigate to right window" })
map("n", "<C-w><Up>", "<C-w>k", { desc = "Navigate to window above" })
map("n", "<C-w><Down>", "<C-w>j", { desc = "Navigate to window below" })

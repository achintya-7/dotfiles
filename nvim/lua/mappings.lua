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

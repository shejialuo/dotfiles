local icons = require("config.icons").icons

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
        },
      },
    },
  },
  config = function(_, opts)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
        end

        if client.supports_method("textDocument/references") then
          map("n", "gr", function() Snacks.picker.lsp_references() end, "References")
        end
        if client.supports_method("textDocument/definition") then
          map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
        end
        if client.supports_method("textDocument/declaration") then
          map("n", "gD", function() Snacks.picker.lsp_declarations() end, "Goto Declaration")
        end
        if client.supports_method("textDocument/implementation") then
          map("n", "gi", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
        end
        if client.supports_method("textDocument/typeDefinition") then
          map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, "Goto T[y]pe Definition")
        end

        if client.supports_method("callHierarchy/incomingCalls") then
          map("n", "gai", function() Snacks.picker.lsp_incoming_calls() end, "C[a]lls Incoming")
        end
        if client.supports_method("callHierarchy/outgoingCalls") then
          map("n", "gao", function() Snacks.picker.lsp_outgoing_calls() end, "C[a]lls Outgoing")
        end

        if client.supports_method("textDocument/documentSymbol") then
          map("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, "LSP Symbols")
        end
        if client.supports_method("workspace/symbol") then
          map("n", "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, "LSP Workspace Symbols")
        end

        if client.supports_method("textDocument/rename") then
          map("n", "<leader>cr", ":IncRename", "Rename Symbol")
        end
        if client.supports_method("textDocument/codeAction") then
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        end

        if client.supports_method("textDocument/hover") then
          map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        end

        -- Inlay Hints
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end

        -- Code Lens
        if client.supports_method("textDocument/codeLens") then
          vim.lsp.codelens.refresh()

          local codelens_group = vim.api.nvim_create_augroup('lsp_codelens', { clear = false })
          vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            buffer = bufnr,
            group = codelens_group,
            callback = vim.lsp.codelens.refresh,
          })

          map("n", "<leader>cl", vim.lsp.codelens.run, "Run Codelens")
          map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh Codelens")
        end

        -- Language specific keymaps
        if client.name == "clangd" then
          -- `LspClangdSwitchSourceHeader` is provided by "nvim-lspconfig" plugin
          -- Ref: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/clangd.lua
          map("n", "gh", "<cmd>LspClangdSwitchSourceHeader<cr>", "Switch Source/Header")
        end
      end,
    })

    vim.diagnostic.config(opts.diagnostics)
    vim.lsp.enable("clangd")
    vim.lsp.enable("beancount")
    vim.lsp.enable("rust_analyzer")
    vim.lsp.enable("pyright")
  end,
}

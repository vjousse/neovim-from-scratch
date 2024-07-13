return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Va permetre de remplir le plugin de complétion automatique nvim-cmp
    -- avec les résultats des LSP
    "hrsh7th/cmp-nvim-lsp",
    -- Ajoute les « code actions » de type renommage de fichiers intelligent, etc
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    -- import de lsp-zero
    local lsp_zero = require("lsp-zero")

    -- lsp_attach sert à activer des fonctionnalités qui ne seront disponibles
    -- que s'il il y a un LSP d'activé pour le fichier courant
    local lsp_attach = function(_, bufnr)
      local opts = { buffer = bufnr, silent = true }

      -- configuration des raccourcis
      -- je ne vous les traduis pas, ils me semblent parler d'eux-même ;)
      opts.desc = "Show LSP references"
      vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Go to declaration"
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP definitions"
      vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

      opts.desc = "Show LSP implementations"
      vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

      opts.desc = "Show LSP type definitions"
      vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

      opts.desc = "Show LSP signature help"
      vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)

      opts.desc = "See available code actions"
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart rename"
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

      opts.desc = "Show buffer diagnostics"
      vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

      opts.desc = "Show line diagnostics"
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

      opts.desc = "Go to previous diagnostic"
      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, opts) -- jump to previous diagnostic in buffer

      opts.desc = "Go to next diagnostic"
      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, opts) -- jump to next diagnostic in buffer

      opts.desc = "Show documentation for what is under cursor"
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "Format buffer"
      vim.keymap.set({ "n", "x" }, "F", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)

      opts.desc = "Restart LSP"
      vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
    end

    lsp_zero.extend_lspconfig({
      -- On affiche les signes des diagnostics dans la gouttière de gauche
      sign_text = true,
      -- On attache notre fonction qui définit les raccourcis
      lsp_attach = lsp_attach,
      -- On augmente les capacités de complétion par défaut avec les propositions du LSP
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    -- On utilise lsp_zero pour configurer quelques éléments de design
    lsp_zero.ui({
      float_border = "rounded",
      sign_text = {
        error = " ",
        warn = " ",
        hint = "󰠠 ",
        info = " ",
      },
    })
  end,
}

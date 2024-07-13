return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-buffer", -- source pour compléter le texte déjà présent dans le buffer
    "hrsh7th/cmp-path", -- source pour compléter les chemins des fichiers
    "hrsh7th/cmp-cmdline", -- source pour les completions de la cmdline de vim
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- ajoute LuaSnip à l'autocompletion
    "rafamadriz/friendly-snippets", -- collection de snippets pratiques
    "hrsh7th/cmp-emoji", -- complétion d'émojis à la saisie de :
    "onsails/lspkind.nvim", -- vs-code pictogrammes
  },
  config = function()
    local cmp = require("cmp")

    local luasnip = require("luasnip")

    local lspkind = require("lspkind")

    -- chargement des snippets (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- on utilise luasnip comme moteur de snippets
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-1),
        ["<C-f>"] = cmp.mapping.scroll_docs(1),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accepte la sélection courante. Mettre à `false` pour ne confirmer que les items explicitement sélectionnés
      },

      -- sources pour l'autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- lsp
        { name = "nvim_lua" },
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- texte du buffer courant
        { name = "path" }, -- chemins dy système de fichier
        { name = "emoji" }, -- emojis
      }),

      formatting = {
        -- Comportement par défaut
        expandable_indicator = true,
        -- Champs affichés par défaut
        fields = { "abbr", "kind", "menu" },
        format = lspkind.cmp_format({
          mode = "symbol_text",
          -- On suffixe chaque entrée par son type
          menu = {
            nvim_lsp = "[LSP]",
            buffer = "[Buffer]",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
            path = "[Path]",
            emoji = "[Emoji]",
          },
        }),
      },
    })

    -- `/` complétion
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- `:` complétion
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })
  end,
}

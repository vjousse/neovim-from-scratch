return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({})

    -- On utilise <leader>e pour ouvrir/fermer l'explorateur
    vim.keymap.set(
      "n",
      "<leader>e",
      "<cmd>NvimTreeFindFileToggle<CR>",
      { desc = "Ouverture/fermeture de l'explorateur de fichiers" }
    )
  end,
}

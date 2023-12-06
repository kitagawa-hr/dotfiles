return {
  { "easymotion/vim-easymotion" },
  { "junegunn/vim-easy-align" },
  { "machakann/vim-highlightedyank" },
  { "scrooloose/nerdcommenter" },
  { "terryma/vim-multiple-cursors" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "arthurxavierx/vim-caser" },
  {
    "907th/vim-auto-save",
    config = function()
      vim.g.auto_save_events = { "InsertLeave", "TextChanged" }
    end
  },
  {
    "tversteeg/registers.nvim",
    name = "registers",
    keys = {
      { "\"",    mode = { "n", "v" } },
      { "<C-R>", mode = "i" }
    },
    cmd = "Registers",
  },
  {
    "junegunn/fzf.vim",
    lazy = true,
    dependencies = {
      { "junegunn/fzf", build = "fzf#install()" }
    },
    keys = {
      { "<leader>p", "<cmd>Files<cr>" }
    }
  },
  {
    "scrooloose/nerdtree",
    keys = {
      { "<leader>f", "<cmd>NERDTreeToggle<cr>" }
    }
  },
  -- Git
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signcolumn = true
    }
  },
  { "tpope/vim-fugitive" },
  {
    "iberianpig/tig-explorer.vim",
    keys = {
      { "<leader><leader>t", "<cmd>TigOpenProjectRootDir<cr>" }
    }
  },
  -- Terminal
  { "kassio/neoterm" },
}

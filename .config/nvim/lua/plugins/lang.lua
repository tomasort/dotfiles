return {
  { "yuezk/vim-js" },
  { "HerringtonDarkholme/yats.vim" },
  { "maxmellon/vim-jsx-pretty" },
  { "chrisbra/csv.vim" },
  {
    "lervag/vimtex",
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.tex_conceal = "abdmg"
    end,
  },
}
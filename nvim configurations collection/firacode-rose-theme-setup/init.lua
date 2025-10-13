-- Spacing

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.ai = true
vim.cmd("filetype plugin indent on")

-- UI
vim.opt.number = true -- Line Numbers
vim.opt.showcmd = true -- Keep last command used visible
vim.opt.cursorline = true -- Highlight the current line
vim.opt.colorcolumn = { 80, 120 } -- Vertical bars
vim.opt.wildmenu = true -- Better menu
vim.opt.showmatch = true -- Show matching braces

vim.opt.laststatus = 2 -- Make powerline happy
vim.opt.clipboard = "unnamedplus" -- Use the system clipboard by default
vim.opt.mouse = "a" -- Enable mouse
vim.opt.updatetime = 100 -- more-fasterer updates

-- Search related options
vim.opt.incsearch = true
vim.opt.incsearch = true
vim.keymap.set("n", "<leader><space>", "<cmd>nohlsearch<cr>")

-- folding

vim.opt.foldenable = true

-- vim.opt.foldenable = true
-- TODO: Fold remap space to za to unfold

--vim.opt.foldmethod = "indent"
--[[
Still todo...

"make ,<space> turn off highlighting
nnoremap <leader><space> :nohlsearch<CR>


""""""""""""""""""""""""""""""""""""""""""""""folding
set foldenable              "enable code folding
set foldlevelstart=10       "open most levels
set foldnestmax=10          "set the max nested folds
"make space open folds
nnoremap <space> za
set foldmethod=indent       "make folding happen based on indent level

""""""""""""""""""""""""""""""""""""""""""""keybinds
let mapleader=","

" Various "tab should work to indent a line" stuff
inoremap <S-Tab> <ESC><<i
vnoremap <Tab> >
vnoremap <S-Tab> <

" move lines up and down with control
inoremap <C-up> <ESC>"xdd2<up>"xpi
inoremap <C-down> <ESC>"xdd"xpi

" Format
nnoremap <leader>f :Format<CR>
nnoremap <leader>F :FormatWrite<CR>

" Format on save
augroup FormatAutoGroup
    autocmd!
    autocmd BufWritePost * FormatWrite
augroup END

"""""""""""""""""""""""""""""""""""""""""""fuckery for come back to old line on reopen
if has("autocmd") && expand('%:t') != "COMMIT_EDITMSG"  " Don't do this if we're editing a git commit message
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


""""""""""""""""""""""""""""""""""""""""""""building
set autowrite
]]
--

-- Python Support
vim.g.python3_host_prog = "/Users/ad/.venvs/nvim/bin/python"

-- Plugins
require("config.base")

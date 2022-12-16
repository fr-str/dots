:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
set nocompatible


if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd!
  autocmd VimEnter * PlugInstall
endif

call plug#begin()
" Other:
    Plug 'https://github.com/vim-airline/vim-airline'
    Plug 'https://github.com/preservim/nerdtree'
    Plug 'https://github.com/Xuyuanp/nerdtree-git-plugin'
    Plug 'https://github.com/ryanoasis/vim-devicons'
    Plug 'https://github.com/mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'https://github.com/tpope/vim-commentary'
    Plug 'https://github.com/dense-analysis/ale'
    Plug 'https://github.com/sheerun/vim-polyglot'
    Plug 'https://github.com/pineapplegiant/spaceduck', { 'branch':'main'}
    Plug 'https://github.com/jiangmiao/auto-pairs'
    Plug 'https://github.com/preservim/tagbar'
    Plug 'https://github.com/fatih/vim-go'
    Plug 'https://github.com/ycm-core/YouCompleteMe'
  " Plug 'https://github.com/tc50cal/vim-terminal'
  " Plug 'https://github.com/tiagofumo/vim-nerdtree-syntax-highlight'


call plug#end()

nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <F2> :GoRename<CR>
nnoremap <C-_> :Commentary<CR>
nmap <F8> :TagbarToggle<CR>

if exists('+termguicolors')
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
endif

colorscheme spaceduck

" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Highlight line under cursor. It helps with navigation.
set cursorline
set cursorlineopt=number

" Keep 8 lines above or below the cursor when scrolling.
set scrolloff=8
" If opening buffer, search first in opened windows.
set switchbuf=usetab
" Allow for up to 50 opened tabs on Vim start.
if &tabpagemax < 50
  set tabpagemax=50
endif
" Reload unchanged files automatically.
set autoread
" Increase history size to 1000 items.
if &history < 1000
  set history=1000
endif
" Auto center on matched string.
noremap n nzz
noremap N Nzz
" Enable saving by `Ctrl-s`
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>
" Make sure pasting in visual mode doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()



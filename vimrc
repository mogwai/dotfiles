"vim-plug to install plugins
call plug#begin('~/.vim/plugged')

"Fuzzy File Finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Git commands and blame
Plug 'tpope/vim-fugitive'

"Fuzzy File Finder vim bindings
Plug 'junegunn/fzf.vim'

"Autocomplete, Formatting, Linting
"Make sure that you :CocInstall coc-python for python
"and any other lagauge that you are interested in using
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Theme
Plug 'morhetz/gruvbox'
"Comment blocks after entering Visual Block Mode <C-l>
"using \ + /
Plug 'tpope/vim-commentary'

" Pydoc string
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }

Plug 'zivyangll/git-blame.vim'

" Auto indentation
Plug 'https://github.com/tpope/vim-sleuth'

" Indentation Guides
Plug 'nathanaelkane/vim-indent-guides'

" Open files with line number file.txt:123
Plug 'kopischke/vim-fetch'

Plug 'powerline/powerline'

" Cool status bar stuff
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

"Vim Github Links
Plug 'knsh14/vim-github-link'
Plug 'ruanyl/vim-gh-line'

call plug#end()

"gruvbox color theme
autocmd vimenter * colorscheme gruvbox
"Dark mode for the theme
set bg=dark

"Prevent COC Warning
let g:coc_disable_startup_warning = 1

syntax enable
set tabstop=4
set shiftwidth=4
set expandtab ts=4 sw=4 ai
set number
filetype plugin indent on
set hidden
set nobackup
set nowritebackup
set hlsearch
set cmdheight=1
set mouse=a
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" " delays and poor user experience.
set updatetime=300

"Keybindings
" map <C> :NERDTreeToggle<CR>
map  <C-n> :tabnew<CR>
map <C-p> :History<CR>
map <C-F> :Rg<CR>

"use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
      let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <silent><expr> <Tab>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<Tab>" :
          \ coc#refresh()

if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

"Go to Definition
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)

"Find all references
nmap <silent> gr <Plug>(coc-references)

command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

"Setup ripgrep
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
"Use the current direcotry
let g:rg_derive_root='true'

noremap <leader>/ :Commentary<cr>

"Copy and Paste from Clipboard
set clipboard+=unnamed

vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa


"Enable Persistent Undo
if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature
  set undodir=$HOME/.vim/undo  "directory where the undo files will be stored
  endif

"Jump to last position when opening
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
" Clears highlighting from using /
nnoremap <silent><CR> :noh<CR><CR>

" Runs the string in the environment variale when \ + Enter is
" pressed. For example, `export VMCD=python main.py`
map <silent> <buffer> <leader><Enter> :w<CR>:! eval $VCMD<CR>

" Choose python interpreter
if $CONDA_PREFIX == ""
  let s:current_python_path=$CONDA_PYTHON_EXE
else
  let s:current_python_path=$CONDA_PREFIX.'/bin/python'
endif
call coc#config('python', {'pythonPath': s:current_python_path})

" Remove help screen when pressing f1
:nmap <F1> :echo<CR>
:imap <F1> <C-o>:echo<CR>

" Change the swap file directory and backup directory
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

" Fix the cursor in the middle of the screen
set so=999

" Show code documentation
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Allows writing to files with root priviledges
cmap w!! w !sudo tee % > /dev/null <CR>

" Overwrite the :X to be :x to prevent typos
cmap X x
" Use Q for quit (Caps lock)
cmap Q q
" Prevent window selection
cmap W w

vnoremap > >gv
vnoremap < <gv

" Auto remove whitespace
autocmd BufWritePre * %s/\s\+$//e

" Git
" Git Blame
:nmap <leader>b :call gitblame#echo()<CR>

" Git Link
" If not using this then remove
:nmap % :GetCurrentBranchLink<CR>
" This is if you want the more advanced plugin to copy to clipboard instead of
" opening browser
"let g:gh_open_command = 'fn() { echo "$@" | pbcopy; }; fn '

" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

" Powerline
let g:airline_powerline_fonts = 1
let g:airline_theme='minimalist'
set laststatus=1 " Always display the statusline in all windows
set showtabline=0 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

" Insert time when you press F5
inoremap <F5> <C-R>=strftime("%F")<CR>

" Select All
nnoremap <C-A> ggVG

" Disable EX mode
nnoremap Q <Nop>

" Copy github lines link to clipboard
let g:gh_open_command = 'fn() { echo "$@" | clip; }; fn '

" Case insensitive search
set smartcase

" Go to last file(s) if invoked without arguments.
autocmd VimLeave * nested if (!isdirectory($HOME . "/.vim")) |
    \ call mkdir($HOME . "/.vim") |
    \ endif |
    \ execute "mksession! " . $HOME . "/.vim/Session.vim"

autocmd VimEnter * nested if argc() == 0 && filereadable($HOME . "/.vim/Session.vim") |
    \ execute "source " . $HOME . "/.vim/Session.vim"

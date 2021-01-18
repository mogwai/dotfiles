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

" Auto indentation
Plug 'https://github.com/tpope/vim-sleuth' 

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
set expandtab
set number
filetype indent on
set hidden
set nobackup
set nowritebackup
set hlsearch
set cmdheight=2
set mouse=a
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" " delays and poor user experience.
set updatetime=300

"Keybindings
" map <C> :NERDTreeToggle<CR>
map  <C-n> :tabnew<CR>
map <C-p> :Files<CR>
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


set statusline=
set statusline+=%7*\[%n]                                  "buffernr
set statusline+=%1*\ %<%F\                                "File+path
set statusline+=%2*\ %y\                                  "FileType
set statusline+=%3*\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
set statusline+=%3*\ %{(&bomb?\",BOM\":\"\")}\            "Encoding2
set statusline+=%4*\ %{&ff}\                              "FileFormat (dos/unix..) 
set statusline+=%8*\ %=\ row:%l/%L\ (%03p%%)\             "Rownumber/total (%)
set statusline+=%9*\ col:%03c\                            "Colnr
set statusline+=%0*\ \ %m%r%w\ %P\ \                      "Modified? Readonly? Top/bot.
set statusline+=%{coc#status()}%{get(b:,'coc_current_function','')}

command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

"Setup ripgrep
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
"Use the current direcotry 
let g:rg_derive_root='true'

noremap <leader>/ :Commentary<cr>

"Copy and Paste from Clipboard
set clipboard+=unamed

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
" aswell as Q for quit
"
cmap X x
cmap Q q

vnoremap > >gv
vnoremap < <gv

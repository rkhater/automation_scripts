execute pathogen#infect('bundle/{}', '~/src/vim/bundle/{}')
set nocompatible
set shell=/bin/bash
let mapleader = " "

" my settings "
set backspace=2                                       " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set showcmd                                           " display incomplete commands
set incsearch                                         " do incremental searching
set ignorecase
set smartcase
set autowrite                                         " Automatically :write before running commands
set timeoutlen=500
set t_Co=256
set nu                                                " show line numbers
set noeb vb                                           " Disable annoying bells
set laststatus=2                                      " show status line
set ruler
set showmatch                                         " show matching bracket
set nohlsearch                                        " remove highligting after search complete
set list listchars=tab:»·,trail:·,nbsp:·              " Display trailing whitespace and tabs
syntax on                                             " syntax highlighting
filetype plugin indent on                             " required
map <F7> mzgg=Gz<CR>
set foldmethod=manual
set foldnestmax=10
set nofoldenable
set foldlevel=2
inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

" tabs and spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Move inside wrapped lines
nnoremap <silent> j gj
nnoremap <silent> k gk
vnoremap <silent> j gj
vnoremap <silent> k gk

" Moving between panes
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-Tab-right> <C-w>h
nnoremap <C-Tab-down> <C-w>j
nnoremap <C-Tab-up> <C-w>k
nnoremap <C-Tab-left> <C-w>l

" " airline
let g:airline_powerline_fonts = 1
let g:bufferline_echo = 0
let g:airline_theme = 'dark'
" fix powerlines
if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline#extensions#tabline#enabled = 1          " shows tabs


" alt + direction for buffer swapping
nnoremap <A-left> :bp<cr>
nnoremap <A-right> :bn<cr>

" Silly typos that i hate
command WQ wq
command Wq wq
command W w
command Q q


" " Obsession
" Load previsou session
nmap <F5> :source Session.vim<CR>

" " suspend by f12
nnoremap <F12> :suspend<CR>

" NERDTree customizations
let NERDTreeQuitOnOpen = 1
nnoremap <C-F> :NERDTreeFind<CR>                      " Ctrl+F triggers NERDTreeFind
silent! nnoremap <F2> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" space + w closes buffer
nnoremap <leader>w :bw<CR>
" space + q closes all
nnoremap <leader>q :qa<CR>

nnoremap <S-t> :tabnew<CR>
"nnoremap <C-S-w> :tabclose<CR>
"inoremap <C-S-w> <Esc>:tabclose<CR>
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-Up> :tabfirst<CR>
nnoremap <C-Down> :tablast<CR>
nnoremap <C-S-Up> :tabm 0<CR>
nnoremap <C-S-Down> :tabm<CR>

nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 1

" " CtrlP Settings
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
" Use Ag over Grep
set grepprg=ag\ --nogroup\ --nocolor
" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" ag is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0
endif
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" Gundo shortcut
nnoremap <F4> :GundoToggle<CR>
let g:gundo_preview_bottom = 1
let g:gundo_close_on_revert = 1
let g:gundo_width = 60
let g:gundo_preview_height = 40
let g:gundo_right = 1

" Easy motion search to replace the default
map / <Plug>(easymotion-sn)
let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap s <Plug>(easymotion-s2)
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
" JK motions: Line motions
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

" Git gutter goodies
nnoremap <Leader><Right> :GitGutterPreviewHunk<CR>  " Leader + Right shows hunk
nnoremap <A-Down> :GitGutterNextHunk<CR>            " Alt + Down shows next hunk
nnoremap <A-Up> :GitGutterPrevHunk<CR>              " Alt + Up shows previous hunk

" alt + direction for buffer swapping
nnoremap <A-left> :bp<cr>
nnoremap <A-right> :bn<cr>

" space + q closes all
nnoremap <leader>q :qa<CR>

au FocusLost * silent! wa                          "auto save when loosing focus


"Automatically set/unset paste mode when you paste.
set pastetoggle=<F3>

let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

let g:snippets_dir = "/home/ramy/.vim/snippets"
"let g:ycm_key_list_select_completion = []
imap <C-J> <esc>a<Plug>snipMateNextOrTrigger
smap <C-J> <Plug>snipMateNextOrTrigger
let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['ruby'] = 'ruby,rails,html'

nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

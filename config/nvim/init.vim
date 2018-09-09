" vim:fileencoding=utf-8:ft=vim:foldmethod=marker:tw=80

" BASICS {{{
" We've just elected new leader, welcome "," key!
let mapleader = ","

"
" }}} BASICS

" CONTROLS {{{
"
" Use mouse for visual text selection and windows resizing
if has('mouse')
  set mouse=a
endif

" Disable arrow keys
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Save current file in mac-like style
noremap <silent> <A-s> :w<CR>
inoremap <silent> <A-s> <Esc>:w<CR>

" Windows navigation
" Use Alt-key rather than C-W-key
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-n> <C-\><C-N><C-w>j
tnoremap <A-e> <C-\><C-N><C-w>k
tnoremap <A-i> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-n> <C-\><C-N><C-w>j
inoremap <A-e> <C-\><C-N><C-w>k
inoremap <A-i> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-n> <C-w>j
nnoremap <A-e> <C-w>k
nnoremap <A-i> <C-w>l
" And Alt-w just two Ctrl-w
tnoremap <A-w> <Esc><C-w><C-w>
inoremap <A-w> <C-w><C-w>
nnoremap <A-w> <C-w><C-w>

" Use Alt-C to close active window
nnoremap <A-c> <C-W>c
" Use Alt-O to show 'only' active window
nnoremap <A-o> <C-W>o

" Move current tab to the left and the right
nnoremap <A-,> :tabmove -<CR>

" Moving (TODO: check for Colemak)
nnoremap <A-H> <C-w>H
nnoremap <A-J> <C-w>J
nnoremap <A-K> <C-w>K
nnoremap <A-L> <C-w>L
nnoremap <A-x> <C-w>x

" Resizing
nnoremap <A-=> <C-w>=
nnoremap <A-+> <C-w>+
nnoremap <A--> <C-w>-
nnoremap <A-<> <C-w><
nnoremap <A->> <C-w>>

" One thing to keep in mind is that by default, vim won't let you switch between
" buffers without saving current buffer you are in first. This gets old pretty
" quick, and is not helpful when you are just one file as a reference.  To get
" around this, you can set the 'hidden' option, whitch will let you switch
" between buffers freely and keep your undo history for each.
set hidden

" Open new split below and on right
set splitbelow
set splitright

" Delete buffer without losing the split window
" https://stackoverflow.com/questions/4465095/vim-delete-buffer-without-losing-the-split-window
" will switch to the last used buffer, then bd# ("buffer detete" "alternate file")
nmap <silent> <leader>d :b#\|bd #<CR>

" Scrolling
set scrolloff=20    " Start scrolling when we're 20 lines away from margins
set sidescrolloff=15
set sidescroll=1

" }}} CONTROLS

" TERMINAL {{{
" NVIM Terminal emulator
" Use just Esc to exit from terminal input mode
tnoremap <Esc> <C-\><C-n>

" Ctrl-V in terminal mode
tmap <C-V>    <C-\><C-n>"+gPi

" Borrowed from https://github.com/hneutr/dotfiles/blob/cc62da8c8110f1e16c77112e8679fdbd99b4c9dd/config/nvim/plugin/autocommands.vim
augroup startup
    autocmd!

    " save whenever things change
    autocmd TextChanged,InsertLeave * call lib#SaveAndRestoreVisualSelectionMarks()

    " turn numbers on for normal buffers; turn them off for terminal buffers
    autocmd TermOpen,BufWinEnter * call lib#SetNumberDisplay()

    " when in a neovim terminal, add a buffer to the existing vim session
    " instead of nesting (credit justinmk)
    autocmd VimEnter * if !empty($NVIM_LISTEN_ADDRESS) && $NVIM_LISTEN_ADDRESS !=# v:servername
        \ |let g:r=jobstart(['nc', '-U', $NVIM_LISTEN_ADDRESS],{'rpc':v:true})
        \ |let g:f=fnameescape(expand('%:p'))
        \ |noau bwipe
        \ |call rpcrequest(g:r, "nvim_command", "edit ".g:f)
        \ |call rpcrequest(g:r, "nvim_command", "call lib#SetNumberDisplay()")
        \ |qa
        \ |endif

    " use relative numbers for focused area (maybe turn this back on with a
    " check for if number is turned on or not?)
    " autocmd BufEnter,FocusGained * call lib#NumberToggle(1)
    " autocmd BufLeave,FocusLost * call lib#NumberToggle(0)

    " enter insert mode whenever we're in a terminal
    autocmd TermOpen,BufWinEnter,BufEnter term://* startinsert
augroup END


" }}} TERMINALS

" TABS&SPACES {{{
" https://github.com/widgetii/rusvimnotes/blob/master/spacestabs.md

" Show invisible characters
set listchars=tab:▸\ ,trail:·,precedes:←,extends:→
set list

" show existing tab with 4 spaces width
set tabstop=4
"
"
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" You can replace all the tabs with spaces in the entire file with
"
" :%retab
"
" }}} TABS&SPACES

" TEXT EDITING {{{
"
" makes possible undo Ctrl-W operation in insert mode
inoremap <C-w> <C-g>u<C-w>

set textwidth=80

inoremap hh <BS>
inoremap рр <BS>
imap цц <C-w>
imap ww <C-w>
"
"
"
"
" }}} TEXT EDITING

" PROGRAMMING {{{
" Here's a quick hack that will save you strokes: y'all know that ci( and ci) are practically the same, so you can do 
nnoremap ci) %ci)
" to edit the content of a nearby () when cursor is outside on the same line
" }}} PROGRAMMING

" CLIPBOARD {{{
":h clipboard
set clipboard+=unnamedplus

" }}} CLIPBOARD

" SEARCHING {{{
" turn off search highlight
nnoremap <silent> <leader><space> :nohlsearch<CR>

" }}} SEARCHING

" {{{ FOLDING

" TESTING!!!!!!!!
" from https://dougblack.io/words/a-good-vimrc.html
"set foldenable          " enable folding
"set foldlevelstart=10   " open most folds by default
"set foldnestmax=10      " 10 nested fold max
"set foldmethod=indent   " fold based on indent level




" very tricky way to type Space rather than Shift-;
" but we need to provide key for unfold
" TODO: if we just hit Space key and opened fold and stayed here, Space will close it again
function! KeySpace()
  if foldclosed(line('.')) == -1
    call feedkeys(":")
  else
    norm za
  endif
endfunction

nnoremap <silent> <Space> :call KeySpace()<CR>


" }}} FOLDING

" LOCALIZATION {{{
" https://habr.com/post/98393/
"set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
" COLEMAK below"
set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwfpgjluy\\;[]arstdhneio'zxcvbkm\\,.~QWFPGJLUY:{}ARSTDHNEIO\\"ZXCVBKM<>

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
"highlight lCursor guifg=NONE guibg=Cyan

" }}} LOCALIZATION

" A minimalist Vim plugin manager https://github.com/junegunn/vim-plug
call plug#begin()
" List the plugins with Plug commands

Plug 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1

Plug 'scrooloose/nerdtree'
" NERDTree settings {{{
let g:NERDTreeMinimalUI = 1

" use Ctrl-n for invoke NERDTree
map <silent> <C-n> :NERDTreeToggle<CR>

" How can I open a NERDTree automatically when vim starts up?
" https://stackoverflow.com/questions/24808932/vim-open-nerdtree-and-move-the-cursor-to-the-file-editing-area
"autocmd VimEnter * if argc() == 1 | NERDTree | wincmd p | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"
" NERDTree settings }}}

Plug 'Xuyuanp/nerdtree-git-plugin'
" Nerdtree git plugin symbols
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "ᵐ",
    \ "Staged"    : "ˢ",
    \ "Untracked" : "ᵘ",
    \ "Renamed"   : "ʳ",
    \ "Unmerged"  : "ᶴ",
    \ "Deleted"   : "ˣ",
    \ "Dirty"     : "˜",
    \ "Clean"     : "ᵅ",
    \ "Unknown"   : "?"
    \ }

Plug 'vim-airline/vim-airline'
" vim-airline settings {{{
"let g:airline#extensions#tabline#enabled = 1
"let g:airline_extensions = []

" After installing statusline plugin by the way, -- INSERT -- is unnecessary
" anymore because the mode information is displayed in the statusline.
" lightline.vim - tutorial If you want to get rid of it, configure as follows.
set noshowmode
" vim-airline settings}}}

" Polyglot syntax pack
Plug 'sheerun/vim-polyglot'

" Auto pairs
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsFlyMode = 1

" Color parentheses
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

" TODO: check vim-airline tab management
Plug 'bagrat/vim-workspace'
" vim-workspace settings{{{
" use vim-devicons symbols
let g:workspace_powerline_separators = 1
let g:workspace_tab_icon = "\uf00a"
let g:workspace_left_trunc_icon = "\uf0a8"
let g:workspace_right_trunc_icon = "\uf0a9"

let g:workspace_hide_buffers = ['term://']

" Here are some recommended mappings to boost your navigation experience
noremap <Tab> :WSNext<CR>
noremap <S-Tab> :WSPrev<CR>
noremap <Leader><Tab> :WSClose<CR>
noremap <Leader><S-Tab> :WSClose!<CR>
noremap <C-t> :WSTabNew<CR>

cabbrev bonly WSBufOnly

" vim-workspace settings}}}

"Plug 'junegunn/vim-easy-align'

" Neat startup screen
Plug 'mhinz/vim-startify'

" Intelligently reopen files at your last edit position. By default git, svn,
" and mercurial commit messages are ignored because you probably want to type a
" new message and not re-edit the previous one
Plug 'farmergreg/vim-lastplace'

" use 24-bit color
set termguicolors

" Colorschemes, pick one, but others stay disabled
"Plug 'altercation/vim-colors-solarized'
"Plug 'JulioJu/neovim-qt-colors-solarized-truecolor-only'

Plug 'morhetz/gruvbox'
" GRUVBOX {{{
colorscheme gruvbox
set background=dark
let g:gruvbox_italic=1
let g:gruvbox_terminal_colors = 1
" }}}

" SEOUL256 {{{
"Plug 'junegunn/seoul256.vim'
"let g:seoul256_background = 233
"colorscheme seoul256

" This can help for broken background in seoul256 theme on some terminals
"highlight Normal ctermbg=NONE
"highlight nonText ctermbg=NONE
" }}}

Plug 'KabbAmine/zeavim.vim'

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

" You should run cargo build --release in the plugin directory after installation on new machine
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

" If you use vim-airline you need this
let g:airline_powerline_fonts = 1
" Always load the vim-devicons as the very last one.
Plug 'ryanoasis/vim-devicons'

" Language Client Support
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

let g:LanguageClient_serverCommands = {
    \ 'python': ['/usr/bin/pyls'],
    \ 'cpp': ['/usr/bin/cquery', '--log-file=/tmp/cq.log'],
    \ 'c': ['/usr/bin/cquery', '--log-file=/tmp/cq.log'],
    \ }
let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '~/.config/nvim/settings.json'


nnoremap <silent> <leader>k :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
nn <silent> <M-,> :call LanguageClient_textDocument_references()<cr>
nn <silent> <F9> :call LanguageClient_textDocument_codeAction()<cr>
nn <silent> <F1> :call LanguageClient#explainErrorAtPoint()<cr>
"set completefunc=LanguageClient#complete
"set formatexpr=LanguageClient_textDocument_rangeFormatting()

Plug 'https://github.com/Kris2k/A.vim.git'
  let g:alternateExtensions_cc = "hh,h,hpp"
  let g:alternateExtensions_hh = "cc"
  let g:alternateExtensions_hxx = "cxx"
  let g:alternateExtensions_cxx = "hxx,h"

Plug 'martong/vim-compiledb-path'

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'
" Fuzzy finder shortcut
nnoremap <C-p> :FZF<CR>

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Use deoplete.
let g:deoplete#enable_at_startup = 1

call plug#end() " to update &runtimepath and initialize plugin system 
" Automatically executes filetype plugin indent on and syntax enable. You can
" revert the settings after the call. e.g. filetype indent off, syntax off, etc.


" LINENUMBERS {{{
" Use number&relativenumber for j and k keys with quick motions
" See more at http://learnvimscriptthehardway.stevelosh.com/chapters/02.html
set number
set relativenumber
" Use F12 for quickly remove line numbers
noremap <silent> <F12> :set number!<CR> :set relativenumber!<CR>
" }}}

" https://github.com/ryanoasis/vim-devicons/wiki/FAQ-&-Troubleshooting
" How do I solve issues after re-sourcing my vimrc?
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

" FOR FUTURE LEARNING
" Targets.vim is a Vim plugin that adds various text objects to give you more targets to operate on
"https://github.com/wellle/targets.vim
"https://github.com/ggreer/the_silver_searcher
"+https://github.com/mileszs/ack.vim
"Exuberant Ctags - Faster than Ag, but it builds an index beforehand. Good for really big codebases.
"Test on Linux kernel
"In one of its cleverest innovations, Vim doesn't model undo as a simple stack. In Vim it's a tree. This makes sure you never lose an action in Vim, but also makes it much more difficult to traverse around that tree. gundo.vim fixes this by displaying that undo tree in graphical form
"https://github.com/sjl/gundo.vim
" others - https://dougblack.io/words/a-good-vimrc.html
"https://github.com/jiangmiao/auto-pairs

" Try tmux+vimux
"https://www.braintreepayments.com/blog/vimux-simple-vim-and-tmux-integration/
" Or maybe nvimux https://github.com/BurningEther/nvimux ??
" https://www.reddit.com/r/neovim/comments/7i2k6u/neovim_terminal_one_week_without_tmux/


" TARMAK1

noremap n j|noremap <C-w>n <C-w>j|noremap <C-w><C-n> <C-w>j
noremap e k|noremap <C-w>e <C-w>k|noremap <C-w><C-e> <C-w>k
noremap k n
noremap K N
noremap j e
noremap J E
noremap о j
noremap л k

" TARMAK5
noremap s i
"noremap S I
noremap i l

" BOL/EOL/Join Lines.
noremap l ^|noremap L $|noremap <C-l> J
" r replaces i as the "inneR" modifier [e.g. "diw" becomes "drw"].
onoremap r i

" problem in NERD Tree
" e key don't go up
let g:NERDTreeMapOpenExpl = ''


" https://github.com/tpope/vim-eunuch

"function! ToggleQuickFix()
"   if len(filter(getwininfo(), 'v:val.quickfix'))
"      cclose
"   else
"      copen
"   endif
"endfunction

" Tricks?
" Sudo editing
fun! SuperWrite()
    "write !sudo tee %
    " Or with :silent (but that doesn't seem to work for everyone)
    silent write !sudo tee % > /dev/null
    edit!
    echo "Sudo writed %"
endfun
command! -nargs=0 W call SuperWrite()


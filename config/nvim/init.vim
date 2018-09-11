" vim:fileencoding=utf-8:ft=vim:foldmethod=marker:tw=80

" BASICS {{{
" We've just elected new leader, welcome "," key!
let mapleader = ","
let os = substitute(system('uname'), "\n", "", "")

let g:vim_config = $HOME . "/.config/nvim/"

let s:modules = [
    \"settings",
    \"mappings",
    \"plugins",
    \]

for s:module in s:modules
    execute "source" g:vim_config . s:module . ".vim"
endfor
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
" Your also will need this file https://github.com/hneutr/dotfiles/blob/cc62da8c8110f1e16c77112e8679fdbd99b4c9dd/config/nvim/autoload/lib.vim
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

" Test scrolling problems 
let g:neoterm_autoscroll = 1
" Test if will any problems
"let g:neoterm_autoinsert=1

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

" GRUVBOX {{{
colorscheme gruvbox
set background=dark
let g:gruvbox_italic=1
let g:gruvbox_terminal_colors = 1
" Don't show tildes on blank lines
highlight NonText ctermfg=bg guifg=bg
" }}}

" SEOUL256 {{{
"let g:seoul256_background = 236
"colorscheme seoul256
"
"" This can help for broken background in seoul256 theme on some terminals
"highlight Normal ctermbg=NONE
"highlight nonText ctermbg=NONE
" }}}

" LINENUMBERS {{{
" Use number&relativenumber for j and k keys with quick motions
" See more at http://learnvimscriptthehardway.stevelosh.com/chapters/02.html
set number
set relativenumber
" Use F12 for quickly remove line numbers
noremap <silent> <F12> :set number!<CR> :set relativenumber!<CR>
" }}}

" COLEMAK {{{
" TARMAK1
noremap n j|noremap gn gj|noremap <C-w>n <C-w>j|noremap <C-w><C-n> <C-w>j|noremap о j
noremap e k|noremap ge gk|noremap <C-w>e <C-w>k|noremap <C-w><C-e> <C-w>k|noremap л k
noremap k n
noremap K N
noremap j e
noremap J E

" TARMAK5
noremap s i|noremap в i
"noremap S I
noremap i l|noremap д l

" BOL/EOL/Join Lines.
noremap l ^|noremap L $|noremap <C-l> J
" r replaces i as the "inneR" modifier [e.g. "diw" becomes "drw"].
onoremap r i

" problem in NERD Tree
" e key don't go up
let g:NERDTreeMapOpenExpl = ''
" }}}

" TESTING {{{
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

" Close quickfix & help with q, Escape, or Control-C
" Also, keep default <cr> binding
augroup easy_close
    autocmd!
    autocmd FileType help,qf nnoremap <buffer> q :q<cr>
    autocmd FileType help,qf nnoremap <buffer> <Esc> :q<cr>
    autocmd FileType help,qf nnoremap <buffer> <C-c> :q<cr>
augroup END
" }}}


" use cursor color in terminal (from Neovim FAQ)
" Cursor is same as on kitty
hi Cursor guifg=#8fee96 guibg=#8fee96
hi Cursor2 guifg=red guibg=red
set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50

" Copy on selection (from FAQ)
vnoremap <LeftRelease> "*ygv


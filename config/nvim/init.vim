" vim:fileencoding=utf-8:ft=vim:foldmethod=marker:tw=80

" BASICS {{{

" Clear old autocmds
augroup vimrc | autocmd! | augroup end

" We've just elected new leader, welcome "," key!
let mapleader = ","
set timeoutlen=5000
let s:is_tmux = !empty($TMUX)
let s:is_ssh = !empty($SSH_TTY)

let g:vim_config = $HOME . "/.config/nvim/"

let s:modules = [
            \ "settings",
            \ "mappings",
            \ "plugins",
            \]

for s:module in s:modules
    execute "source" g:vim_config . s:module . ".vim"
endfor
" https://google.github.io/styleguide/vimscriptguide.xml
"  use plugin-names-like-this, FunctionNamesLikeThis, CommandNamesLikeThis,
"  augroup_names_like_this, variable_names_like_this
" }}} BASICS

" CONTROLS {{{
"
" Use mouse for visual text selection and windows resizing
if has('mouse')
  set mouse=a
endif

" Disable arrow keys (for newbies)
"noremap <up> <nop>
"noremap <down> <nop>
"noremap <left> <nop>
"noremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>

" Make arrow keys do something useful
nnoremap <left> :vertical resize +2<cr>
nnoremap <right> :vertical resize -2<cr>
nnoremap <down> :resize -2<cr>
tnoremap <down> <C-\><C-N>:resize -2<cr>a
nnoremap <up> :resize +2<cr>
tnoremap <up> <C-\><C-N>:resize +2<cr>a

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

" delete window with d<C-?>
nnoremap d<C-n> <C-w>j<C-w>c
nnoremap d<C-e> <C-w>k<C-w>c
nnoremap d<C-h> <C-w>h<C-w>c
nnoremap d<C-i> <C-w>l<C-w>c

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
tnoremap <A-=> <C-w>=
tnoremap <A-+> <C-w>+
tnoremap <A--> <C-w>-
tnoremap <A-<> <C-w><
tnoremap <A->> <C-w>>

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

"" Scrolling
"set scrolloff=20    " Start scrolling when we're 20 lines away from margins
"set sidescrolloff=15
"set sidescroll=1

" }}} CONTROLS

" TERMINAL {{{
" NVIM Terminal emulator
" Use just Esc to exit from terminal input mode
tnoremap <Esc> <C-\><C-n>
" Close current terminal just by Esc
function! TerminalClose()
    if bufname("%") =~ "term://"
        let g:terminalHeight = winheight(0)
        silent! exec 'q'
    endif
endfunc
nnoremap <silent> <Esc> :call TerminalClose()<CR>

function! TerminalOpen()
    if bufname("%") =~ "NERD_tree_*"
        exe "normal \<c-w>\<c-l>"
    endif
    let bnr = bufname("term://*")
    if empty(bnr)
        silent! exec 'sp|terminal'
" uncomment if you want disposable terminal
"       silent! exec 'setlocal bufhidden=delete'
        silent! exec 'setlocal bufhidden=hide'
    else
        silent! exec 'sbuffer '.bnr
    endif
    silent! exec 'setlocal laststatus=0'
    let height = 10
    if exists("g:terminalHeight")
        let height = g:terminalHeight
    endif
    silent! exec 'resize '.height
endfunc
" Check if terminal is already on the screen
set switchbuf=useopen
nnoremap <silent> <leader>t :call TerminalOpen()<CR>

autocmd TermOpen * setl bufhidden=hide
autocmd TermOpen * setl nobuflisted
"autocmd TermOpen * setl laststatus=0

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
    autocmd TermOpen,BufWinEnter,BufEnter term://*zsh startinsert
augroup END

" Test scrolling problems
let g:neoterm_autoscroll = 1
" Test if will any problems
let g:neoterm_autoinsert=1

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
" Common file style conventions
au FileType dockerfile     setlocal noexpandtab list
au FileType fstab,systemd  setlocal noexpandtab list
au FileType gitconfig,toml setlocal noexpandtab list
" LLVM style by default, 2 spaces
" usr_30.txt, 30.2
au FileType c setlocal ts=8 sts=8 sw=8 tw=79 noet cindent fileformat=unix list
au FileType cpp setlocal ts=2 sts=2 sw=2 tw=79 et cindent fileformat=unix list
au FileType fortran setlocal ts=6 sts=6 sw=6 tw=79 noet cindent fileformat=unix list
au FileType html setlocal ts=2 sts=2 sw=2 tw=79 et ai fileformat=unix list
au FileType ruby setlocal ts=2 sts=2 sw=2 tw=79 et ai fileformat=unix list
au FileType sh   setlocal ts=2 sts=2 sw=2 tw=79 et ai fileformat=unix list
au FileType vim  setlocal ts=4 sts=4 sw=4 tw=79 et ai fileformat=unix list
au FileType javascript  setlocal ts=2 sts=2 sw=2 tw=79 et ai fileformat=unix list
au FileType python      setlocal ts=4 sts=4 sw=4 tw=79 et ai fileformat=unix list
au FileType yaml        setlocal ts=2 sts=2 sw=2 tw=79 et ai fileformat=unix list
au FileType hcl         setlocal ts=2 sts=2 sw=2 tw=79 et ai fileformat=unix list
au FileType asm setlocal ts=8 sts=8 sw=8 tw=79 noet cindent fileformat=unix list
au BufRead,BufNewFile MAINTAINERS setlocal ft=toml
au BufRead,BufNewFile */infra_gil/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile *.S set filetype=asm
au BufRead,BufNewFile objdump.c setlocal cindent cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1 sw=2 sts=2 fo-=ro fo+=cql

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

autocmd vimrc FileType markdown,gitcommit :setlocal spell spelllang=en,ru
set spellfile=$HOME/Dropbox/vim/spell/en.utf-8.add
" }}} TEXT EDITING

" PROGRAMMING {{{
" Here's a quick hack that will save you strokes: y'all know that ci( and ci) are practically the same, so you can do 
nnoremap ci) %ci)
" to edit the content of a nearby () when cursor is outside on the same line
" }}} PROGRAMMING

" CLIPBOARD {{{
":h clipboard
set clipboard+=unnamedplus

":h provider-clipboard
if s:is_ssh
    let cprov = expand('~/.config/nvim/bin/clipboard-provider')
    let g:clipboard = {
      \   'name': 'ocs52',
      \   'copy': {
      \      '+': cprov . " copy",
      \      '*': cprov . " copy",
      \    },
      \   'paste': {
      \      '+': {-> 1 },
      \      '*': {-> 1 },
      \   },
      \   'cache_enabled': 1,
      \ }
endif

" }}} CLIPBOARD

" SEARCHING {{{
" turn off search highlight
nnoremap <silent> <leader><space> :nohlsearch<Bar>:echo<CR>

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
function! s:KeySpace()
  if bufname("%") =~ "NERD_tree_*"
    exe "normal \<c-w>\<c-l>"
    return
  endif
  if foldclosed(line('.')) == -1
    call feedkeys(":")
  else
    norm za
  endif
endfunction

nnoremap <silent> <Space> :call <SID>KeySpace()<CR>

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
if isdirectory(g:vim_config."plugged/gruvbox")
    let g:gruvbox_terminal_colors = 1
    " Without backgroung lines italic font won't work
    let g:gruvbox_italic=1
    let g:gruvbox_undercurl=1
    set background=dark
    colorscheme gruvbox
    " Don't show tildes on blank lines
    highlight NonText ctermfg=bg guifg=bg
    " Fixing too much bold in method names
    hi! link Function GruvboxGreen
endif
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

" TESTING {{{
" Tricks?
" Sudo editing
fun! SuperWrite()
    "write !sudo tee %
    " Or with :silent (but that doesn't seem to work for everyone)
    silent write !sudo tee % > /dev/null
    edit!
    echo "Sudo writed " . expand('%')
endfun
command! -nargs=0 W call SuperWrite()

" Close quickfix & help with q, Escape, or Control-C
" Also, keep default <cr> binding
augroup easy_close
    autocmd!
    autocmd FileType help,qf nnoremap <buffer> q :q<cr>
    autocmd FileType help,qf nnoremap <buffer> <Esc> :q<cr>
    autocmd FileType help,qf nnoremap <buffer> <C-c> :q<cr>
    autocmd BufEnter __LanguageClient__ nnoremap <buffer> q :q<cr>
    autocmd BufEnter __LanguageClient__ nnoremap <buffer> <Esc> :q<cr>
    autocmd BufEnter __LanguageClient__ nnoremap <buffer> <C-c> :q<cr>
    autocmd BufEnter __LanguageClient__ setlocal nospell
augroup END
" }}}


" use cursor color in terminal (from Neovim FAQ)
" Cursor is same as on kitty
hi Cursor guifg=#8fee96 guibg=#8fee96
hi Cursor2 guifg=red guibg=red
set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50

" Copy on selection (from FAQ)
vnoremap <LeftRelease> "*ygv

" Repeat last command from cmdline N times
" e.g. repeat last :make command very useable with set autowriteall
nnoremap g. @:
set autowriteall

" From nvim 0.4
" Enables pseudo-transparency for a floating window
if has('nvim-0.4')
    set winblend=10
endif

" Use :Rg for file finds

" Don't cut to clipboard by default
"nnoremap d "_d
"vnoremap d "_d
nnoremap C "_C
vnoremap C "_C
nnoremap c "_c
xnoremap c "_c

" Work as man pager settings
let g:ft_man_folding_enable = 1

" When internal LSP will be ready
if luaeval("vim.lsp ~= nil")
    nnoremap <buffer> <C-]> :lua vim.lsp.request_async('textDocument/definition')
    let g:lsp_serverconfig_c = {"cmd": ["clangd", "--background-index"]}
    let g:lsp_serverconfig_rust = {"cmd": ["rls", "--some-opt"], "some_flag": v:true}
endif

" Better errors/warnings highlights using undercurls
hi CocUnderline gui=undercurl term=undercurl
hi CocErrorHighlight ctermfg=red  guifg=#c4384b gui=undercurl term=undercurl
hi CocWarningHighlight ctermfg=yellow guifg=#c4ab39 gui=undercurl term=undercurl

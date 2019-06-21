let s:plug_dir = g:vim_config . "plugged"
let s:plugin_settings_dir = g:vim_config . "startup/plugins"

" if the plug dir doesn't exists, install all them
" system deps: make, cargo
if !isdirectory(s:plug_dir)
    autocmd! VimEnter * PlugInstall
endif

" A minimalist Vim plugin manager https://github.com/junegunn/vim-plug
call plug#begin(s:plug_dir)
" List the plugins with Plug commands

" Convenient mode for writing in native language and
" quickly send commands in English without kb switch
Plug 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1
if os == "Darwin"
    let g:XkbSwitchLib = '/usr/local/bin/libxkbswitch.dylib'
elseif os == "Linux"
    let g:XkbSwitchLib = '/usr/lib/libxkbswitch.so'
endif

if os == "Darwin"
    Plug 'rizzatti/dash.vim'
    " Same mapping as in Zeal
    nmap <silent> <leader>z <Plug>DashSearch
elseif os == "Linux"
    Plug 'KabbAmine/zeavim.vim'
endif

Plug 'scrooloose/nerdtree'
" NERDTree settings {{{
let g:NERDTreeMinimalUI = 1

" use Ctrl-n for invoke NERDTree
map <silent> <C-q> :NERDTreeToggle<CR>

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
let g:airline_extensions = ['tabline', 'languageclient']

" After installing statusline plugin by the way, -- INSERT -- is unnecessary
" anymore because the mode information is displayed in the statusline.
" lightline.vim - tutorial If you want to get rid of it, configure as follows.
set noshowmode
" vim-airline settings}}}

" Polyglot syntax pack
Plug 'sheerun/vim-polyglot'

" Git support
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" * stage the hunk with (hunk add)
nmap <Leader>ha <Plug>GitGutterStageHunk
" * revert it with (hunk revert)
nmap <Leader>hr <Plug>GitGutterRevertHunk

" Auto pairs
Plug 'jiangmiao/auto-pairs'
"let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutJump = '<M-k>'

" Color parentheses
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Neat startup screen
Plug 'mhinz/vim-startify'

" Intelligently reopen files at your last edit position. By default git, svn,
" and mercurial commit messages are ignored because you probably want to type a
" new message and not re-edit the previous one
Plug 'farmergreg/vim-lastplace'

" use 24-bit color
set termguicolors

" Colorschemes, pick one, but others stay disabled
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'

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
"Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
" don't open browser each time on md files
let g:markdown_composer_open_browser = 0

" If you use vim-airline you need this
let g:airline_powerline_fonts = 1
" Always load the vim-devicons as the very last one.
Plug 'ryanoasis/vim-devicons'

" Good thing for code refactoring, conversions to camelCase, snake_case,
" UPPER_CASE and so on
Plug 'tpope/vim-abolish'
" Need for working Colemak layout while use inneR object
let g:abolish_no_mappings = 1

" Convenient mappings for navigation
Plug 'tpope/vim-unimpaired'
" ]q is :cnext
" [q is :cprevious
" [b is :bprevious
" TODO: https://github.com/tpope/vim-unimpaired

" Language Client Support
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" See other options in langs.vim

" Cpp support {{{
Plug 'https://github.com/Kris2k/A.vim.git'
  let g:alternateExtensions_cc = "hh,h,hpp"
  let g:alternateExtensions_hh = "cc"
  let g:alternateExtensions_hxx = "cxx"
  let g:alternateExtensions_cxx = "hxx,h"
Plug 'drmikehenry/vim-headerguard'

" Use gf for jump to #include files based on compiledb info
Plug 'martong/vim-compiledb-path'
" Cpp support}}}

if executable('go')
    " Go support {{{
    Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
    let g:go_term_mode = "split"
    let g:go_term_height = 10
    let g:go_list_type = "quickfix"

    " run :GoBuild or :GoTestCompile based on the go file
    function! s:build_go_files()
        let l:file = expand('%')
        if l:file =~# '^\f\+_test\.go$'
            call go#test#Test(0, 1)
        elseif l:file =~# '^\f\+\.go$'
            call go#cmd#Build(0)
        endif
    endfunction

    function! Go_init()
        nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
        nmap <leader>r <Plug>(go-run)
        nmap <leader>n <Plug>(go-test)
        nmap <C-n> :cnext<CR>
        nmap <C-e> :cprevious<CR>
        nnoremap <leader>a :cclose<CR>
    endf
    autocmd FileType go call Go_init()

    " Autocompletion stuff
    Plug 'zchee/deoplete-go', { 'do': 'make'}
    let g:deoplete#sources#go#unimported_packages = 1
    " ATTENZIONE PREGO: install only https://github.com/mdempsky/gocode
    " }}}
endif

" Vimscript support {{{
Plug 'junegunn/vader.vim'
" }}}

" HTML support {{{
Plug 'mattn/emmet-vim', { 'for': ['javascript.jsx', 'html', 'css'] }
let g:user_emmet_install_global = 0
let g:user_emmet_settings = {
\  'javascript.jsx' : {
\      'extends' : 'jsx',
\  },
\}
autocmd FileType html,css,javascript.jsx imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
" autocmd for manual loading moved below 'call plug#end()' line to avoid E492
" error

" quick attributes, eg:
autocmd FileType html,css,javascript.jsx imap <leader>id id=""<esc>s
autocmd FileType html,css,javascript.jsx imap <leader>cl class=""<esc>s

" close last open tag
autocmd FileType html,css,javascript.jsx imap <leader>/ </<C-x><C-o>

" easy br:
imap <M-Return> <br />
nmap <M-Return> o<br /><esc>
" }}}

" Ansible support {{{
Plug 'pearofducks/ansible-vim'
" }}}

" Many langs formatter support (see plugin page) {{{
Plug 'sbdchd/neoformat'
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
" install formatters:
" pip install --user cmake_format
" rustup component add rustfmt && rustup component add clippy
" }}}

Plug 'embear/vim-localvimrc'
" Disable sandbox mode
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" Multi-entry selection UI.
Plug 'junegunn/fzf'

" Code was borrowed from https://github.com/junegunn/fzf.vim/issues/664
let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = &lines / 2
    let width = float2nr(&columns - (&columns * 2 / 4))
    let col = float2nr((&columns - width) / 2)

    let opts = {
                \ 'relative': 'editor',
                \ 'row': &lines / 5,
                \ 'col': col,
                \ 'width': width,
                \ 'height': height
                \ }

    call nvim_open_win(buf, v:true, opts)
endfunction

" Fuzzy finder shortcut
nnoremap <C-p> :FZF<CR>

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Use deoplete.
let g:deoplete#enable_at_startup = 1
" don't give |ins-completion-menu| messages.  For example,
" '-- XXX completion (YYY)', 'match 1 of 2', 'The only match',
set shortmess+=c
" I want to close the preview window after completion is done
autocmd InsertLeave * silent! pclose!

" Less annoying completion preview window based on neovim's floating window
Plug 'ncm2/float-preview.nvim'

Plug 'Shougo/echodoc.vim'

set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'

" Master t/f movements
Plug 'deris/vim-shot-f'
" Master j/k movements
Plug 'deris/vim-gothrough-jk'
let g:gothrough_jk_no_default_key_mappings = 1
let g:gothrough_jk_move_interval = 150000
nmap n <Plug>(gothrough-jk-j)
nmap e <Plug>(gothrough-jk-k)
vmap n <Plug>(gothrough-jk-j)
vmap e <Plug>(gothrough-jk-k)
nmap gn <Plug>(gothrough-jk-gj)
nmap ge <Plug>(gothrough-jk-gk)
vmap gn <Plug>(gothrough-jk-gj)
vmap ge <Plug>(gothrough-jk-gk)

Plug 'tpope/vim-surround'
" https://github.com/tpope/vim-surround, for surrounding by ", ', <tag>'"

call plug#end() " to update &runtimepath and initialize plugin system 
" Automatically executes filetype plugin indent on and syntax enable. You can
" revert the settings after the call. e.g. filetype indent off, syntax off, etc.

" https://github.com/ryanoasis/vim-devicons/wiki/FAQ-&-Troubleshooting
" How do I solve issues after re-sourcing my vimrc?
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

" Post vim-emmet plugin load command
autocmd FileType html,css,javascript.jsx EmmetInstall

" FOR FUTURE LEARNING
" Targets.vim is a Vim plugin that adds various text objects to give you more targets to operate on
"https://github.com/wellle/targets.vim
"https://github.com/ggreer/the_silver_searcher
"+https://github.com/mileszs/ack.vim
"In one of its cleverest innovations, Vim doesn't model undo as a simple stack. In Vim it's a tree. This makes sure you never lose an action in Vim, but also makes it much more difficult to traverse around that tree. gundo.vim fixes this by displaying that undo tree in graphical form
"https://github.com/sjl/gundo.vim
"mbbill/undotree
" others - https://dougblack.io/words/a-good-vimrc.html

" Try tmux+vimux
"https://www.braintreepayments.com/blog/vimux-simple-vim-and-tmux-integration/
" Or maybe nvimux https://github.com/BurningEther/nvimux ??
" https://www.reddit.com/r/neovim/comments/7i2k6u/neovim_terminal_one_week_without_tmux/

" https://github.com/tpope/vim-eunuch
" /tpope/vim-commentary - make comments
" airblade/vim-rooter - Changes Vim working directory to project root (identified by presence of known directory or file).
" MattesGroeger/vim-bookmarks - Vim bookmark plugin
" https://github.com/junegunn/vim-peekaboo - learning, Peekaboo extends " and @ in normal mode and <CTRL-R> in insert mode so you can see the contents of the registers.
" andymass/vim-matchup - Extends vim's % motion to language-specific words
" AndrewRadev/splitjoin.vim - switching between a single-line statement and a multi-line one
" rhysd/git-messenger.vim
" semanticart/tag-peek.vim

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
    Plug 'rizzatti/dash.vim', { 'on':  'DashSearch' }
    " Same mapping as in Zeal
    nmap <silent> <leader>z <Plug>DashSearch
elseif os == "Linux"
    Plug 'KabbAmine/zeavim.vim', { 'on': 'Zeavim' }
endif
" Also consider https://github.com/rhysd/devdocs.vim

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" NERDTree settings {{{
let g:NERDTreeMinimalUI = 1

" use Ctrl-q for invoke NERDTree
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

Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  'NERDTreeToggle' }
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
let g:airline#extensions#tabline#buffer_idx_mode=1
let g:airline#extensions#tabline#buffer_idx_format = {
    \ '0': '➓ ',
    \ '1': '➊ ',
    \ '2': '➋ ',
    \ '3': '➌ ',
    \ '4': '➍ ',
    \ '5': '➎ ',
    \ '6': '➏ ',
    \ '7': '➐ ',
    \ '8': '➑ ',
    \ '9': '➒ '
    \}
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>= <Plug>AirlineSelectNextTab

" After installing statusline plugin by the way, -- INSERT -- is unnecessary
" anymore because the mode information is displayed in the statusline.
" lightline.vim - tutorial If you want to get rid of it, configure as follows.
set noshowmode
" vim-airline settings}}}

" Polyglot syntax pack
Plug 'sheerun/vim-polyglot'

" Git support
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus', 'Gcommit', 'Gwrite', 'Gdiff',
            \ 'Gblame', 'Git', 'Ggrep'] }
" Try also https://github.com/jreybert/vimagit
Plug 'airblade/vim-gitgutter'
" * stage the hunk with (hunk add)
nmap <Leader>ha <Plug>GitGutterStageHunk
" * revert it with (hunk revert)
nmap <Leader>hr <Plug>GitGutterRevertHunk
" Git + Floating Preview Window
Plug 'rhysd/git-messenger.vim', { 'on':  'GitMessenger' }
" Consider https://github.com/rhysd/conflict-marker.vim
" https://github.com/rhysd/ghpr-blame.vim
" https://github.com/hotwatermorning/auto-git-diff

" Auto pairs
Plug 'jiangmiao/auto-pairs'
"let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutJump = '<M-k>'

" Color parentheses
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

Plug 'junegunn/vim-easy-align', { 'on':  'EasyAlign' }
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" Consider https://github.com/junegunn/vim-easy-align

" Neat startup screen (and sessions manager)
Plug 'mhinz/vim-startify'
let g:startify_bookmarks = [ {'c': '~/.config/nvim/init.vim'} ]
let g:startify_skiplist = ['init.vim', '/usr/local/Cellar/neovim/*']
let g:startify_custom_header = []
" Also you'd may prefer 'vim-rooter' with g:rooter_patterns
let g:startify_change_to_vcs_root = 1
" Use Vim sessions for all projects, so just after project directory creation do
" 'git init', open first file and:
" 1. For local projects do ':SSave', give it a name
" 2. For portable projects do ':mksession'
" and after that you can automatically restore your work via Startify
let g:startify_session_persistence = 1
" open portable project sessions using 'Session.vim' files
let g:startify_session_autoload = 1
let g:startify_lists = [
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ { 'type': 'commands',  'header': ['   Commands']       },
  \ ]

" Intelligently reopen files at your last edit position. By default git, svn,
" and mercurial commit messages are ignored because you probably want to type a
" new message and not re-edit the previous one
Plug 'farmergreg/vim-lastplace'

" use 24-bit color
set termguicolors

" Colorschemes, pick one, but others stay disabled
"Plug 'junegunn/seoul256.vim'
Plug 'gruvbox-community/gruvbox'

" Indent Lines
Plug 'Yggdroot/indentLine'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_bufTypeExclude = ['help', 'terminal']
let g:indentLine_bufNameExclude = ['_.*', 'NERD_tree.*', 'man://.*']

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
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer'), 'for':
    \ 'markdown' }
" don't open browser each time on md files
let g:markdown_composer_open_browser = 0

" Use grammar check
Plug 'rhysd/vim-grammarous', { 'for': 'markdown' }
" check comments only except for markdown and vim help
let g:grammarous#default_comments_only_filetypes = {
            \ '*' : 1, 'help' : 0, 'markdown' : 0,
            \ }
let g:grammarous#disabled_rules = {
            \ '*' : ['WHITESPACE_RULE', 'EN_QUOTES'],
            \ 'help' : ['WHITESPACE_RULE', 'EN_QUOTES', 'SENTENCE_WHITESPACE', 'UPPERCASE_SENTENCE_START'],
            \ }

" If you use vim-airline you need this
let g:airline_powerline_fonts = 1
" Always load the vim-devicons as the very last one.
Plug 'ryanoasis/vim-devicons', { 'on':  'NERDTreeToggle' }

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

" Outline support for LS
Plug 'liuchengxu/vista.vim', { 'on':  'Vista' }
let g:vista_default_executive = 'lcn'
nmap <F9> :Vista!!<CR>
"
" close vim if the only window left open is a Vista
autocmd bufenter * if (winnr("$") == 1 && bufname('') == '__vista__' && vista#sidebar#IsVisible()) | q | endif

" TODO:
" NearestMethodOrFunction from readme

" Cpp support {{{
Plug 'Kris2k/A.vim', { 'for': 'cpp' }
  let g:alternateExtensions_cc = "hh,h,hpp"
  let g:alternateExtensions_hh = "cc"
  let g:alternateExtensions_hxx = "cxx"
  let g:alternateExtensions_cxx = "hxx,h"
" Look at the alternative
" https://github.com/derekwyatt/vim-fswitch/blob/master/doc/fswitch.txt
Plug 'drmikehenry/vim-headerguard', { 'for': 'cpp' }

" Use gf for jump to #include files based on compiledb info
Plug 'martong/vim-compiledb-path', { 'for': 'cpp' }

" Consider https://github.com/rhysd/unite-n3337
" Cpp support}}}

if executable('go')
    " Go support {{{
    Plug 'fatih/vim-go', {'do': ':GoInstallBinaries', 'for': 'go'}
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
Plug 'junegunn/vader.vim', { 'on': 'Vader', 'for': 'vader' }

" TODO: test
"Plug 'fcpg/vim-complimentary'
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
autocmd FileType html,css,javascript.jsx imap <leader>/ </><esc>s<C-x><C-o>

" easy br:
imap <M-Return> <br />
nmap <M-Return> o<br /><esc>
" }}}

" CSS support {{{
Plug 'ap/vim-css-color', { 'for': 'css' }
" }}}

" Ansible support {{{
Plug 'pearofducks/ansible-vim', { 'for': 'yaml.ansible' }
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

"Plug 'embear/vim-localvimrc'
" Disable sandbox mode
"let g:localvimrc_sandbox = 0
"let g:localvimrc_ask = 0

" Multi-entry selection UI.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

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
Plug 'Shougo/neopairs.vim'

" Less annoying completion preview window based on neovim's floating window
Plug 'ncm2/float-preview.nvim'
let g:float_preview#docked = 0
set completeopt-=preview

function! DisableExtras()
  call nvim_win_set_option(g:float_preview#win, 'number', v:false)
  call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:false)
  call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
endfunction

autocmd User FloatPreviewWinOpen call DisableExtras()

Plug 'Shougo/echodoc.vim'
set cmdheight=2
let g:echodoc#enable_at_startup = 1
"let g:echodoc#type = 'signature'
let g:echodoc#type = 'floating'
" To use a custom highlight for the float window,
" change Pmenu to your highlight group
highlight link EchoDocFloat Pmenu

" Great learning block
" Master t/f movements
Plug 'deris/vim-shot-f'
" Alternative
" https://github.com/rhysd/clever-f.vim
" Also consider about f/t findings on next lines too
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
" Master your memory for multi-char mappings
"Plug 'fcpg/vim-showmap'
"https://github.com/liuchengxu/vim-which-key
" Easy to work with marks
Plug 'kshenoy/vim-signature'
" See what you copying
" Plug 'machakann/vim-highlightedyank'

Plug 'tpope/vim-surround'
" https://github.com/tpope/vim-surround, for surrounding by ", ', <tag>'"
" Also consider https://github.com/rhysd/vim-operator-surround

" Try to resolve paste troubles
"Plug 'ConradIrwin/vim-bracketed-paste'

Plug 'ntpeters/vim-better-whitespace'

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

" Post deoplete plugin load configuration
"call deoplete#custom#option('sources', {
"    \ '_': ['buffer'],
"    \ 'cpp': ['buffer', 'tag'],
"    \})
"    let g:deoplete#sources.cpp = ['LanguageClient']
" call deoplete#custom#option('ignore_sources', {'_': ['around', 'file', 'dictionary', 'tag', 'buffer']})
call deoplete#custom#option('skip_chars', [])
call deoplete#custom#source('_', 'converters', ['converter_auto_paren'])
" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_',
    \ 'disabled_syntaxes', ['Comment', 'String'])

call deoplete#custom#option('candidate_marks', ['A', 'R', 'S', 'T', 'D'])
inoremap <expr>A   pumvisible() ? deoplete#insert_candidate(0) : 'A'
inoremap <expr>R   pumvisible() ? deoplete#insert_candidate(1) : 'R'
inoremap <expr>S   pumvisible() ? deoplete#insert_candidate(2) : 'S'
inoremap <expr>T   pumvisible() ? deoplete#insert_candidate(3) : 'T'
inoremap <expr>D   pumvisible() ? deoplete#insert_candidate(4) : 'D'

"   This instructs deoplete to use omni completion for Go files.
call deoplete#custom#option('omni_patterns', {
\ 'go': '[^. *\t]\.\w*',
\})
" use the language keywords from syntax highlighting as a completion source
" https://github.com/Shougo/neco-syntax
"
"Another solution: Using neosnippet with the configuration.
"
"let g:neosnippet#enable_completed_snippet = 1
"autocmd CompleteDone * call neosnippet#complete_done()

" TODO:
" Test Vimscript + Deoplete + neco-vim


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
" https://github.com/hobbestigrou/vimtips-fortune , but spaced
" https://github.com/MaryHal/nvim_config/blob/master/init.vim
" matze/vim-move
" https://github.com/rhysd/reply.vim
" https://github.com/thinca/vim-quickrun/blob/master/doc/quickrun.txt
"  with config https://github.com/rhysd/dogfiles/blob/master/vimrc#L1759

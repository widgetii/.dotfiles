let s:plug_dir = g:vim_config . "plugged"
let s:plugin_settings_dir = g:vim_config . "startup/plugins"

" A minimalist Vim plugin manager https://github.com/junegunn/vim-plug
call plug#begin(s:plug_dir)
" List the plugins with Plug commands

Plug 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1
if os == "Darwin"
    let g:XkbSwitchLib = '/usr/local/bin/libxkbswitch.dylib'
elseif os == "Linux"
    let g:XkbSwitchLib = '/usr/lib/libxkbswitch.so'
endif

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
let g:airline#extensions#tabline#enabled = 1
let g:airline_extensions = []

" After installing statusline plugin by the way, -- INSERT -- is unnecessary
" anymore because the mode information is displayed in the statusline.
" lightline.vim - tutorial If you want to get rid of it, configure as follows.
set noshowmode
" vim-airline settings}}}

" Polyglot syntax pack
Plug 'sheerun/vim-polyglot'

" Git support
Plug 'airblade/vim-gitgutter'

" Auto pairs
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutJump = '<M-m>'

" Color parentheses
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

" TODO: check vim-airline tab management
Plug 'widgetii/vim-workspace'
" vim-workspace settings{{{
" use vim-devicons symbols
let g:workspace_powerline_separators = 1
let g:workspace_tab_icon = "\uf00a"
let g:workspace_left_trunc_icon = "\uf0a8"
let g:workspace_right_trunc_icon = "\uf0a9"
let g:workspace_hide_terms = 1

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
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'

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
    \ 'python': ['pyls'],
    \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
    \ 'c': ['cquery', '--log-file=/tmp/cq.log'],
    \ }
let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '~/.config/nvim/settings.json'


nnoremap <silent> <leader>k :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
nn <silent> <F3> :call LanguageClient#textDocument_references()<cr>
nn <silent> <F9> :call LanguageClient#textDocument_codeAction()<cr>
nn <silent> <F1> :call LanguageClient#explainErrorAtPoint()<cr>
"set completefunc=LanguageClient#complete
"set formatexpr=LanguageClient_textDocument_rangeFormatting()

Plug 'https://github.com/Kris2k/A.vim.git'
  let g:alternateExtensions_cc = "hh,h,hpp"
  let g:alternateExtensions_hh = "cc"
  let g:alternateExtensions_hxx = "cxx"
  let g:alternateExtensions_cxx = "hxx,h"
Plug 'drmikehenry/vim-headerguard'

Plug 'martong/vim-compiledb-path'

Plug 'embear/vim-localvimrc'
" Disable sandbox mode
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

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

" Try tmux+vimux
"https://www.braintreepayments.com/blog/vimux-simple-vim-and-tmux-integration/
" Or maybe nvimux https://github.com/BurningEther/nvimux ??
" https://www.reddit.com/r/neovim/comments/7i2k6u/neovim_terminal_one_week_without_tmux/

" https://github.com/tpope/vim-eunuch


" if the plug dir is empty, install
if empty(s:plug_dir)
    autocmd! VimEnter * PlugInstall
endif


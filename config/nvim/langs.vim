" FOR FAR FUTURE: try to use internal nvim LS client
"call lsp#server#add('cpp', 'cquery')
"call lsp#server#add('python', 'pyls')
"
"function! LSPRename()
"    let s:newName = input('Enter new name: ', expand('<cword>'))
"    call lsp#request_async('textDocument/rename',
"        \ {'newName': s:newName})
"endfunction
"
"au FileType lua,sh,c,python
"    \ noremap <silent> <buffer> <F2> :call LSPRename()<CR>

" Install LSes
" javascript: npm -g install javascript-typescript-langserver
"   Looks like javascript-typescript-langserver requires `jsconfig.json` to work
"   with javascript files.
" json: npm install -g vscode-json-languageserver-bin
" sh: npm -g install bash-language-server
" python: python-language-server python-pylint

let g:LanguageClient_serverCommands = {
    \ 'c': ['clangd', '-clang-tidy'],
    \ 'cpp': ['clangd', '-clang-tidy'],
    \ 'cuda': ['clangd'],
    \ 'json': ['json-languageserver', '--stdio'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'objc': ['clangd'],
    \ 'python': ['pyls'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'sh': ['bash-language-server', 'start'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ }
let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '~/.config/nvim/settings.json'

" Uncomment to find bugs
"let g:LanguageClient_loggingLevel = 'INFO'
"let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
"let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'

let g:LanguageClient_rootMarkers = {
    \ 'go': ['.git', 'go.mod'],
    \ }
    "\ 'go': ['~/go/bin/go-langserver', '-gocodecompletion'],
    "\ 'go': ['bingo', '--logfile', '~/go.log', '--trace'],

function! LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <silent> <leader>lh :call LanguageClient#textDocument_hover()<CR>
        " Open in same window
        nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
        " Open in new split
        nnoremap <silent> gD :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
        nnoremap <silent> <leader>ll :call LanguageClient#textDocument_codeAction()<cr>
        nnoremap <silent> <leader>le :call LanguageClient#explainErrorAtPoint()<cr>

        " Example bindings combining with tpope/vim-abolish
        " Rename - rn => rename
        noremap <leader>lrn :call LanguageClient#textDocument_rename()<CR>
        " Rename - rc => rename camelCase
        noremap <leader>lrc :call LanguageClient#textDocument_rename(
            \ {'newName': Abolish.camelcase(expand('<cword>'))})<CR>
        " Rename - rs => rename snake_case
        noremap <leader>lrs :call LanguageClient#textDocument_rename(
            \ {'newName': Abolish.snakecase(expand('<cword>'))})<CR>
        " Rename - ru => rename UPPERCASE
        " TODO: convert big-const to BIG_CONST
        noremap <leader>lru :call LanguageClient#textDocument_rename(
            \ {'newName': Abolish.uppercase(expand('<cword>'))})<CR>

        " Show references from all project to current symbol
        nnoremap <leader>lx :call LanguageClient#textDocument_references(
            \ {'includeDeclaration': v:false})<CR>
        " Find symbol in current file
        nnoremap <leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
        " Find symbol in all project
        nnoremap <leader>lw :call LanguageClient#workspace_symbol()<CR>
        nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
        nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>

        nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>

        augroup LanguageClient_config
            au!
            au BufEnter * let b:Plugin_LanguageClient_started = 0
            au User LanguageClientStarted setl signcolumn=yes
            au User LanguageClientStarted let b:Plugin_LanguageClient_started = 1
            au User LanguageClientStopped setl signcolumn=auto
            au User LanguageClientStopped let b:Plugin_LanguageClient_stopped = 0
            "au CursorMoved * if b:Plugin_LanguageClient_started | sil call LanguageClient#textDocument_documentHighlight() | endif
        augroup END

    endif
endfunction

" Vim-Go alike terminal (code borrowed and simplified)
fu! Term_New(bang, cmd) abort
  let mode = "split"

  let state = {
        \ 'cmd': a:cmd,
        \ 'bang' : a:bang,
        \ 'winid': win_getid(winnr()),
        \ 'stdout': []
      \ }

  " execute go build in the files directory
  let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd ' : 'cd '
  let dir = getcwd()

  execute cd . fnameescape(expand("%:p:h"))

  execute mode.' __my_term__'

  setlocal filetype=goterm
  setlocal bufhidden=delete
  setlocal winfixheight
  setlocal noswapfile
  setlocal nobuflisted

  let job = {}
"  let job = {
"        \ 'on_stdout': function('s:on_stdout', [], state),
"        \ 'on_exit' : function('s:on_exit', [], state),
"      \ }

  let state.id = termopen(a:cmd, job)
  let state.termwinid = win_getid(winnr())

  execute cd . fnameescape(dir)

  resize 10
endf

" Don't assign shortcuts on all filetypes
autocmd FileType c,cpp,cuda,objc,javascript,javascript.jsx,python,rust,sh,typescript call LC_maps()

fu! C_init()
" TODO: WTF?
"    setl formatexpr=LanguageClient#textDocument_rangeFormatting()
    nmap <leader>r :make run<CR>
    nmap <leader>b :make<CR>
endf
au FileType c,cpp,cuda,objc :call C_init()

fu! Rust_init()
    nmap <silent> <leader>n :call Term_New("", "cargo test")<CR>
    nmap <silent> <leader>r :call Term_New("", "cargo run")<CR>
    nmap <silent> <leader>b :call Term_New("", "cargo build")<CR>
endf
au FileType rust :call Rust_init()

function! s:exercism_tests()
    if expand('%:e') == 'vim'
        let testfile = printf('%s/%s.vader', expand('%:p:h'),
                    \ tr(expand('%:p:h:t'), '-', '_'))
        if !filereadable(testfile)
            echoerr 'File does not exist: '. testfile
            return
        endif
        source %
        execute 'Vader' testfile
    else
        let sourcefile = printf('%s/%s.vim', expand('%:p:h'),
                    \ tr(expand('%:p:h:t'), '-', '_'))
        if !filereadable(sourcefile)
            echoerr 'File does not exist: '. sourcefile
            return
        endif
        execute 'source' sourcefile
        Vader
    endif
endfunction

autocmd BufRead *.{vader,vim}
            \ command! -buffer Test call s:exercism_tests()
autocmd FileType vim :nmap <silent> <leader>n :Test<CR>

" FOR FAR FUTURE: try to use internal nvim LS client
"call lsp#server#add('cpp', 'cquery')
"call lsp#server#add('python', 'pyls')

" Install LSes
" javascript: npm -g install javascript-typescript-langserver
"   Looks like javascript-typescript-langserver requires `jsconfig.json` to work
"   with javascript files.
" sh: npm -g install bash-language-server

let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'cpp': ['clangd'],
    \ 'c': ['clangd'],
    \ 'cuda': ['clangd'],
    \ 'objc': ['clangd'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'sh': ['bash-language-server', 'start']
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
        nnoremap <silent> <leader>k :call LanguageClient#textDocument_hover()<CR>
        " Open in same window
        nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
        " Open in new split
        nnoremap <silent> gD :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
        nnoremap <silent> <F9> :call LanguageClient#textDocument_codeAction()<cr>
        nnoremap <silent> <F1> :call LanguageClient#explainErrorAtPoint()<cr>

        " Example bindings combining with tpope/vim-abolish
        " Rename - rn => rename
        noremap <leader>rn :call LanguageClient#textDocument_rename()<CR>
        " Rename - rc => rename camelCase
        noremap <leader>rc :call LanguageClient#textDocument_rename(
            \ {'newName': Abolish.camelcase(expand('<cword>'))})<CR>
        " Rename - rs => rename snake_case
        noremap <leader>rs :call LanguageClient#textDocument_rename(
            \ {'newName': Abolish.snakecase(expand('<cword>'))})<CR>
        " Rename - ru => rename UPPERCASE
        " TODO: convert big-const to BIG_CONST
        noremap <leader>ru :call LanguageClient#textDocument_rename(
            \ {'newName': Abolish.uppercase(expand('<cword>'))})<CR>

        " Show references from all project to current symbol
        nnoremap <leader>rf :call LanguageClient#textDocument_references(
            \ {'includeDeclaration': v:false})<CR>
        " Find symbol in current file
        nnoremap <leader>ro :call LanguageClient#textDocument_documentSymbol()<CR>
        " Find symbol in all project
        nnoremap <leader>rw :call LanguageClient#workspace_symbol()<CR>
        " LanguageClient#workspace_applyEdit()
        " LanguageClient#workspace_executeCommand()
        " TODO: try this -
        " https://github.com/MaskRay/ccls/wiki/LanguageClient-neovim#custom-cross-references

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

autocmd FileType * call LC_maps()

fu! C_init()
    setl formatexpr=LanguageClient#textDocument_rangeFormatting()
endf
au FileType c,cpp,cuda,objc :call C_init()


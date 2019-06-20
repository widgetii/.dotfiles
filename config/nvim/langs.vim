let g:LanguageClient_serverCommands = {}
let g:LanguageClient_autoStart = 1
" Uncomment to find bugs
"let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
"let g:LanguageClient_loggingLevel = 'INFO'
"let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'

" Extracted langservers from VS Code:
"  https://github.com/vscode-langservers
" CSS
" npm install -g vscode-css-languageserver-bin
let g:LanguageClient_serverCommands.css = ['css-languageserver', '--stdio']

" HTML
" npm install -g vscode-html-languageserver-bin
let g:LanguageClient_serverCommands.html = ['html-languageserver', '--stdio']
" TODO: TEST
autocmd FileType html nnoremap <buffer><Leader>f :call LanguageClient_textDocument_formatting()<CR>

" JSON
" npm install -g vscode-json-languageserver-bin
let g:LanguageClient_serverCommands.json = ['json-languageserver', '--stdio']

" Clangd language family: C, C++, ObjC, Cuda
let g:LanguageClient_serverCommands.c = ['clangd', '-clang-tidy']
let g:LanguageClient_serverCommands.cpp = ['clangd', '-clang-tidy']
let g:LanguageClient_serverCommands.cuda = ['clangd', '-clang-tidy']
let g:LanguageClient_serverCommands.objc = ['clangd', '-clang-tidy']

" Bash language server
"  https://github.com/mads-hartmann/bash-language-server
" npm install -g bash-language-server
let g:LanguageClient_serverCommands.sh = ['bash-language-server', 'start']

" Python
" install: python-language-server python-pylint
let g:LanguageClient_serverCommands.python = ['pyls']

" Rust
let g:LanguageClient_serverCommands.rust = ['~/.cargo/bin/rustup', 'run', 'stable', 'rls']

" JavaScript:
" npm install -g javascript-typescript-langserver
"   Looks like javascript-typescript-langserver requires 
"   `jsconfig.json` to work with javascript files.
let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
"let g:LanguageClient_serverCommands.javascript.jsx = ['javascript-typescript-stdio']
let g:LanguageClient_serverCommands.typescript = ['javascript-typescript-stdio']

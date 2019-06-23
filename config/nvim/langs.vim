let g:LanguageClient_serverCommands = {}
let g:LanguageClient_autoStart = 1
" Uses an absolute configuration path for system-wide settings
let g:LanguageClient_settingsPath = '~/.config/nvim/settings.json'

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

" JSON
" npm install -g vscode-json-languageserver-bin
let g:LanguageClient_serverCommands.json = ['json-languageserver', '--stdio']

" Clangd language family: C, C++, ObjC, Cuda
" https://clang.llvm.org/extra/clangd/Installation.html
let g:LanguageClient_serverCommands.c = ['clangd', '-clang-tidy']
let g:LanguageClient_serverCommands.cpp = ['clangd', '-clang-tidy']
let g:LanguageClient_serverCommands.cuda = ['clangd', '-clang-tidy']
let g:LanguageClient_serverCommands.objc = ['clangd', '-clang-tidy']

" Bash language server
"  https://github.com/mads-hartmann/bash-language-server
" npm install -g bash-language-server
" due to issue https://github.com/tree-sitter/node-tree-sitter/issues/46
" you may need to tie bash with node@10
let g:LanguageClient_serverCommands.sh = ['bash-language-server', 'start']

" Python
" install: pip install 'python-language-server[all]' python-pylint
let g:LanguageClient_serverCommands.python = ['pyls']

" Rust
let g:LanguageClient_serverCommands.rust = ['~/.cargo/bin/rustup', 'run', 'stable', 'rls']

" JavaScript
" npm install -g javascript-typescript-langserver
"   Looks like javascript-typescript-langserver requires
"   `jsconfig.json` to work with javascript files.
let g:LanguageClient_serverCommands = extend(g:LanguageClient_serverCommands, {
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'typescript.tsx': ['javascript-typescript-stdio'],
    \ })

" Docker
" npm install -g dockerfile-language-server-nodejs
let g:LanguageClient_serverCommands.Dockerfile = ['docker-langserver', '--stdio']

" ERuby/Vim/Markdown
" go get github.com/mattn/efm-langserver/cmd/efm-langserver
" pip install vim-vint
" markdownlint
" npm install -g markdownlint-cli
let g:LanguageClient_serverCommands.eruby = ['efm-langserver']
let g:LanguageClient_serverCommands.vim = ['efm-langserver']
let g:LanguageClient_serverCommands.markdown = ['efm-langserver']

" Java
" pikaur -S jdtls
" brew tap nossralf/homebrew-jdt-language-server && brew install jdt-language-server
let s:jdtls_name = 'jdtls'
if os == "Darwin"
    let s:jdtls_name = 'jdt-ls'
endif
let g:LanguageClient_serverCommands.java = [s:jdtls_name, '-data', getcwd()]

" YAML
" npm install -g yaml-language-server
let g:LanguageClient_serverCommands.yaml = ['yaml-language-server', '--stdio']

augroup LanguageClient_config
    autocmd!
    autocmd User LanguageClientStarted call hurricane#yaml#SetSchema()
augroup END

let g:LanguageClient_serverCommands = {}
let g:LanguageClient_mappings = {}
let g:LanguageClient_autoStart = 1
" Uses an absolute configuration path for system-wide settings
let g:LanguageClient_settingsPath = '~/.config/nvim/settings.json'

" Uncomment to find bugs
let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'

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
let g:LanguageClient_serverCommands.cpp = ['clangd']
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
let g:LanguageClient_mappings = extend(g:LanguageClient_mappings, {
    \ 'javascript': { 'disableHover': 1, 'disableHighlight': 1 },
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
let g:LanguageClient_mappings.eruby = { 
    \ 'disableFormat': v:true,
    \ 'disableHover':  v:true,
    \ 'disableHighlight':  v:true,
    \ }
let g:LanguageClient_serverCommands.vim = ['efm-langserver']
let g:LanguageClient_mappings.vim = {
    \ 'disableFormat': v:true,
    \ 'disableHover':  v:true,
    \ 'disableHighlight':  v:true,
    \ }
let g:LanguageClient_serverCommands.markdown = ['efm-langserver']
let g:LanguageClient_mappings.markdown = {
    \ 'disableFormat': v:true,
    \ 'disableHover':  v:true,
    \ 'disableHighlight':  v:true,
    \ }

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

augroup LanguageClient_config_YAML
    autocmd!
    autocmd User LanguageClientStarted call hurricane#yamlLS#SetSchema("ansible")
augroup END

function IsMappingEnabled(param_name)
    let l:mappings = get(g:LanguageClient_mappings, &ft, {})
    let l:enabled = !get(l:mappings, 'disable' . a:param_name, v:false)
    "echom &ft . ": Mapping ". a:param_name . " is ". l:enabled
    return l:enabled
endfunction

" Automatic Hover
" slightly adapted from https://github.com/autozimu/LanguageClient-neovim/issues/618
function! LspMaybeHover(is_running) abort
  if a:is_running.result && exists("b:LanguageClient_autoHover")
    call LanguageClient_textDocument_hover()
  endif
endfunction

function! LspMaybeHighlight(is_running) abort
  if a:is_running.result && exists("b:LanguageClient_autoHightlight")
    call LanguageClient#textDocument_documentHighlight()
  endif
endfunction

" Language Client keymaps
function SetLSPShortcuts()
  if has_key(g:LanguageClient_serverCommands, &ft)
    nnoremap <buffer> <silent> <leader>lh :call LanguageClient#textDocument_hover()<CR>
    inoremap <buffer> <silent> <c-k> <c-o>:call LanguageClient#textDocument_hover()<cr>

    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <silent> <leader>lr :call LanguageClient#textDocument_rename()<CR>

    if IsMappingEnabled('Format')
        setlocal formatexpr=LanguageClient_textDocument_rangeFormatting()
        vnoremap <buffer> = :call LanguageClient_textDocument_rangeFormatting()<CR>
    endif

    if IsMappingEnabled('Hover')
        let b:LanguageClient_autoHover = 1
    endif
    if IsMappingEnabled('Highlight')
        let b:LanguageClient_autoHightlight = 1
    endif
  endif
endfunction

augroup LanguageClient_config
    au!
    "autocmd BufNewFile,BufRead * call SetLSPShortcuts()
    autocmd BufEnter * call SetLSPShortcuts()
    autocmd CursorHold * call LanguageClient#isAlive(function('LspMaybeHover'))
    autocmd CursorMoved * call LanguageClient#isAlive(function('LspMaybeHighlight'))
augroup end

function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

" used to handle the response of #Call
function Log(result, error)
	echo a:result
endfunction

function RunCode()
    let codeString = s:get_visual_selection()

    " And the #Call here that does get properly sent to the language server
    call LanguageClient#Call("evaluate", { 'expression': s:get_visual_selection() }, function("Log"))
endfunction

" TODO:
" close floating window by Esc or q
" rangeFormat on clangd
" show colors for HTML in floating window
" https://github.com/prominic/groovy-language-server

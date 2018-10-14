
let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'cpp': ['ccls'],
    \ 'c': ['ccls'],
    \ }
let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '~/.config/nvim/settings.json'


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
            au CursorMoved * if b:Plugin_LanguageClient_started | sil call LanguageClient#textDocument_documentHighlight() | endif
        augroup END

    endif
endfunction

autocmd FileType * call LC_maps()

fu! C_init()
    setl formatexpr=LanguageClient#textDocument_rangeFormatting()
endf
au FileType c,cpp,cuda,objc :call C_init()


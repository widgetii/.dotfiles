
let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'cpp': ['ccls'],
    \ 'c': ['ccls'],
    \ }
let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '~/.config/nvim/settings.json'

" Borrowed from https://github.com/autozimu/LanguageClient-neovim/issues/618
function! LspMaybeHover(is_running) abort
    if a:is_running.result && g:LanguageClient_autoHoverAndHighlightStatus
        call LanguageClient_textDocument_hover()
    endif
endfunction

function! LspMaybeHighlight(is_running) abort
    if a:is_running.result && g:LanguageClient_autoHoverAndHighlightStatus
        call LanguageClient#textDocument_documentHighlight()
    endif
endfunction

augroup lsp_aucommands
    au!
    au CursorHold * call LanguageClient#isAlive(function('LspMaybeHover'))
    au CursorMoved * call LanguageClient#isAlive(function('LspMaybeHighlight'))
augroup END

let g:LanguageClient_autoHoverAndHighlightStatus = 0

function! ToggleLspAutoHoverAndHilight() abort
    if g:LanguageClient_autoHoverAndHighlightStatus
        let g:LanguageClient_autoHoverAndHighlightStatus = 0
        call LanguageClient#clearDocumentHighlight()
        echo ""
    else
        let g:LanguageClient_autoHoverAndHighlightStatus = 1
    end
endfunction

function! LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <silent> <leader>k :call LanguageClient#textDocument_hover()<CR>
        nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
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
        nnoremap <leader>rf :call LanguageClient#textDocument_references()<CR>
        " Find symbol in current file
        nnoremap <leader>ro :call LanguageClient#textDocument_documentSymbol()<CR>
        " Find symbol in all project
        nnoremap <leader>rw :call LanguageClient#workspace_symbol()<CR>
        " LanguageClient#workspace_applyEdit()
        " LanguageClient#workspace_executeCommand()

        nnoremap <silent> <leader>rh :call ToggleLspAutoHoverAndHilight()<CR>
		"call ToggleLspAutoHoverAndHilight()


    endif
endfunction

autocmd FileType * call LC_maps()


" vim:fileencoding=utf-8:ft=vim:foldmethod=marker:tw=80

" tabs&spaces {{{
" https://vim.fandom.com/wiki/remove_unwanted_spaces
nnoremap <silent> <f5> :let _s=@/ <bar> :%s/\s\+$//e <bar> :let @/=_s <bar> :nohl <bar> :unlet _s <cr>
" }}} tabs&spaces

" close all temporary windows
" https://github.com/rhysd/dogfiles/blob/master/vimrc#L298

" CLIPBOARD {{{
" copy current path
" Put full path on the default register
nmap cp :let @+ = expand("%:p")<cr>
" }}}

" FILES {{{
" Open file even if it is not exists
" https://stackoverflow.com/questions/6158294/create-and-open-for-editing-nonexistent-file-under-the-cursor
function! s:OpenOrCreateFile()
    let l:file = expand('<cfile>')
    if !filereadable(l:file)
        echo "File " . l:file . " doesn't exists. Create? (y/n)"
        let l:answer = nr2char(getchar())
        echon "\r\r"
        if l:answer !=? 'y'
            return
        endif
    endif
    execute 'e ' . l:file
endfunction
nmap <leader>gf :call <SID>OpenOrCreateFile()<CR>
" }}}

" TEXT EDITING {{{
" MacDict support
autocmd vimrc FileType gitcommit,markdown nnoremap <buffer>N :<C-u>call system('open ' . shellescape('dict://' . expand('<cword>')))<CR>
" }}} TEXT EDITING

" vim-c++ {{{
function! s:DetectCCIncludes()
    " TODO: skip if we have compile_commands.json or compile_flags.txt
    if !exists('g:cc_def_includes')
        let s:cc_cmd="cc -E -x c++ - -v < /dev/null 2>&1 |
                    \ awk 'BEGIN { printf \".\" } /End of search list./ { show=0 }
                    \ { if (show) printf \",%s\",$1 };
                    \ /#include <...> search starts here:/ { show=1; }'"
        let g:cc_def_includes=system(s:cc_cmd)
    endif
    let &l:path = &l:path . g:cc_def_includes
endfunction

autocmd vimrc FileType cpp call s:DetectCCIncludes()
autocmd vimrc FileType cpp setlocal cinoptions+=L0 " disable automatic label dedent

function! s:EditAlternate()
    let l:alter = CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': 'file://'.expand("%:p")})
    " remove file:/// from response
    let l:alter = substitute(l:alter, "file://", "", "")
    echo l:alter
    execute 'edit ' . l:alter
endfunction
autocmd vimrc FileType cpp nmap <leader>z :call <SID>EditAlternate()<CR>
" TODO:
" autocreate .clang-tidy file for new project using "clang-tidy --dump-config"
" }}}

" COLEMAK {{{
" TARMAK1

" Cursor keys
" Disabled for vim-gothrough-jk plugin
if !exists('g:loaded_gothrough_jk')
    noremap n j
    noremap e k
endif
noremap gn gj|noremap <C-w>n <C-w>j|noremap <C-w><C-n> <C-w>j|noremap о j
noremap <C-w>e <C-w>k|noremap <C-w><C-e> <C-w>k|noremap л k
" next/prev search keys
noremap k n
noremap K N
" to end of word/WORD
noremap j e
noremap J E
" noremap ge gk|

" TARMAK5
" insert mode
noremap s i|noremap в i
" Cursor keys
noremap i l|noremap д l

" BOL/EOL/Join Lines.
" more conv begin and end of string l/L
noremap l ^|noremap L $
" join lines
noremap <C-l> J
" r replaces i as the "inneR" modifier [e.g. "diw" becomes "drw"].
onoremap r i
" E is free!

" problem in NERD Tree
" e key don't go up
let g:NERDTreeMapOpenExpl = ''

" disable mappings for internal man plugin
let g:no_man_maps = 1
let g:ft_man_folding_enable = 1
nnoremap <silent> <buffer> N :Man<CR>
vnoremap <silent> <buffer> N :Man<CR>
" }}}

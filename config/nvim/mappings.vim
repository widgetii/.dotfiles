" https://vim.fandom.com/wiki/Remove_unwanted_spaces
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" close all temporary windows
" https://github.com/rhysd/dogfiles/blob/master/vimrc#L298

" copy current path
" Put full path on the default register
nmap cp :let @+ = expand("%:p")<cr>

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

" MacDict support
autocmd FileType gitcommit,markdown nnoremap <buffer>N :<C-u>call system('open ' . shellescape('dict://' . expand('<cword>')))<CR>

" vim-c++
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

autocmd FileType cpp call s:DetectCCIncludes()

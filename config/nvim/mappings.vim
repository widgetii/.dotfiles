" https://vim.fandom.com/wiki/Remove_unwanted_spaces
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" close all temporary windows
" https://github.com/rhysd/dogfiles/blob/master/vimrc#L298

" copy current path
" https://github.com/rhysd/dogfiles/blob/master/vimrc#L326

" MacDict support
autocmd FileType gitcommit,markdown nnoremap <buffer>N :<C-u>call system('open ' . shellescape('dict://' . expand('<cword>')))<CR>

" vim-c++
let s:cc_cmd="cc -E -x c++ - -v < /dev/null 2>&1 |
    \ awk 'BEGIN { printf \".\" } /End of search list./ { show=0 }
    \ { if (show) printf \",%s\",$1 };
    \ /#include <...> search starts here:/ { show=1; }'"
let g:cc_def_includes=system(s:cc_cmd)
autocmd FileType cpp let &l:path = &l:path . g:cc_def_includes

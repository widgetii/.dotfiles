" https://dmerej.info/blog/post/vim-cwd-and-neovim/
" no matter how I enter a new tab, my working directory is automatically set to the correct location, and when I switch tabs I switch working directories too
function! OnTabEnter(path)
  if isdirectory(a:path)
    let dirname = a:path
  else
    let dirname = fnamemodify(a:path, ":h")
  endif
  execute "tcd ". dirname
endfunction()

autocmd TabNewEntered * call OnTabEnter(expand("<amatch>"))


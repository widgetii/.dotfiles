"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                        Yaml-Language-Server Helpers                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! hurricane#yamlLS#SetSchema(schema)
        echom "Yaml-Language-Server using " . a:schema . " schema."
        let config = json_decode(system("cat ~/.config/nvim/yaml/" . a:schema . ".json"))
        call LanguageClient#Notify('workspace/didChangeConfiguration', { 'settings': config })
endfunction

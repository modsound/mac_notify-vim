" *********************************************************************
" PluginName: mac_nofity.vim
" Maintener: mittan(E-mail => modsound@gmail.com, Twitter => @modsound)
" License: MIT
" *********************************************************************

" not reload
if exists("g:loaded_mac_notify")
  finish
endif
let g:loaded_mac_notify = 1

" who says?
if !exists('g:mac_who_notify')
  let g:mac_who_notify = "Vim"
endif

let s:save_cpo = &cpo
set cpo&vim

" main function
function! s:mac_notify(say)
  call vimproc#system("echo 'display notification "."\"".a:say."\" with title \"".g:mac_who_notify."\"' | osascript")
endfunction
command! -nargs=1 MacNotify call s:mac_notify(<q-args>)

let&cpo = s:save_cpo

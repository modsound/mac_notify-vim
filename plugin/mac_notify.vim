" *********************************************************************
" PluginName: mac_nofity.vim
" Maintener: mittan(E-mail => modsound@gmail.com, Twitter => @modsound)
" License: MIT
" *********************************************************************

" load only once
if exists("g:loaded_mac_notify")
  finish
endif
let g:loaded_mac_notify = 1

" user environment confirmation
if !has("mac") || !executable("osascript")
  echom "mac_nofity.vim is only for Mac OSX User"
  finish
endif

" message title
let s:mac_notify_title = exists('g:mac_notify_title') ? g:mac_notify_title : 'Vim'

let s:save_cpo = &cpo
set cpo&vim

" main function
function! s:mac_notify(say)
  call vimproc#system("echo 'display notification "."\"".a:say."\" with title \"".s:mac_notify_title."\"' | osascript")
  " coordination with shaberu.vim
  if exists("g:loaded_shaberu") && exists("g:mac_notify_speech_via_shaberu")
      call shaberu#say(a:say)
  endif
endfunction
command! -nargs=1 MacNotify call s:mac_notify(<q-args>)
command! -nargs=1 MacNotifyExpand call s:mac_notify(<args>)

let&cpo = s:save_cpo

" *********************************************************************
" PluginName: mac_nofity.vim
" Maintener: mittan(E-mail => modsound@gmail.com, Twitter => @modsound)
" License: MIT
" *********************************************************************

" load only once {{{
if exists("g:loaded_mac_notify")
  finish
endif
let g:loaded_mac_notify = 1
" }}}

" check user environment {{{
if !has("mac") || !executable("osascript")
  let g:notloaded_mac_notify = 1
endif
" }}}

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 MacNotify call mac_notify#mac_notify(<q-args>)
command! -nargs=1 MacNotifyExpand call mac_notify#mac_notify(<args>)

" mac_nofity_timer {{{
if exists("g:mac_notify_timer")
  call mac_notify#init_mac_notify_timer()
  " execute automatically
  augroup holding_time_event
    autocmd!
    " [todo] カーソル動かさないと関数が起動しない
    autocmd CursorHold,CursorHoldI * call mac_notify#holding_time_event()
    autocmd CursorMoved,CursorMovedI * call mac_notify#moving_time_event()
  augroup END
endif
" }}}

let&cpo = s:save_cpo

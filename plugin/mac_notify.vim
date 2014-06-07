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
  echom "mac_nofity.vim is only for Mac OSX User"
  finish
endif
" }}}

let s:save_cpo = &cpo
set cpo&vim

" mac_notify {{{
function! s:mac_notify(say)
  " set message title
  let l:mac_notify_title = exists('g:mac_notify_title') ? g:mac_notify_title : "[Vim] ".expand("%")
  call vimproc#system("echo 'display notification "."\"".a:say."\" with title \"".l:mac_notify_title."\"' | osascript")
  " coordination with shaberu.vim
  if exists("g:loaded_shaberu") && exists("g:mac_notify_speak_with_shaberu")
      call shaberu#say(a:say)
  endif
endfunction

command! -nargs=1 MacNotify call s:mac_notify(<q-args>)
command! -nargs=1 MacNotifyExpand call s:mac_notify(<args>)
" }}}

" mac_nofity_timer {{{
  " set timer pattern {{{
  function! s:init_mac_notify_timer()
    " initialize var
    let s:downtime = 0
    if g:mac_notify_timer == 3
      let &updatetime = 180000
    elseif g:mac_notify_timer == 5
      let &updatetime = 300000
    elseif g:mac_notify_timer == 10
      let &updatetime = 600000
    else
      let g:mac_notify_timer = 1
      let &updatetime = 60000
    endif
  endfunction
  " }}}
  
  " do notification {{{
  function! s:holding_time_event()
    " count up
    let s:downtime += g:mac_notify_timer
    " set timer limit
    if exists('g:mac_notify_timer_limit')
      if s:downtime >= g:mac_notify_timer_limit
        " [todo] 英文メッセージも提供したい
        let l:say = "進捗どうです？"
      else
        let l:say = "動作停止から".s:downtime."分経過しました。"
      endif
    else
        let l:say = "動作停止から".s:downtime."分経過しました。"
    endif
    exec "MacNotifyExpand l:say"
    " event repeat
    call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>", 'n')
  endfunction
  " }}}
  
  " reset count up {{{
  function! s:moving_time_event()
    let s:downtime = 0
  endfunction
  " }}}
  
  " mac_nofity_timer {{{
  if exists("g:mac_notify_timer")
    call s:init_mac_notify_timer()
    " execute automatically
    augroup holding_time_event
      autocmd!
      autocmd CursorHold,CursorHoldI * call s:holding_time_event()
      autocmd CursorMoved,CursorMovedI * call s:moving_time_event()
    augroup END
  endif
  " }}}
  " }}}
let&cpo = s:save_cpo

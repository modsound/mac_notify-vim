" *********************************************************************
" PluginName: mac_nofity.vim
" Maintener: mittan(E-mail => modsound@gmail.com, Twitter => @modsound)
" License: MIT
" *********************************************************************

let s:save_cpo = &cpo
set cpo&vim

" mac_notify {{{
function! mac_notify#mac_notify(say)
  " set message title
  let l:mac_notify_title = exists('g:mac_notify_title') ? g:mac_notify_title : "[Vim] ".expand("%")
  " if not mac or executable osascript
  if exists("g:notloaded_mac_notify")
    echo l:mac_notify_title . ": " . a:say
  else
    call vimproc#system("echo 'display notification "."\"".a:say."\" with title \"".l:mac_notify_title."\"' | osascript")
  endif
  " coordination with shaberu.vim
  if exists("g:loaded_shaberu") && exists("g:mac_notify_speak_with_shaberu")
      call shaberu#say(a:say)
  endif
endfunction

" }}}

" mac_nofity_timer {{{
  " set timer pattern {{{
  function! mac_notify#init_mac_notify_timer()
    " initialize var
    let s:mac_notify_downtime = 0
    if g:mac_notify_timer == 3
      let &updatetime = (60000 * 3)
    elseif g:mac_notify_timer == 5
      let &updatetime = (60000 * 5)
    elseif g:mac_notify_timer == 10
      let &updatetime = (60000 * 10)
    else
      let g:mac_notify_timer = 1
      let &updatetime = 60000
    endif
  endfunction
  " }}}
  
  " do notification {{{
  function! mac_notify#holding_time_event()
    " count up
    let s:mac_notify_downtime += g:mac_notify_timer
    " set timer limit
    if exists('g:mac_notify_timer_limit')
      if s:mac_notify_downtime >= g:mac_notify_timer_limit
        " [todo] downtimeもユーザーがメッセージで指定できるように
        let l:say = exists("g:mac_notify_limit_message") ? g:mac_notify_limit_message : "進捗どうです？"
      else
        let l:say = exists("g:mac_notify_message") ? g:mac_notify_message : "動作停止から".s:mac_notify_downtime."分経過しました。"
      endif
    else
        let l:say = exists("g:mac_notify_message") ? g:mac_notify_message : "動作停止から".g:mac_notify_downtime."分経過しました。"
    endif
    exec "MacNotifyExpand l:say"
    " event repeat
    call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>", 'n')
  endfunction
  " }}}
  
  " reset count up {{{
  function! mac_notify#moving_time_event()
    let s:mac_notify_downtime = 0
  endfunction
  " }}}
  
" }}}
let&cpo = s:save_cpo

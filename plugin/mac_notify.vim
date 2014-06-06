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

" set message title
let s:mac_notify_title = exists('g:mac_notify_title') ? g:mac_notify_title : 'Vim'

let s:save_cpo = &cpo
set cpo&vim

" mac_notify {{{
function! s:mac_notify(say)
  call vimproc#system("echo 'display notification "."\"".a:say."\" with title \"".s:mac_notify_title."\"' | osascript")
  " coordination with shaberu.vim
  if exists("g:loaded_shaberu") && exists("g:mac_notify_speak_with_shaberu")
      call shaberu#say(a:say)
  endif
endfunction
command! -nargs=1 MacNotify call s:mac_notify(<q-args>)
command! -nargs=1 MacNotifyExpand call s:mac_notify(<args>)
" }}}

" 動作停止よりx分経過しました {{{
if exists("g:enable_mac_notify_timer")
  let s:downtime = 0
  let &updatetime = 60000

  " count up timer
  function! s:holding_time_event()
    let s:downtime += 1
    "[todo] 英語環境では英語のテキストを表示
    "[todo] 「進捗どうです？」を指定できるようにする
    let l:say = "動作停止より".s:downtime ."分経過しました。"
    exec "MacNotifyExpand l:say"
    " event repeat
    call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>", 'n')
  endfunction
  "[todo] コマンド定義しないとエラーが出るのはなぜ
  command! NotifyHoldingTime call s:holding_time_event()

  " count up reset
  function! s:moving_time_event()
    let s:downtime = 0
  endfunction
  "[todo] コマンド定義しないとエラーが出るのはなぜ
  command! ClearHoldingTime call s:moving_time_event()

  " execute automatically
  augroup holding_time_event
    autocmd!
    autocmd! CursorMoved,CursorMovedI * ClearHoldingTime
    autocmd CursorHold,CursorHoldI * NotifyHoldingTime
  augroup END
endif
" }}}

let&cpo = s:save_cpo

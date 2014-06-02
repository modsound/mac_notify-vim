MacNotify.vim
==============

This plugin provides command 'MacNotify': enables to use Notification Center from Vim.

## Requirement

* OS: Mac OSX 10.9 over(Tested with Mavericks)
* VimPlugin: [vimproc](https://github.com/Shougo/vimproc.vim)

## Install

```
NeoBundle 'modsound/mac_notify-vim'
```

## Provided Command

```
MacNotify [TEXT]
MacNotifyExpand [VARIABLE]
```
one argument required.  

## Configuration

You can change Notification title by a global variable below.

```
let g:mac_notify_title = "Attention!"
```

If you have installed shaberu.vim, You can coordinate with it.

```
let g:mac_notify_speak_with_shaberu = 1
```

## an Example of Utilization

Let's write and exucute this function. You will get a weather forecast for Tokyo.

```
function! s:weather_report()
  let l:weather = system("curl --silent http://weather.livedoor.com/forecast/rss/area/130010.xml
  \ | grep '<description>'
  \ | sed -e 's/<description>//g'
  \ | sed -e 's@</description>@@g' | head -n 3 | tail -n 1")
  exec "MacNotifyExpand l:weather"
endfunction
command! WeatherReport call s:weather_report()
```

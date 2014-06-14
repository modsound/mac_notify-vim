MacNotify.vim
==============

This plugin provides command 'MacNotify': enables to use Notification Center from Vim.

## Requirement

* OS: Mac OSX 10.9 over(Tested with Mavericks)

## Installation

```
NeoBundle 'modsound/mac_notify-vim'
```

## Provided Command

```
MacNotify [TEXT]
MacNotifyExpand [VARIABLE]
```
one argument required.  

### Configuration

* You can change Notification title by a global variable below.

```
let g:mac_notify_title = "Attention!"
```

* If you have installed shaberu.vim, You can coordinate with it.

```
let g:mac_notify_speak_with_shaberu = 1
```

### an Example of Utilization

Let's write and exucute this function in your vimrc. You will get a weather forecast for Tokyo.

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

## Timer Notification

Attention! This function uses &updatetime. 

You can get the notification when the specified time has passed.   
Let's add the following variables to your vimrc.

```
let g:mac_notify_timer = 1  
let g:mac_notify_timer_limit = 30
```

* "g:mac_notify_timer": enables Timer Notification.  
Set 1 or 3 or 5 or 10(minutes). Otherwise default value is 1.  
The above setting means that one minute after you stop operating Vim, You will be notified.

* "g:mac_notify_timer_limit": If elapsed time since you stopped operating Vim exceeded this value, Notification message will change.

You can change message by following variables.

```
g:mac_notify_message  
g:mac_notify_limit_message
```

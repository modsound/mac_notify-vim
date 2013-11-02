Mac Notify.vim
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

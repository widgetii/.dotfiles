# My dotfiles

This is my attempt for make shared repo between Mac and Linux (Archlinux) workstations. After several years I've found wonderful
tool [rcm](https://github.com/thoughtbot/rcm) to manage my configuration files.

## Window manager

I just use standard GUI on Mac and i3wm on Linux machine. I would like to try in the future [bspwm](https://github.com/baskerville/bspwm) and
[chunkwm](https://koekeishiya.github.io/chunkwm/)

## Terminal emulator

My choice is [kitty](https://sw.kovidgoyal.net/kitty/). It uses GPU to render
terminal text (I'm not kidding, it's a XXI century) and has many good
improvements such a OCS-52 support (I can copy data from remote host to local
clipboard as usually do), underlines (good for spell-checking and error
highlighting using with Language Servers).

Moreover is has common look-and-feel for both Mac OS and Linux (sorry MS fans).

## Fonts


Fonts kit for Archlinux:
```sh
pacman -S ttf-croscore ttf-dejavu ttf-ubuntu-font-family ttf-inconsolata
ttf-liberation --noconfirm
```

### Consider to try

[Agave](https://github.com/agarick/agave)

[Fira Code](https://github.com/tonsky/FiraCode)

[IBM Plex](https://github.com/IBM/plex/releases/latest)

[Input](https://input.fontbureau.com)

[Operator Mono](https://github.com/kiliman/operator-mono-lig)

[Victor Mono](https://rubjo.github.io/victor-mono/)

## Keyboard settings

As I use both Mac and Linux I tried to use same keyboard in both cases. So I've
bought [MLA22LL/A](https://www.amazon.com/gp/product/B01NABDNPH/) and my muscle
memory is happy.

## Editor

[NeoVim](https://neovim.io/)

Using [vim-plug](https://github.com/junegunn/vim-plug) as plugin manager.

### Test Language Servers

* `JavaScript` - Completion of built-in JavaScript and TypeScript methods like `Math.sin` and custom methods from the current project.

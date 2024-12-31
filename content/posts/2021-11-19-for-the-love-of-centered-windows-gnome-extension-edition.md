---
title: For the love of centered windows gnome extension edition
author: chmouel
date: 2021-11-19T11:41:54+00:00
url: /2021/11/19/for-the-love-of-centered-windows-gnome-extension-edition/
---
Feels weird or great or stupid or pretty smart or whatever to be wrong. Just
when I wrote that previous blog post :
<https://blog.chmouel.com/2021/11/14/for-the-love-of-centered-windows/> that I
realize that shell script doesn't work great on wayland.

I didn't really understood how Wayland works and just assumed that my tiny scripts just works. But experiencing not working on a native Wayland application and understanding how wayland works: <https://wayland.freedesktop.org/docs/html/ch05.html> it obviously needed a better way to do that if I have to keep up with the modern world of a linux desktop.

So I spent a few hours to trying to understand how to make a gnome shell extension to replicate this. Since with the wayland architecture I don't think there is other way around to replicate this feature.

I got inspired by the [tactile](https://gitlab.com/lundal/tactile). And when I
say inspired I pretty much copied a lot of code from there (my javascript and
gtk dev skills are near to zero so I truly needed help).

The results is a nice extension that does exactly the same thing as my script and work exactly as wanted.

I even got a nice gif to show for it :
![one third windows gif][1]

If you are interested it feel free to grab it from the gnome extensions website :
<https://extensions.gnome.org/extension/4615/one-third-window/>

Just start pressing the Super (or windows) + C keys to center the current window or Super/Win+Shift C to rotate the window around.

 [1]: https://raw.githubusercontent.com/chmouel/one-third-window-gnome-extension/main/examples/one-third-window.gif

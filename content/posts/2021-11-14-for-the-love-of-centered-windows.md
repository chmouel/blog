---
title: For the love of centered windows
author: chmouel
date: 2021-11-14T06:36:06+00:00
url: /2021/11/14/for-the-love-of-centered-windows/

---
Sometime over a 2020 confinement my work decided to give us some money to buy some work from home office items.

I didn't need much at that time since I was already settled with everything I needed in a work from home office but decided to go for a fancy new screen since well why not and the other one (a standard 24" display) could find some good use for my teenage gamer son.

The [chosen screen][1] is a Samsung Ultra Wide display with a beautiful model name called S34J550WQU.

At first I was thrilled, the display looks nice and it seems I have much more estate for more to look at than before.

But in practice it's not like this, this screen is too wide because, if I start having to d some work on the windows located on the right and on the left, I actually need to look at those windows by turning my neck or to actually move my head left to right. After a while it became quite irritating and gave me serious neckache and stiffness.

After experimenting for a short while, I decided that centered window was the way to go, so I was painfully resizing windows and moved them around manually as needed. There was other tools I have found trying to automate those taskss but they never helped much.

Fast forward 3 months later, I was happily switched back onto Linux with the promises of those titling windows manager where windows gets titled and rearranged exactly the way I would wanted it.

But I never got into titling windows manager and never understood it really. Before that ultra wide screen display, I was mostly a one large window person with fast Alt-<Tab> fingers. I would have my Emacs (or browser/terminal) in full screen which was just right to look at without moving my head since the screen was smaller where I can focus on the task at hand, without having five of them at the same time.

In titling windows manager you can customize it a lot but no matter what layout I tried I never could get it right.

I gave up trying to adjust my workflow with i3/monad since part it is because I am definitively comfortable with desktop Gnome and I actually quite enjoying its simplicity

I kinda for a while was thinking to sell that ultra wide monitor and get a smaller screen but like a lot of things life I was able to adjust my workflow with a set of keybinding and a shell script.

I got inspired by this [unix.stackexchange answer][2] and with the help of [xwininfo][3] and [wmctrl][4]. [my script][5] would identify the current window and rotate them one them on the left of the scrren or the right, or my preferred placement for working on center.

So essentially when I have my editor (Emacs) a browser and a terminal, I can move the windows around and center the one I want and move the non active one easily on the sides.

I realize now I kinda replicated a (extremely simplified) titling windows manager with the only feature I want . The advantage of my method is that I can have it exactly the way I want. The thing is that I don't want a perfect 1/3 of the screen window, the window in the center is a few pixel more in the center and cover over the side windows and that makes it trivial in a screen, compared to try to figure it out how to do that in i3.

Another win for perfect aligned windows desktop.

(I am quite new to wayland but to my surprise the script still work on wayland too).

 [1]: https://www.amazon.fr/dp/B07J4CZYND/ref=pe_3044141_185740131_TE_item
 [2]: https://unix.stackexchange.com/a/53228
 [3]: https://linux.die.net/man/1/xwininfo
 [4]: https://en.wikipedia.org/wiki/Wmctrl
 [5]: https://gitlab.com/chmouel/chmouzies/blob/master/misc/wmctrl-resize-and-center.sh

---
title: "Selecting files in ZSH With fzf and exa"
date: 2023-01-11T15:41:47+01:00
---

Sometime the tiniest optimization makes a huge difference. When I am not using
Emacs and dired I usually just use the shell with zsh to do all my file
management.

This is fine and great but sometime when I need to select multiple
files with different names, I would have to do a lot of tabs and selection or
copy and paste to select properly the list of files I want to do operations on.

I could use a terminal file manager like `ranger` or `nnn` but I never got into
getting used to use them and even if I have it installed and configured I always
forget to launch them.

There is a fantastic plug-in for zsh called
[zsh-fzf-history-search](https://github.com/joshskidmore/zsh-fzf-history-search)
it let you plug fzf onto any zsh selection.

I don't need as much fzf in my shell but I want only sometime for selecting some
not so easy to get files.

I made the `fzf-select-file` plug-in for that :

<https://github.com/chmouel/fzf-select-file>

You just hit the keys `C-x C-f` (ie: `control-x` followed by `control-f`) and it
will spin up a fzf windows with the list of files provided by
[exa](https://the.exa.website/) sorted by file modification time. A nice
preview window of it file will be showed as well on the right with `bat`.

It automatically quote the files with space into it show it on your command line.

Feel free to go on the github project to see how you can install it!
{{< video src="https://user-images.githubusercontent.com/98980/212008664-d87d18c1-71c9-403f-9282-685002a54797.mp4" type="video/webm" preload="auto" width="800" height="600" >}}

---
title: "Selecting files in ZSH With fzf and exa"
date: 2023-01-11T15:41:47+01:00
draft: true
---

Sometime the tiniest optimization makes a huge difference. Except when using
Emacs and dired I usually use the shell with zsh to do all my file
management.

Which is fine and great but sometime if I need to select multiles
files with different names, I need to do a lot of tabs and selection or copy and
paste to select properly the files.

I could use a terminal file manager like `ranger` or `nnn` but I never got into
it and even if I have it installed and configured I can't get myself to use
them.

There is a fantastic plug-in for zsh called
[zsh-fzf-history-search](https://github.com/joshskidmore/zsh-fzf-history-search)
which allow to get any zsh selection with fzf where you can do fuzzy finding on
the filename easily.

I don't need as much fzf in my shell but I want it sometime for selecting some
not so easy to get files.

I made the `fzf-select` plug-in for that :

<https://github.com/chmouel/fzf-select>

You just hit the keys `C-x C-f` (ie: `control-x` followed by `control-f`) and it
will spin up a fzf windows with the list of files provided by
[exa](https://the.exa.website/) sorted by file modification time.

It automatically quote the files with space into it show it on your command line.

Feel free to go on the github project to see how you can install it!

{{< video src="https://user-images.githubusercontent.com/98980/211789984-5343295e-6680-4ea6-ba4a-21c65eb63d62.mp4" type="video/webm" preload="auto" width="800" height="600" >}}

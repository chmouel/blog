---
title: "vtplug a very dumb and tiny zsh plugin manager"
author: chmouel
date: 2022-03-18T11:06:19+00:00
url: /2022/03/18/vtplug-a-very-dumb-and-tiny-zsh-plugin-manager/
---
There is a lot of zsh plugin manager around :

<https://github.com/unixorn/awesome-zsh-plugins#frameworks>

They all allow you to add cool new features to your shell easily and for authors to
easily share their plugin with users and frameworks.

While a lot of people are probably using frameworks like `oh-my-zsh` which does
everything for them with minimal setup.

But since I have been using zsh since [much before][1] than those frameworks
existed, I always ran my custom config.

Historically, I went for the "default" one (or it seemed that way at the time) called `zplug`. It allows you to specify the plugins you want and manage them easily. But `zplug` is a lot more things, it offers many more features
like installing binary from the internet manage some configuration edge cases
and other things. And it slowwws, I didn't realize it at first but more I used
it and more I realized that opening a shell would take me a second or two
sometime. Moreover, last release was 5 years ago.

I looked a bit more into it and figured it was actually pretty simple to dumb
it down and write my own. So I wrote one and called it `"vtplug"` for "very tiny
plugin manager" and since it's so small it can be installed directly by copying
it in your config as function from here :

<https://github.com/chmouel/zsh-config/blob/master/functions/vtplug#L15>

to use it you first need to copy the function in your config and then have a
variable that has all the plugins you want to install, which for me is :

```shell
ZSH_PLUGINS=(
    agkozak/zsh-z
    zsh-users/zsh-autosuggestions
    chmouel/chmoujump
    chmouel/kubectl-config-switcher
    b4b4r07/emoji-cli::emoji-cli.zsh
    joshskidmore/zsh-fzf-history-search
)
```

It currently only support public GitHub based plugins so effectively add the
`https://github.com/` to the repo/owner specified in ZSHZ_PLUGINS variable.

You then may want to add some configuration of the plugin right after, like this,
I have those by you may want to have a look at each plugin READMEs to see which
settings you may want to set :

```shell
ZSH_TAB_TITLE_ONLY_FOLDER=true
ZSH_TAB_TITLE_DEFAULT_DISABLE_PREFIX=true
ZSHZ_DATA=${HOME}/.cache/zsh-cache-z
EMOJI_CLI_USE_EMOJI=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#9400d3"
ZSH_FZF_HISTORY_SEARCH_BIND="^S"
EMOJI_CLI_KEYBIND="^X^S"</code></pre>
```

and then simply execute vtplug after that :

```shell
-$ vtplug
```

`vtplug` would then load all plugins and check them out in `~/.cache/zsh/repos/`
if it wasn't checked out before.

If you need to update the plugin you just do a :

```shell
vtplug -u
```

and it will run a `git pull` in those repos.

It's simple as that, and load in milliseconds.

My whole zsh config is located here if you want to have a look:

<https://github.com/chmouel/zsh-config>

If you really want a plugin manger that does much more and probably more
flexible, perhaps look at [`antidote`][2] which seems to be pretty fast and
feature full.

 [1]: https://zsh.sourceforge.io/Etc/changelog-4.0.html
 [2]: https://getantidote.github.io/

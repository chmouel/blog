---
title: "shell completions with go cobra library"
date: 2022-11-22T09:00:56+02:00
---

Every time I press the `[TAB]` key in my shell, it bothers me that nothing happens.

I'm not very smart, so I often press the `[TAB]` key multiple times, hoping that
maybe the seventh time will magically produce the completion that I expect.

However, magic is not a computer function, and if a user or command line
interface (CLI) author has not provided a completion function, nothing will ever
happen.

This used to be a manual task, Users has contributed a huge collection of
completion functions for multiple binaries. Here is some completions for
[ZSH](https://github.com/zsh-users/zsh-completions) (zsh has a large number of
builtins completion too) and here is some for
[Bash](https://github.com/scop/bash-completion/blob/master/README.md).

All these functions are a good way to get nice completions for most popular Unix
binaries.

Providing shell completion when you are not an expert in shell scripting, can be
a frustrating and difficult process. For example, I
previously created [zsh completions](https://github.com/chmouel/oh-my-zsh-openshift) manually
for the openshift client, but it was a tedious and time-consuming task. Just the process of
having to keep it updated with the new flags and arguments could get very frustrating.

Advanced shell scripting can be difficult to learn, especially when you have to
work with multiple shell environments, such as bash, zsh, powershell, and
fish. This can greatly increase the complexity and difficulty of the task.

Thankfully, most modern CLI libraries now offer built-in shell completion
mechanisms, which make it easier for developers to provide completion
functionality for their programs.

For the purposes of this article, we will focus on the Go programming language
and one of its most popular libraries for command line interface (CLI) parsing,
[Cobra](https://github.com/spf13/cobra).

## Basics

you simply define a new command called `completion` and output the snippet used
for the specific shell directly from the binary like this (full example
[here](https://github.com/openshift-pipelines/pipelines-as-code/blob/8b5a2d3dbe6d00462a647abf4bfd95c38b058b5e/pkg/cmd/tknpac/completion/cmd.go#L1)):

```go
func Command() *cobra.Command {
 cmd := &cobra.Command{
  Use:       "completion [SHELL]",
  Short:     "Prints shell completion scripts",
  Long:      desc,
  ValidArgs: []string{"bash", "zsh", "fish", "powershell"},
  Example:   eg,
  Annotations: map[string]string{
   "commandType": "main",
  },
  Args: cobra.MatchAll(cobra.ExactArgs(1), cobra.OnlyValidArgs),
  RunE: func(cmd *cobra.Command, args []string) error {
   switch args[0] {
   case "bash":
    _ = cmd.Root().GenBashCompletion(cmd.OutOrStdout())
   case "zsh":
    _ = cmd.Root().GenZshCompletion(cmd.OutOrStdout())
   case "fish":
    _ = cmd.Root().GenFishCompletion(cmd.OutOrStdout(), true)
   case "powershell":
    _ = cmd.Root().GenPowerShellCompletion(cmd.OutOrStdout())
   }

   return nil
  },
 }
 return cmd
}
```

This will define a new command called `completion` with the first argument being
the target shell and the command will use the cobra library to output the
specific completion snippet for that shell.

## How it works

cobra completion is most of the time smart enough to analyze your commands and
output the right completion to it.

When for example your cobra command has :

```
ValidArgs: []string{"bash", "zsh", "fish", "powershell"},
```

It will suggest the args after the completion.

It will as well suggest all flags and subcommands to the right command.

This will get most of the time the job done for most user who are craving (like
myself) for completion.

And for the CLI author, this is easy and simple and no need to do any
maintenance, you can simply forget it.

The way it works when the user press `[TAB]` the completion functions as
generated for the target shell will ask the binary to complete the command with
the hidden command `__complete command` argument to the binary and the binary
itself will output then the completion using cobra library.

## Debugging

If you want to debug the completion on how it works you can set the variable
`BASH_COMP_DEBUG_FILE` to a filename and the completion function will output
(even on zsh) any query it does to that filename.

## Custom completion

Sometime you want to offer your own completion to a specific command.

To do so you need to define in your `Command` a `ValidArgsFunction` with this signature:

```go
ValidArgsFunction: func(cmd *cobra.Command, args []string, toComplete string) ([]string, cobra.ShellCompDirective) {
 outputs := []{"hello", "moto"}
 return outputs, cobra.ShellCompDirectiveNoFileComp
},
```

the `outputs` can be anything dynamics you want. `args` is the arguments the user provides for example :

`command argument he<TAB>`

you may want to be smart and provides completion on those arguments (I don't because it was too annoying)

`cobra.ShellCompDirective` return here is a `cobra.ShellCompDirectiveNoFileComp`
but there is other type to mix your argument with for file completions on
globing, but there is plenty of other ones, you can see all the definitions in the
cobra source [here](https://github.com/spf13/cobra/blob/main/completions.go#L54).

## Installation

The best way to tell user to install the completion isn't to say the much advised :

`source <(binary completion bash/zsh)`

because that command can get quite slow.

But instead to actually put it in the completion path, for example on bash
while using the
[`bash-completions`](https://github.com/scop/bash-completion/blob/master/README.md)
framework you tell the use to create the directory
`~/.local/share/bash-completion` and dump the completion there :

```console
${BINARY_NAME} completion bash > "${HOME}/.local/share/bash-completion/${BINARY_NAME}"
```

on ZSH you need to make the user load the completion mechanism in its `~/.zshrc` :

```shell
autoload -U compinit;
compinit
mkdir -p ~/.zsh_completions/
fpath+=(~/.zsh_completions/)
```

and dump the completion in that directory:

```console
${BINARY_NAME} completion zsh > "${HOME}/.zsh_completions/_${BINARY_NAME}"
```

There is many ways to do this differently to different path and for the
different shell, I'll encourage you to do some digging for your target shell and
shelll framework.

## Packaging

All theses steps can get pretty tedious, the easiest way to consumes your
project is to consumes packages. [goreleaser](https://goreleaser.com/) makes it
very easy.

Here is some snippet of the yaml to generate the completion with `cobra` from
the `aur` and `brews` recipe, I have as well a full and [live example
here](https://github.com/openshift-pipelines/pipelines-as-code/blob/main/.goreleaser.yml):

```yaml
brews:  # homebrew packages
 - name: ${BINARY_NAME}
   install: |
      (bash_completion/"${BINARY_NAME}").write output
      output = Utils.popen_read("SHELL=zsh #{bin}/${BINARY_NAME} completion zsh")
      (zsh_completion/"_${BINARY_NAME}").write output
      prefix.install_metafiles
aurs: # arch package
- name: ${BINARY_NAME}
[....]
  package: |-
    # completions
    mkdir -p "${pkgdir}/usr/share/bash-completion/completions/"
    mkdir -p "${pkgdir}/usr/share/zsh/site-functions/"

    ./${BINARY_NAME} completion zsh > ${BINARY_NAME}.zsh
    ./${BINARY_NAME} completion bash > ${BINARY_NAME}.bash

    install -Dm644 "${BINARY_NAME}.bash" "${pkgdir}/usr/share/bash-completion/completions/${BINARY_NAME}"
    install -Dm644 "${BINARY_NAME}.zsh" "${pkgdir}/usr/share/zsh/site-functions/_${BINARY_NAME}"
```

## Other libraries

I have successfully added completion to other CLIs using other library.

- with the [urfave/cli](https://github.com/urfave/cli) library on the [gosmee](https://github.com/chmouel/gosmee)
  binary. I have defined a completion command
  [here](https://github.com/chmouel/gosmee/blob/adaa13e318d0a5b81026ed5aaf0e7a983494bb9d/gosmee/app.go#L142)
  which output this [embedded static
  completion](https://github.com/chmouel/gosmee/blob/adaa13e318d0a5b81026ed5aaf0e7a983494bb9d/gosmee/app.go#L15-L19)
  and made sure to [enable
  it](https://github.com/chmouel/gosmee/blob/main/gosmee/app.go#L29) at the top
  level. Installation is about the same as how it works on Cobra.
- on Rust, using the ubiquitous [clap-rs]() I have [snazy](github.com/chmouel/snazy) using the [derive api](https://docs.rs/clap/latest/clap/_derive/index.html) , it define a `completion` [command](https://github.com/chmouel/snazy/blob/main/src/cli.rs#L35-L37) using the [clap_complete crate](https://docs.rs/clap_complete/latest/clap_complete/) and then use the [generator](https://github.com/chmouel/snazy/blob/0df6b95433eb5d5564ea9161677ed5325bb809db/src/cli.rs#LL162) to output the [snippet](https://github.com/chmouel/snazy/blob/0df6b95433eb5d5564ea9161677ed5325bb809db/src/cli.rs#L155-L157)

## Hack the completion by providing your own.

A nice hack I figured was to be able to provide extra completion to a binary using the cobra library.
For example I wanted to be able to get the pull request number and title when I press tab to the [gh](https://github.com/cli/cli/) binary.
The way I did this is to wrap the binary around with a shell script and output the completion I wanted.

The shell script on how I did that is available here:
https://github.com/chmouel/chmouzies/blob/main/git/gh-completer you simply need
to install it in your path as an executable called `gh` before in the PATH where
you real `gh` is located.
{{< video src="shellcompletions.mov" type="video/webm" preload="auto" width="800" height="600" >}}

---
title: Show plugins list to a CLI when using go’s cobra library
author: chmouel
date: 2022-03-18T08:53:02+00:00
url: /2022/03/18/show-plugins-list-to-a-cli-when-using-gos-cobra-library/
---
With the TektonCD CLI we have a system of "plugins", it's the same very simple CLI plugin system you have with git or kubectl, if you do a :

`kubectl blah foo --bar`

since kubectl knows it doesn't have the blah command will try to go over the
filesystem paths in your `$PATH` environment and sees if there is a binary
called `kubectl-blah` and if it finds it will pass the arguments to the binary
which effectively become :

`kubectl-blah foo --bar`

all very transparent and easy to install and use.

The problem with this is that the user doesn't really knows about it and discovery is limited unless the user knows about the command already.

kubectl added a [`plugin list`][1] argument to list easily all plugins available (or in kubectl case you can just use [krew][2] to manage kubectl plugins).

For [`tektoncd-cli`][3] we wanted to shows it directly in the `Root` commands help. So when the user type `tkn help` it will shows the plugin list.

Since `tektoncd-cli` is using the [`spf13/cobra`][4] library, and the lib being very extensible, it wasn't hard to extend the help system.

You first need to define a custom "usage template", the template we have is this one :

<https://github.com/chmouel/tektoncd-cli/blob/add-available-plugins-from-path/pkg/cmd/root.go#L46>

It adds this snippet to the default template :

```go
{{if gt (len pluginList) 0}}
Available Plugins:
{{- range pluginList}}
  {{.}}{{end}}{{end}}{{if .HasAvailableLocalFlags}}
```

The `pluginList` template variable is a slice of plugins which is discovered in this function :

```go
func addPluginsToHelp() {
	pluginlist := []string{}
	paths := strings.Split(os.Getenv("PATH"), ":")
	// go over all paths in the PATH environment
	// and add them to the completion command
	for _, path := range paths {
		// list all files in path
		files, err := ioutil.ReadDir(path)
		if err != nil {
			continue
		}
		// add all files that start with tkn-
		for _, file := range files {
			if strings.HasPrefix(file.Name(), "tkn-") {
				basep := strings.ReplaceAll(file.Name(), "tkn-", "")
				fpath := filepath.Join(path, file.Name())
				info, err := os.Stat(fpath)
				if err != nil {
					continue
				}
				if info.Mode()&0o111 != 0 {
					pluginlist = append(pluginlist, basep)
				}
			}
		}
	}
	cobra.AddTemplateFunc("pluginList", func() []string { return pluginlist })
}
```

what it does is, go over the environement variable PATH gets all directories from there, check all executable binaries that starts with the "tkn-" prefix and add it to the template variable pluginList inside a slice of strings.

The plugin command will show then nicely when doing `tkn help`. for example with the [`Pipelines as Code`][5] CLI installed, I will get this :

    $ tkn help
    CLI for tekton pipelines

    Usage:
    tkn [flags]
    tkn [command]

    Available Commands:
      bundle                    Manage Tekton Bundles
      chain                      Manage Chains
      clustertask              Manage ClusterTasks
      condition                Manage Conditions
      eventlistener          Manage EventListeners
      hub                        Interact with tekton hub
      pipeline                  Manage pipelines
      pipelinerun             Manage PipelineRuns
      resource                 Manage pipeline resources
      task                        Manage Tasks
      taskrun                   Manage TaskRuns
      triggerbinding         Manage TriggerBindings
      triggertemplate       Manage TriggerTemplates

    Other Commands:
      completion         Prints shell completion scripts
      version               Prints version information

    Available Plugins:
      pac

    Flags:
      -h, --help   help for tkn

    Use "tkn [command] --help" for more information about a command.

There is maybe area for improvement to be able to get a small snippet of what the plugin is actually doing in the future but so far having it in the root help is a great boost for CLI discoverability.

The full PR on tektoncd cli is here if you wanted to look at the full code and tests :

<https://github.com/tektoncd/cli/pull/1535>

 [1]: https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/#discovering-plugins
 [2]: https://krew.dev
 [3]: https://github.com/tektoncd/cli/
 [4]: https://github.com/spf13/cobra
 [5]: github.com/openshift-pipelines/pipelines-as-code/

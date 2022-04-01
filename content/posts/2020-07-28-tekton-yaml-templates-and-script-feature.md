---
title: Tekton yaml templates and script feature
author: chmouel
date: 2020-07-28T08:55:07+00:00
url: /2020/07/28/tekton-yaml-templates-and-script-feature/
categories:
  - Uncategorized
tags:
  - tekton
  - work

---
Don't you love "yaml", yes you do ! or at least that's what the industry told you to love!

When you were in school your teacher told you about "XML" and how it will solve all the industry problems (and there was many in the late 90s). But you learned that you hate reaching to your **"<"** and" **">"** keys and rather have something else. So then the industry came up with "json" so computer or yourself can talk to each others, that's nice for computers but actually not so nice for yourself it was actually a lie and was not made for yourself to read and write but only for comptures. So then the "industry" came up with **yaml**, indentation based? you get it and that's humm all about it, now you are stuck counting whitespaces in a 3000 lines file trying to figure out where goes where....

Anywoo ranting about computer history is not the purpose of this blog post, like every other cloud native (sigh) component out there tekton is using yaml to let the user describe its operative executions. There is a very nice feature in there (no sarcasm it is really nice!) allowing you to embed "scripts" directly in tasks. Instead of like before where you had to build a container image with your script and run it from tekton, you can now just specify the script embedded directly in your "Task" or "Pipeline".

All good, all good, that's very nice and dandy but when you start writing a script that goes over 5 lines you are getting into the territory where you have mixed a ~1000 lines script embedded in a 2000 lines of yaml (double sigh).

You can come back to the old way, and start to go over the development workflow of :

"write" -> commit -> "push" -> "build image" => "push" -> "update tag" -> "start task"

and realize that you are loosing approximately 40 years of your soul into some boring and repetitive tasks.

So now that i am over talking to myself with this way too long preamble here is the real piece of information in this post, a script that like everything in your life workaround the real issue.

It's available here :

<https://github.com/chmouel/chmouzies/blob/master/work/tekton-script-template.sh>

The idea is if you have in your template a tag saying #INSERT filename, it would be replaced by the content of the file, it's dumb and stupid but make devloping your yaml much more pleasing... so if you have something like :

```yaml
image: foo
script: |
  #INSERT script.py
```

the script with see this and insert the file script.py in your template. It will respect the previous line indentation and add four spaces extra to indent the script and you can have as many INSERT as you want in your template....

Now you can edit your code in script.py and your yaml template in the yaml template.. win win, separation of concerns, sanity win happy dance and emoji and all...

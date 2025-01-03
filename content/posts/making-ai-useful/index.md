---
title: "Making AI Useful to me with an AI spellchecker"
date: 2025-01-01T00:00:48+01:00
---

I haven’t fully jumped on the AI hype train, but I’ve kept an eye on the
evolving technologies of the past two decades. It used to be that Cloud was the
buzzword, then Containers, and maybe blockchain (never got into this one), and
now AI.

At first, AI felt like a nice gimmick—discussing things with a chatbot felt a
bit like doing a Google search but with a conversational twist. The problem with
chatbots was that funny feeling you’d get when it seemed like they were just
making things up.

But so much has changed since the first release of ChatGPT. Things have gotten
way, way better.

It’s nice to have Copilot occasionally enabled for my open-source work to learn
and get advanced code completions. It’s nice to have a chatbot that can answer
questions about my code. It’s even nice to have one that helps with my
writing. It is, indeed, useful.

But so far I wanted to go beyond that and play around with the AI APIs out there
and see if I could go a bit beyond these use cases.

GitHub offers a [playground](https://github.com/marketplace/models) with a
variety of APIs, making it easier to tinker with small ideas and use cases.

### A Couple of Personal Use Cases

One thing I wanted was a way to generate those easy, trivial commit messages for
my code. I started writing a tool for this until I discovered that the
[copilot-chat.el](https://github.com/chep/copilot-chat.el?tab=readme-ov-file#magit-commits)
mode integrates nicely with
[Magit](https://github.com/chep/copilot-chat.el?tab=readme-ov-file#magit-commits),
so I didn’t need to do much there except some
configuration<https://gitlab.com/chmouel/emacs-config/-/blob/main/lisp/init-copilot.el?ref_type=heads#L31>
for it.

Another thing that’s always annoyed me is writing French accents on my English
keyboard. On Linux, I need to use Right-ALT and do mental gymnastics to type
them. I have a custom keyboard with macros that make it easier, but I still
don’t like writing them—and to be honest, I’m not even sure where to properly
place them half the time. So, when I write to family or friends in French from
my computer, it always looks weird.

To address this, I built a little tool called
[aichmou](https://gitlab.com/chmouel/aichmou) to help. It plugs into Sway on
Linux and also works with Alfred on macOS.

### How It Works

Aichmou supports a bunch of models using the [GitHub model
marketplace](https://github.com/marketplace/models) free API for those with
access. It also works with Google Gemini and Groq, which have free APIs.

Here’s how I use it:

- I select my text, press a key combo (Super+X for me),
- Sway intercepts it with this configuration:

```config
bindsym $super+x exec copyq selection | $HOME/go/src/gitlab.com/chmouel/aichmou/.venv/bin/python3 $HOME/go/src/gitlab.com/chmouel/aichmou/ai -N spell && wtype -M ctrl -M shift v
```

- Launching [CopyQ](https://hluk.github.io/CopyQ/) to grab the current
  selection. (If you don’t use CopyQ as your clipboard manager, you can probably
  use something else.).
- The text is sent to Aichmou, which queries an available and non-rate-limited
  LLM for the correction to make.
- The result is copied back to the clipboard and typed into the frontmost
  application using [wtype](https://github.com/atx/wtype) tool.

### The Results

Here is a little demo of it in action:

{{< rawhtml >}}
<video width=100% controls autoplay>
    <source src="https://github.com/user-attachments/assets/fa848c99-776d-42d3-9d1e-9bc68a42341e">
    Your browser does not support the video tag.
</video>
{{< /rawhtml >}}

### Conclusion

It's simple and save me a lot of time, and I’m happy with it. And I can easily built
on this for some other use cases on that tool if needed in the future.

Here is the link to the tool:

- AIChmou - <https://gitlab.com/chmouel/aichmou>
- My Emacs and Copilot config - <https://gitlab.com/chmouel/emacs-config/-/blob/main/lisp/init-copilot.el?ref_type=heads#L31>
- My Emacs and LLM config - <https://gitlab.com/chmouel/emacs-config/-/blob/main/lisp/init-llm.el?ref_type=heads>

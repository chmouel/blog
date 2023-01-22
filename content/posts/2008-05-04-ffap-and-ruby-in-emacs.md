---
title: FFAP and Ruby in Emacs
author: chmouel
date: 2008-05-04T19:13:41+00:00
url: /2008/05/04/ffap-and-ruby-in-emacs/
dsq_thread_id:
  - 252039356
tags:
  - Emacs

---
If you want to use FFAP (find-file-at-point) in ruby-mode you can add this to your .emacs


```ruby
(defvar ruby-program-name "ruby")
(defun ruby-module-path(module)
    (shell-command-to-string
     (concat
      ruby-program-name " -e "
      "\"ret='()';$LOAD_PATH.each{|p| "
      "x=p+'/'+ARGV[0].gsub('.rb', '')+'.rb';"
      "ret=File.expand_path(x)"
      "if(File.exist?(x))};printf ret\" "
      module)))

(eval-after-load "ffap"
  '(push '(ruby-mode . ruby-module-path) ffap-alist))

```


When you do ffap (i bind it to C-x f) near a require 'PP' for example it will find it in your ruby path.
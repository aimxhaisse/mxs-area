---
title: How to paste code from emacs
categories: [en, snippet_en]
layout: default
---

First, you need to install [http-post-simple](http://www.emacswiki.org/emacs/http-post-simple.el), which provides some functions
to perform http requests:

{% highlight bash %}
$ cd /usr/local/share/emacs/site-lisp/
$ sudo wget http://www.emacswiki.org/emacs/download/http-post-simple.el
{% endhighlight %}

Then, add the following chunk of code to your .emacs file:

{% highlight cl %}
;; c0depast3r
(require 'http-post-simple)
(defun c0depast3r-paste ()
  "paste a chunk of code to pastebin.buffout.org"
  (interactive)
  (http-post-simple "http://pastebin.buffout.org/add"
                    (list (list 'author (getenv "USER"))
                          (list 'code
                           (buffer-substring
                             (region-beginning) (region-end))))))
{% endhighlight %}

It takes the selected region from the current buffer and post it to
[pastebin.buffout.org](http://pastebin.buffout.org/add). To use it,
just select a region (ctrl + space to define the starting point of
the region, then ctrl + space to end the selection), and run the
c0depast3r-paste function (meta-x c0depast3r-paste). You should be
able to see you code in the [latest entries](http://pastebin.buffout.org/latest).

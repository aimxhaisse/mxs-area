---
title: Using flymake with emacs
categories: [en, snippets]
layout: default
---
Emacs doesn't handle by default error detection
"on the fly" like some IDEs, fortunately, there's
a minor mode for that: Flymake. To install it, the
only thing to do is loading flymake.el for instance
by adding it in the site-lisp directory, to add
a new rule in the makefile of your C projects:

{% highlight bash %}
# Required by Flymake
check-syntax:
        $(CC) -W -Wall $(SRC) $(CFLAGS)
{% endhighlight %}

Let's add some shortcuts in the .emacs file so as to
quickly switch from one error to another.

{% highlight cl %}
;; Flymake Mode
(defun next-flymake-error ()
  (interactive)
  (let ((err-buf nil))
    (condition-case err
        (setq err-buf (next-error-find-buffer))
      (error))
    (if err-buf
        (next-error)
      (progn
        (flymake-goto-next-error)
        (let ((err (get-char-property (point) 'help-echo)))
          (when err
            (message err)))))))

(global-set-key [f8] 'flymake-mode)
(global-set-key [f6] 'next-flymake-error)
(global-set-key [f7] 'flymake-goto-next-error)
{% endhighlight %}

With this configuration, to enable flymake-mode,
just type [f8], and each time the file will be saved,
flymake will recheck errors which will easily be
accessed with [f6] and [f7].

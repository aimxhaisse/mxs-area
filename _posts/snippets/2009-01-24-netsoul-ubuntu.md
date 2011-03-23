---
title: How to install netsoul on Ubuntu
categories: [en, snippet_en]
layout: default
---

{% langfr /fr/snippets/netsoul-ubuntu-fr.html %}

There exists a pidgin plugin for netsoul, its installation
is made for BSDs, and not well documented for Linux. 
As we'll compile the plugin, we need to get pidgin sources,
available in the pidgin-dev package:

{% highlight bash %}
$ sudo apt-get install pidgin-dev
{% endhighlight %}

Get a copy of the [netsoul plugin](http://sourceforge.net/projects/gaim-netsoul/),
then just compile it without forgetting to redefine the ---prefix location:

{% highlight bash %}
$ tar -xf gaim-*.tar.gz
$ cd gaim-netsoul-xxx
$ ./configure --prefix=/usr
$ make
$ sudo make install
{% endhighlight %}

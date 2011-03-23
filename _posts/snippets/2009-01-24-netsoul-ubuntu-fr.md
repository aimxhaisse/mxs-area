---
title: Installer le plugin netsoul de pidgin sous Ubuntu
categories: [fr, snippet_fr]
layout: default
---

{% langen /en/snippets/netsoul-ubuntu-en.html %}

Il existe un plugin de [Pidgin](http://www.pidgin.im/ "Site de Pidgin")
permettant de g&eacute;rer le prototole netsoul, mais son installation
sous Linux demande une petite modification, il faut tout d'abord avoir
les sources &agrave; disposition, pour cela, cela se fait en installant
le paquet suivant:

{% highlight bash %}
$ sudo apt-get install pidgin-dev
{% endhighlight %}

Puis, apr&egrave;s avoir t&eacute;l&eacute;charg&eacute; les
[sources du plugin](http://sourceforge.net/projects/gaim-netsoul/ "Plugin gaim-netsoul pour pidgin"):

{% highlight bash %}
$ tar -xf gaim-*.tar.gz
$ cd gaim-netsoul-xxx
{% endhighlight %}

Il faut ensuite le configurer, l&agrave; il faut &eacute;craser
le prefix par d&eacute;fault sinon le plugin va s'installer
dans /usr/local au lieu de /usr (ce qui est correct sous BSD):

{% highlight bash %}
$ ./configure --prefix=/usr
$ make
$ sudo make install
{% endhighlight %}

A noter que ce post est vieux, et que maintenant,
il existe des solutions probablement meilleures pour avoir
un [netsoul qui clignote avec des couleurs](http://instantbird.com/ "Instantbird, un client avec netsoul en natif").

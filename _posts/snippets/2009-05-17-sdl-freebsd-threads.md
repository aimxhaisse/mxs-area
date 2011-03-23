---
title: SDL, FreeBSD and threads
categories: [en, snippet_en]
layout: default
---
I've recently played with SDL and its thread API
which easily enables to port a program on several
platforms, but it seems that by default on FreeBSD,
a call to SDL_ThreadCreate() will result in a 
Bad system call (core dump).

{% highlight bash %}
(gdb) backtrace
#0  0x282db16b in ksem_init () from /lib/libc.so.7
#1  0x282d0a89 in sem_init () from /lib/libc.so.7
#2  0x280db420 in SDL_CreateSemaphore () from /usr/local/lib/libSDL-1.2.so.11
#3  0x2808ff12 in SDL_CreateThread () from /usr/local/lib/libSDL-1.2.so.11
(gdb) 
{% endhighlight %}

One solution is to force SDL into using pthread's library
by adding some compilation flags:

{% highlight bash %}
-D_RENTRANT -D_THREAD_SAFE -lpthread
{% endhighlight %}

---
title: Trick to convert variables into booleans
categories: [en, snippet_en]
layout: default
---

An ugly trick to convert any type into a boolean in languages without
strong typing rules:

{% highlight php %}
// both lines end up with the same result
$var = !!$var;
$var = (boolean) $var;
{% endhighlight %}

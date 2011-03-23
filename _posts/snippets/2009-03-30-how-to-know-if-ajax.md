---
title: How to know if a request comes from AJAX in PHP
categories: [en, snippet_en]
layout: default
---

It's sometimes necessary to know if a request comes from AJAX,
for instance not to to include the full template in the answer,
but a lighter one (or none). Here's a way to do it:

{% highlight php %}
function      is_ajax_request()
{
     if (isset($_SERVER['HTTP_X_REQUESTED_WITH']))
         if (strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest')
             return (TRUE);
    return (FALSE);
}
{% endhighlight %}

---
title: Retrieve booleans settings from PHP's configuration
categories: [en, snippet_en]
layout: default
---

## The wrong but obvious way

{% highlight php %}
if (ini_get('safe_mode') == false) {
     echo "Safe mode disabled\n";
}
{% endhighlight %}

## Why is this wrong?

* If the setting is defined in __php.ini__, an empty string is returned when 
  disabled, "1" is if enabled, simple, right?
* If the setting is defined somewhere else, let's say in httpd.conf,
  the exact string is returned, __WTF?!__

## A better solution

{% highlight php %}
function ini_get_boolean($setting)
{
       $my_boolean = ini_get($setting);
 
       if ( (int) $my_boolean > 0 )
             $my_boolean = true;
       else
       {
             $my_lowered_boolean = strtolower($my_boolean);
 
             if ($my_lowered_boolean === "true" || $my_lowered_boolean === "on" || $my_lowered_boolean === "yes")
                    $my_boolean = true;
             else
               $my_boolean = false;
       }
 
       return $my_boolean;
}
 
if (ini_get_boolean('safe_mode') === false) {
     echo "Safe mode disabled\n";
}
{% endhighlight %}

## See also

* [PHP's documentation of ini_get](http://fr.php.net/manual/en/function.ini-get.php)
* [PHP bug report](http://bugs.php.net/bug.php?id=52168)

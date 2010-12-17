---
title: d(r)eadlocks
categories: [en, blog]
layout: default
---
I recently went through a problem with two PHP scripts
in what at first sight looked like a bug. Basically, I
wanted a script __a.php__ to update some $_SESSION values
of another script __b.php__ using the same session file.
As I didn't wanted to have a heavy dependance between both
scripts, I ended up using CURL, and calling b.php from a.php:

{% highlight php %}
session_start();

if (($ch = curl_init("http://localhost/b.php"))) {
      foreach ($_COOKIE as $key => $value) {
           $cookie = $key . "=" . $value . "; path=/";
           curl_setopt($ch, CURLOPT_COOKIE, $cookie);
     }
 curl_exec($ch);
 curl_close($ch);
}

echo "My pokemon is " . $_SESSION['pokemon'] . "\n";
{% endhighlight %}

and:

{% highlight php %}
session_start();

$_SESSION['pokemon'] = 'pikachu';
{% endhighlight %}

Both scripts are hosted under the same domain and on
the same host so as to share session files.
Guess what? It times out.

What actually happens is that the PHP process handling
a.php waits for the process handling b.php to finnish
(through the CURL request). Both processes use the same
session file, unfortunately, between a session_start()
call and a session_destroy() call (implicitely made at
the end of the execution of the script), the session file
is locked, leading here to a nice deadlock.

---
title: Inheritance level in c++
layout: default
categories: [en, snippets]
---
I've been looking for a way to know the level of a class in an
inheritance list in C++, here is a quick and dirty solution using a
template class which increments its level value when used.

{% highlight c %}
template        struct          Inc: public T
{
  enum { level = 1 + Inc::level };
};
{% endhighlight %}

This is a bit cumbersome to use, I have no doubt there exists a
better way to do this (I would be thankful to know it). It implies
to add a public enum in the root class, and make inherit children
to the template specialized in the parent class. Here is an example
of code using it :

{% highlight c %}
class           Root
{
public:
  enum { level = 0 };
};

class           One: public Inc{
};

class           Second: public Inc{
};

class           Third: public Inc{
};

int             main(void)
{
  Root          root;
  One           first;
  Second        second;
  Third         third;

  std::cout << "My level is " << root.level << std::endl;
  std::cout << "My level is " << first.level << std::endl;
  std::cout << "My level is " << second.level << std::endl;
  std::cout << "My level is " << third.level << std::endl;
}
{% endhighlight %}

The output:

{% highlight bash %}
> ./a.out
My level is 0
My level is 1
My level is 2
My level is 3
>
{% endhighlight %}

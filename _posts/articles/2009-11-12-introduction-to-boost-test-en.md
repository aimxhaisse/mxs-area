---
title: Introduction to boost test
layout: default
categories: [en, articles]
---

## Introduction

[Boost](http://www.boost.org/) provides a [unit test framework](http://www.boost.org/doc/libs/1_40_0/libs/test/doc/html/index.html)
which ensures that a class works well now, and for its all life,
even if someone decides to change it later. This is a real save
of time when the code is likely to be changed. Here is a little
class we want to test: __Parameter__, at that moment, it stores
an association of two string, a key and a value, and provides
different ways to retrieve its data :

{% highlight c %}
class                 Parameter
{
 private:
   std::string         mKey;
   std::string         mValue;
 public:

   Parameter(void);
   Parameter(const Parameter & aCopy);
   Parameter &         operator=(const Parameter & aCopy);
   ~Parameter();

   Parameter(const std::string & aKey);
   Parameter(const std::string & aKey, const std::string & aValue);
   bool                operator==(const Parameter & aValue) const;

   const std::string & getKey(void) const;
   const std::string & getValue(void) const;
   void                setKey(const std::string & aKey);
   void                setValue(const std::string & aValue);
};
{% endhighlight %}

## Writing tests

First thing we have to do is creating a __main__ that will run our tests:

{% highlight c %}
#define BOOST_TEST_MAIN
#include <boost/test/included/unit_test.hpp>
{% endhighlight %}

This main will launch the test suites we write. Each test suite is
defined by a list of tests applied to a class. Here, we have one
class, so we have one test suite. Let's write a main frame where
we will write Parameter's test suite:

{% highlight c %}
#include <boost/test/unit_test.hpp>

#include "Parameter.hh"

BOOST_AUTO_TEST_SUITE(parameter_tests)

// Here we will write our tests

BOOST_AUTO_TEST_SUITE_END()
{% endhighlight %}

This declares a test suite called __parameter_tests__, we now have
to write our tests in it, this is done with the macro __BOOST_AUTO_TEST_CASE__:

{% highlight c %}
#include <boost/test/unit_test.hpp>

#include "Parameter.hh"

BOOST_AUTO_TEST_SUITE(parameter_tests)

BOOST_AUTO_TEST_CASE(constructors_test)
{
       // Here we write tests related to constructors
}

BOOST_AUTO_TEST_CASE(operators_test)
{
       // Here we write tests related to operators
}

BOOST_AUTO_TEST_SUITE_END()
{% endhighlight %}

Here we declare two tests, one for the construction of a
Parameter, one for the operators, let's write their content,
here again, boost provides some macros :

{% highlight c %}
#include "Parameter.hh"

#include <boost/test/unit_test.hpp>
#include <string>

BOOST_AUTO_TEST_SUITE(ini_parameter_tests)

BOOST_AUTO_TEST_CASE(constructors_test)
{
  BOOST_MESSAGE("testing ini::parameter constructor/setters/getters");

  std::string           empty("");

  Parameter        a;
  BOOST_CHECK_EQUAL(a.getValue(), empty);
  BOOST_CHECK_EQUAL(a.getKey(), empty);

  // etc...
}

BOOST_AUTO_TEST_CASE(operators_test)
{
  BOOST_MESSAGE("testing ini::parameter operators");

  Parameter        a;
  Parameter        b;
  Parameter        c("key");

  BOOST_CHECK(a == b);
  BOOST_CHECK(!(a == c));
  BOOST_CHECK(c == c);
}

BOOST_AUTO_TEST_SUITE_END()
{% endhighlight %}

## Running tests

That's it, let's compile it and link it with ___boost_test_exec_monitor___:

{% highlight bash %}
> make
c++ -I../ -I/usr/local/include/ -I../../ -c Runner.cpp
c++ -I../ -I/usr/local/include/ -I../../ -c ../Parameter.cpp
c++ -I../ -I/usr/local/include/ -I../../ -c ParameterTest.cpp
g++ -Wall *.o -o run_tests -L/usr/local/lib -lboost_test_exec_monitor
>
> ./run_tests 
Running 2 test cases...
*** No errors detected
{% endhighlight %}

By default, the __BOOST_MESSAGE__ macros don't print anything, this
is because there are several levels of logging in boost test, it can
be customized through the environment:

{% highlight bash %}
> export BOOST_TEST_LOG_LEVEL=message
> ./run_tests 
Running 2 test cases...
testing parameter constructor/setters/getters
testing parameter operators
*** No errors detected
{% endhighlight %}

Now let's see what happens when a test fails:

{% highlight bash %}
Running 2 test cases...
testing ini::parameter constructor/setters/getters
ParameterTest.cpp(43): error in "constructors_test": check a.getKey() == d.getKey() failed [ != key]
ParameterTest.cpp(44): error in "constructors_test": check a.getValue() == d.getValue() failed [ != value]
testing ini::parameter operators

*** 2 failures detected in test suite "Master Test Suite"
{% endhighlight %}

## Fixtures

What if we have another class called __X__ that contains
several instances of Parameter? How to test it? We need
to create an instance of X and feed it with Parameters
each time we need to make a test, this is boring.
Fortunately, fixtures are here to simplify this task: let's
write a XFixture class, that contains a public instance
of X called mX;

{% highlight c %}
struct XFixture
{
      XFixture()
      {
              mX.addNewParam(new Parameter("a"));
              mX.addNewParam(new Parameter("b", "val1"));
              mX.addNewParam(new Parameter("c", "val2"));
      }

     ~XFixture()
     {
          ;
     }

     X      mX;
};
{% endhighlight %}

Now, each time we need to write a test that requires the
initialized instance of X, we only have to declare the test
with the help of the macro __BOOST_FIXTURE_TEST_CASE__:

{% highlight c %}
BOOST_AUTO_TEST_SUITE(x_tests)

BOOST_FIXTURE_TEST_CASE(xTest, XFixture)
{
     // here mX is available directly (public instance from XFixture)
}

BOOST_AUTO_TEST_SUITE_END()
{% endhighlight %}

Fixtures are reinitialized for each test, so it's ok not to
restore them to their initial state. 

## Conclusion

Boost test provides a way to quickly write test with a few
macros, taking over repetitive tasks. Unfortunately, the 
<a href="http://www.boost.org/doc/libs/1_40_0/libs/test/doc/html/intro.html">documentation</a>
is quite hard to begin with, (this is why I've written this article).
I haven't tested yet other unit testing frameworks (cpptest? cppunit? ...),
and I hope I will have time to try it.

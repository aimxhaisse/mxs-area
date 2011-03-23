---
title: How to get statistics about memory in Golang
categories: [en, snippet_en]
layout: default
---

I recently played with [golang](http://golang.org/) and was a bit surprised
about the memory usage of a program displayed by _top_. Let's see how to use
some reflective tools from the [runtime package](http://golang.org/pkg/runtime/)
to retrieve information about the running program. We will write data to a
file, and then process it with [gnuplot](http://www.gnuplot.info/) to
display a graph. We'll need the following packages:
* __time__ to print the current timestamp
* __os__ to write to a log file
* __runtime__ to retrieve information about memory
* __fmt__ to format the string

So the first step is to import them:

{% highlight go%}
import (
	"os"
	"fmt"
	"runtime"
	"time"
)
{% endhighlight %}

We need a function to create the file at startup :

{% highlight go %}
const MEMLOG_PATH = "memory.log"     // path to log memory statistics
var memlog *os.File = nil

func InitMemLog() (bool) {
	var err os.Error
	memlog, err = os.Open(MEMLOG_PATH, os.O_WRONLY | os.O_CREAT, 0666)
	if err != nil {
		fmt.Printf("Unable to open %s\n", MEMLOG_PATH)
		return false
	}
	return true
}
{% endhighlight %}

Then, we need to find a place in the program which is repeatedly executed,
so as to trigger the following function that writes to the log file:

{% highlight go %}
func MemLog() {
	if memlog != nil {
		t := time.LocalTime()
		if t != nil {
			s := runtime.MemStats
			memlog.WriteString(
				fmt.Sprintf("%d %d %d\n", t.Seconds(), s.Alloc, s.Sys))
		}
	}
}
{% endhighlight %}

This will write to the log file something as follow:

{% highlight bash %}
# timestamp     in use memory   allocated memory
1294926363      4433792         11118840
1294926399      9375280         17537272
1294926461      11561584        24692984
1294926539      6964664         27924728
1294926560      9147696         27924728
1294926659      6689736         27924728
{% endhighlight %}

The difference between in use memory and allocated memory is that the current
garbage collector doesn't release memory at all, and keeps unused memory for
a later use. That's why the amount of memory used by your program may be very
surprising when looking at what's being reported by _top_.

Finally, let's create a plot script to display our data in a nice way :

{% highlight gnuplot %}
set xlabel "time"
set xdata time
set format x "%H:%M"
set timefmt "%s"
set format y "%2.0f"
set mxtics 10
set ylabel "bytes"
set autoscale
plot  "memory.log" using 1:2 title 'In use memory' with lines, \
      "memory.log" using 1:3 title 'System memory' with lines
{% endhighlight %}

The result can be seen by running the following:

{% highlight bash %}
$ gnuplot -p mem.plot
{% endhighlight %}

Which will display something like:

<center markdown="1">
        ![gnuplot](/static/data/gnuplot-golang.png "example of the memory usage of a go program")
</center>

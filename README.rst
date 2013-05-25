Straightforward date parsing and formatting for Javascript. I mean, it was
written for Coffeescript, and it's called CoffeeDate, but that's just for
the sake of cleverness.

Anyhow, if you ever wanted to simplify the process of working with dates in
Javascript, this library is for you. Inspired by python datetime's formatting,
with slight differences.

Quick Start
============

Instantiate using the constructor, or with the class method `parse`. The
constructor takes year, month, day, hour, minute, seconds, microsecond in
that order, all optional. The defaults are 1970, 1, 1, 0, 0, 0, 0::

    d = new CoffeeDate(2012, 5, 6)
    d.year // 2012
    d.month // 5
    d.day // 6

Parsing and formatting are done a lot like the Python datetime library does it.
Difference is, that's about all that this library does::

    d = CoffeeDate.parse("2010-01-01 13:12:05", "%Y-%m-%d %H:%M:%S")
    d.hour // 13
    d.minute // 12
    d.second // 0
    datestr = d.format("%b %d, %Y %i:%M %p") // "Jan 1, 2010 1:12 pm"

Limitations
==============

* No localization support, at the moment.
* **No time zone information is stored, computed, or cared about**. This is a formatting library.
* All years are assumed A.D./C.E.
* 2-digit years pivot at 1970. (e.g. 71 -> 1971, 70 -> 2070)

If you have any problems with these, fork away!

Formatting and Parsing
========================

Construct your format string using these substitutions. Many are more
permissive parsing than formatting; for example, "%M" accepts zero-padded or
not. Hours have special format strings for zero-padded or not output.

== ========================================================
%a Weekday abbreviation (e.g. Mon)
%A Weekday name (e.g. Monday)
%b Month abbreviation (e.g. Jun)
%c Year, two digits, 2000-2099. Format with leading zero.
%B Month name (e.g. June)
%d Day of month, numeric (1-31). Format with no leading zero.
%D Day of month, numeric (01-31). Format with leading zero.
%f Microsecond. Format with leading zeros
%h Hour, 24-hour time. Format with no leading zero
%H Hour, 24-hour time. Format with leading zero
%i Hour, 12-hour time. Format with no leading zero
%I Hour, 12-hour time. Format with leading zero
%m Month, numeric (1-12). Zero-padded
%M Minutes. Format with leading zero
%p AM or PM. /[ap]\.?m?\.?/i
%S Seconds. Format with leading zero
%y Year, two digits, 1970-2069. Format with leading zero.
%Y Year, four digits. Format with leading zero.
== ========================================================

Extending the parsers
===========================

You can easily add your own parsers to CoffeeDate, using `CoffeeDate.set_parser`.
It accepts two arguments:

1. A format to trigger on (e.g. `"%y"`)
2. A specification, which is a list of `[re, f]`, `re` being the regex to match and `f` being the function to apply.

`f` should take two arguments. The first argument is the matched string, and the second one is the CoffeeDate object
we're applying the match to.

Here's an example::

    // We currently pivot on 1970
    d = CoffeeDate.parse('10', '%y');
    d.year == 2010
    d = CoffeeDate.parse('90', '%y');
    d.year == 1990

    // Format 2-digit years from 1900-1999 instead of 1970-2069
    CoffeeDate.set_parser('%y', [/[0-9]{1,2}/, function(s, d){ d.year = parseInt(s) + 1900; }])
    CoffeeDate.parse('10', '%y')
    d.year == 1910
    d = CoffeeDate.parse('90', '%y');
    d.year == 1990

Changing the base century and pivot for 2-digit years is by far the most common use for this,
so CoffeeDate also has a helper method called `year_parser` to help::

    // Same as above
    CoffeeDate.set_parser("%y", CoffeeDate.year_parser(1900, 0))

    // 1650-1749
    CoffeeDate.set_parser("%y", CoffeeDate.year_parser(1600, 50))


License
========

Released under the MIT License

|copy| 2012, Adam Bard, except the Jasmine code.

.. |copy| unicode:: 0xA9 .. Copyright sign

Straightforward date parsing and formatting for Javascript. I mean, it was
written for Coffeescript, and it's called CoffeeDate, but that's just for
the sake of cleverness.

Anyhow, if you ever wanted to simplify the process of working with dates in
Javascript, this library is for you. Inspired by python datetime's formatting,
with slight differences.

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
%y Year, two digits. Format with leading zero.
%Y Year, four digits. Format with leading zero.
== ========================================================

Examples
===========

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

License
========

Released under the MIT License

|copy| 2012, Adam Bard, except the Jasmine code.

.. |copy| unicode:: 0xA9 .. Copyright sign

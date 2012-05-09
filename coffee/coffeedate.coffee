# This comes up a lot
zeropad = (num, deg) ->
    s = num.toString()
    while s.length < deg
        s = "0" + s
    s

MONTHS = [
    "" # Zeroeth month
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"]

DAYS = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"]

weekday_num = (d) ->
    d.to_date().getDay()

fmt_weekday_name = (d) ->
    wd_num = weekday_num(d)
    if wd_num < 0 or wd_num > 6
        throw("Invalid weekday num: #{wd_num}")

    DAYS[wd_num]

fmt_month_name = (d) ->
    if d.month < 1 or d.month > 12
        throw("Invalid month: #{d.month}")
    MONTHS[d.month]

# To add a mapping pick a token (% plus a letter), and provide
# a function that accepts a CoffeeDate instance, and outputs a
# string to replace the token with.
FORMAT_MAPPINGS =
    "%a": (d) -> fmt_weekday_name(d)[0..2]
    "%A": fmt_weekday_name
    "%b": (d) -> fmt_month_name(d)[0..2]
    "%B": fmt_month_name
    "%d": (d) -> d.day.toString()
    "%D": (d) -> zeropad(d.day, 2)
    "%f": (d) -> zeropad(d.microsecond, 6)
    "%h": (d) -> zeropad(d.hour, 2)
    "%H": (d) ->
        hr = if d.hour == 12 then 12 else d.hour % 12
        hr.toString()
    "%i": (d) ->
        hr = if d.hour == 12 then 12 else d.hour % 12
        hr.toString()
    "%I": (d) ->
        hr = if d.hour == 12 then 12 else d.hour % 12
        zeropad(hr, 2)
    "%m": (d) -> zeropad(d.month, 2)
    "%M": (d) -> zeropad(d.minute, 2)
    "%p": (d) -> if d.hour > 11 then "pm" else "am"
    "%S": (d) -> zeropad(d.second, 2)
    "%w": (d) -> weekday_num(d).toString()
    "%y": (d) -> zeropad(d.year % 100, 2)
    "%Y": (d) -> zeropad(d.year, 4)
    "%%": (d) -> '%'

parse_noop = (s, d) ->

parse_month_abbr = (s, d) ->
    d.month = switch s.toLowerCase()
        when "jan" then 1
        when "feb" then 2
        when "mar" then 3
        when "apr" then 4
        when "may" then 5
        when "jun" then 6
        when "jul" then 7
        when "aug" then 8
        when "sep" then 9
        when "oct" then 10
        when "nov" then 11
        when "dec" then 12
        else throw("Invalid month: #{s}")

PARSE_MAPPINGS =
    "%a": [/^(mon|tue|wed|thu|fri|sat|sun)/i, parse_noop]
    "%A": [/^(monday|tuesday|wednesday|thursday|friday|saturday|sunday)/i, parse_noop]

    "%b": [/^(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)/i, parse_month_abbr]
    "%B": [/^(january|february|march|april|may|june|july|august|september|october|november|december)/i, (s, d) -> parse_month_abbr(s[0..2], d)]
    "%d": [/^[0-9]{1,2}/, (s, d) -> d.day = parseInt(s, 10)]
    "%D": [/^[0-9]{1,2}/, (s, d) -> d.day = parseInt(s, 10)]
    "%f": [/^[0-9]+/, (s, d) -> d.microsecond = parseInt(s, 10)]
    "%h": [/^[0-9]{1,2}/, (s, d) -> d.hour = parseInt(s, 10)]
    "%H": [/^[0-9]{1,2}/, (s, d) -> d.hour = parseInt(s, 10)]
    "%i": [/^[0-9]{1,2}/, (s, d) -> d.hour = parseInt(s, 10)]
    "%I": [/^[0-9]{1,2}/, (s, d) -> d.hour = parseInt(s, 10)]
    "%m": [/^[0-9]{1,2}/, (s, d) -> d.month = parseInt(s, 10)]
    "%M": [/^[0-9]{1,2}/, (s, d) -> d.minute = parseInt(s, 10)]
    "%p": [/^[ap]\.?m?\.?/i, (s, d) ->
        if s.match(/p/)
            if d.hour < 12 and d.hour > 0
                d.hour += 12
        else if d.hour == 12
            d.hour = 0
    ]
    "%S": [/^[0-9]{1,2}/, (s, d) -> d.second = parseInt(s, 10)]
    "%y": [/^[0-9]{2}/, (s, d) ->
        yr = parseInt(s, 10)
        if yr > 70
            d.year = 1900 + yr
        else
            d.year = 2000 + yr]
    "%Y": [/^[0-9]{4}/, (s, d) -> d.year = parseInt(s, 10)]
    "%%": [/^%/, parse_noop]


class CoffeeDate

    constructor: (@year=1970, @month=1, @day=1, @hour=0, @minute=0, @second=0, @microsecond=0) ->

    format: (fmt) ->
        for s, fn of FORMAT_MAPPINGS
            fmt = fmt.replace(s, fn(@))
        fmt

    to_date: ->
        new Date(@year, @month-1, @day, @hour, @minute, @second, @microsecond)

    mktime: ->
        Date.UTC(@year, @month-1, @day, @hour, @minute, @second, @microsecond)

    @compare: (d1, d2) ->
        d1.mktime() - d2.mktime()

    @parse: (s, fmt) ->
        d = new CoffeeDate()
        len = fmt.length
        ii = 0

        while ii < len

            # Iterate through s
            if fmt[ii] != '%'
                ii += 1
                continue

            tok = fmt[ii..ii + 1]
            if PARSE_MAPPINGS.hasOwnProperty(tok)
                [fmt_re, fmt_fn] = PARSE_MAPPINGS[tok]
                match = s.substr(ii).match(fmt_re)
                if not match
                    throw("Error parsing date (#{fmt_re} did not match #{s.substr(ii)})")

                rep_s = match[0]
                fmt_fn(match[0], d) # Update date
                fmt = fmt.replace(tok, rep_s) # Update format string

                # Restart scan.
                len = fmt.length

        d

window.CoffeeDate = CoffeeDate

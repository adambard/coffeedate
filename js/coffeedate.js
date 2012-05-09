(function() {
  var CoffeeDate, DAYS, FORMAT_MAPPINGS, MONTHS, PARSE_MAPPINGS, fmt_month_name, fmt_weekday_name, parse_month_abbr, parse_noop, weekday_num, zeropad;

  zeropad = function(num, deg) {
    var s;
    s = num.toString();
    while (s.length < deg) {
      s = "0" + s;
    }
    return s;
  };

  MONTHS = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

  DAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  weekday_num = function(d) {
    return d.to_date().getDay();
  };

  fmt_weekday_name = function(d) {
    var wd_num;
    wd_num = weekday_num(d);
    if (wd_num < 0 || wd_num > 6) throw "Invalid weekday num: " + wd_num;
    return DAYS[wd_num];
  };

  fmt_month_name = function(d) {
    if (d.month < 1 || d.month > 12) throw "Invalid month: " + d.month;
    return MONTHS[d.month];
  };

  FORMAT_MAPPINGS = {
    "%a": function(d) {
      return fmt_weekday_name(d).slice(0, 3);
    },
    "%A": fmt_weekday_name,
    "%b": function(d) {
      return fmt_month_name(d).slice(0, 3);
    },
    "%B": fmt_month_name,
    "%d": function(d) {
      return d.day.toString();
    },
    "%D": function(d) {
      return zeropad(d.day, 2);
    },
    "%f": function(d) {
      return zeropad(d.microsecond, 6);
    },
    "%h": function(d) {
      return zeropad(d.hour, 2);
    },
    "%H": function(d) {
      var hr;
      hr = d.hour === 12 ? 12 : d.hour % 12;
      return hr.toString();
    },
    "%i": function(d) {
      var hr;
      hr = d.hour === 12 ? 12 : d.hour % 12;
      return hr.toString();
    },
    "%I": function(d) {
      var hr;
      hr = d.hour === 12 ? 12 : d.hour % 12;
      return zeropad(hr, 2);
    },
    "%m": function(d) {
      return zeropad(d.month, 2);
    },
    "%M": function(d) {
      return zeropad(d.minute, 2);
    },
    "%p": function(d) {
      if (d.hour > 11) {
        return "pm";
      } else {
        return "am";
      }
    },
    "%S": function(d) {
      return zeropad(d.second, 2);
    },
    "%w": function(d) {
      return weekday_num(d).toString();
    },
    "%y": function(d) {
      return zeropad(d.year % 100, 2);
    },
    "%Y": function(d) {
      return zeropad(d.year, 4);
    },
    "%%": function(d) {
      return '%';
    }
  };

  parse_noop = function(s, d) {};

  parse_month_abbr = function(s, d) {
    return d.month = (function() {
      switch (s.toLowerCase()) {
        case "jan":
          return 1;
        case "feb":
          return 2;
        case "mar":
          return 3;
        case "apr":
          return 4;
        case "may":
          return 5;
        case "jun":
          return 6;
        case "jul":
          return 7;
        case "aug":
          return 8;
        case "sep":
          return 9;
        case "oct":
          return 10;
        case "nov":
          return 11;
        case "dec":
          return 12;
        default:
          throw "Invalid month: " + s;
      }
    })();
  };

  PARSE_MAPPINGS = {
    "%a": [/^(mon|tue|wed|thu|fri|sat|sun)/i, parse_noop],
    "%A": [/^(monday|tuesday|wednesday|thursday|friday|saturday|sunday)/i, parse_noop],
    "%b": [/^(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)/i, parse_month_abbr],
    "%B": [
      /^(january|february|march|april|may|june|july|august|september|october|november|december)/i, function(s, d) {
        return parse_month_abbr(s.slice(0, 3), d);
      }
    ],
    "%d": [
      /^[0-9]{1,2}/, function(s, d) {
        return d.day = parseInt(s, 10);
      }
    ],
    "%D": [
      /^[0-9]{1,2}/, function(s, d) {
        return d.day = parseInt(s, 10);
      }
    ],
    "%f": [
      /^[0-9]+/, function(s, d) {
        return d.microsecond = parseInt(s, 10);
      }
    ],
    "%h": [
      /^[0-9]{1,2}/, function(s, d) {
        return d.hour = parseInt(s, 10);
      }
    ],
    "%H": [
      /^[0-9]{1,2}/, function(s, d) {
        return d.hour = parseInt(s, 10);
      }
    ],
    "%i": [
      /^[0-9]{1,2}/, function(s, d) {
        return d.hour = parseInt(s, 10);
      }
    ],
    "%I": [
      /^[0-9]{1,2}/, function(s, d) {
        return d.hour = parseInt(s, 10);
      }
    ],
    "%m": [
      /^[0-9]{1,2}/, function(s, d) {
        return d.month = parseInt(s, 10);
      }
    ],
    "%M": [
      /^[0-9]{1,2}/, function(s, d) {
        return d.minute = parseInt(s, 10);
      }
    ],
    "%p": [
      /^[ap]\.?m?\.?/i, function(s, d) {
        if (s.match(/p/)) {
          if (d.hour < 12 && d.hour > 0) return d.hour += 12;
        } else if (d.hour === 12) {
          return d.hour = 0;
        }
      }
    ],
    "%S": [
      /^[0-9]{1,2}/, function(s, d) {
        return d.second = parseInt(s, 10);
      }
    ],
    "%y": [
      /^[0-9]{2}/, function(s, d) {
        var yr;
        yr = parseInt(s, 10);
        if (yr > 70) {
          return d.year = 1900 + yr;
        } else {
          return d.year = 2000 + yr;
        }
      }
    ],
    "%Y": [
      /^[0-9]{4}/, function(s, d) {
        return d.year = parseInt(s, 10);
      }
    ],
    "%%": [/^%/, parse_noop]
  };

  CoffeeDate = (function() {

    function CoffeeDate(year, month, day, hour, minute, second, microsecond) {
      this.year = year != null ? year : 1970;
      this.month = month != null ? month : 1;
      this.day = day != null ? day : 1;
      this.hour = hour != null ? hour : 0;
      this.minute = minute != null ? minute : 0;
      this.second = second != null ? second : 0;
      this.microsecond = microsecond != null ? microsecond : 0;
    }

    CoffeeDate.prototype.format = function(fmt) {
      var fn, s;
      for (s in FORMAT_MAPPINGS) {
        fn = FORMAT_MAPPINGS[s];
        fmt = fmt.replace(s, fn(this));
      }
      return fmt;
    };

    CoffeeDate.prototype.to_date = function() {
      return new Date(this.year, this.month - 1, this.day, this.hour, this.minute, this.second, this.microsecond);
    };

    CoffeeDate.prototype.mktime = function() {
      return Date.UTC(this.year, this.month - 1, this.day, this.hour, this.minute, this.second, this.microsecond);
    };

    CoffeeDate.compare = function(d1, d2) {
      return d1.mktime() - d2.mktime();
    };

    CoffeeDate.parse = function(s, fmt) {
      var d, fmt_fn, fmt_re, ii, len, match, rep_s, tok, _ref;
      d = new CoffeeDate();
      len = fmt.length;
      ii = 0;
      while (ii < len) {
        if (fmt[ii] !== '%') {
          ii += 1;
          continue;
        }
        tok = fmt.slice(ii, (ii + 1) + 1 || 9e9);
        if (PARSE_MAPPINGS.hasOwnProperty(tok)) {
          _ref = PARSE_MAPPINGS[tok], fmt_re = _ref[0], fmt_fn = _ref[1];
          match = s.substr(ii).match(fmt_re);
          if (!match) {
            throw "Error parsing date (" + fmt_re + " did not match " + (s.substr(ii)) + ")";
          }
          rep_s = match[0];
          fmt_fn(match[0], d);
          fmt = fmt.replace(tok, rep_s);
          len = fmt.length;
        }
      }
      return d;
    };

    return CoffeeDate;

  })();

  window.CoffeeDate = CoffeeDate;

}).call(this);

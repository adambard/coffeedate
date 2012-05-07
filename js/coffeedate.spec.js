var FMT_PAIRS;

FMT_PAIRS = {
  "99042100": "%y%m%d%h",
  "2009-01-02, 11:00:00": "%Y-%m-%D, %h:%M:%S",
  "Mar 12, 1985": "%b %d, %Y",
  "12:01 pm": "%I:%M %p",
  "7804021230": "%y%m%D%H%M",
  "Mon, May 7, 2012": "%a, %B %d, %Y"
};

describe("CoffeeDate", function() {
  it("Formats dates as expected", function() {
    var d, datestr, fmtstr, _results;
    _results = [];
    for (datestr in FMT_PAIRS) {
      fmtstr = FMT_PAIRS[datestr];
      d = CoffeeDate.parse(datestr, fmtstr);
      _results.push(expect(d.format(fmtstr)).toEqual(datestr));
    }
    return _results;
  });
  return it("Knows what am and pm mean", function() {
    var d, fmtstr;
    fmtstr = "%B %D, '%y, %i:%M %p";
    d = CoffeeDate.parse("January 27, '72, 8:00 p.m.", fmtstr);
    console.log(d.format("%Y-%m-%d %H:%M:%S"));
    return expect(d.format(fmtstr)).toEqual("January 27, '72, 8:00 pm");
  });
});

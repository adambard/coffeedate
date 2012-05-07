FMT_PAIRS =
    "99042100": "%y%m%d%h",
    "2009-01-02, 11:00:00": "%Y-%m-%D, %h:%M:%S",
    "Mar 12, 1985": "%b %d, %Y",
    "12:01 pm": "%I:%M %p"
    "7804021230": "%y%m%D%H%M"
    "Sun, May 6, 2012": "%a, %B %d, %Y"

describe "CoffeeDate", ->
    it "Formats dates as expected", ->
        for datestr, fmtstr of FMT_PAIRS
            d = CoffeeDate.parse(datestr, fmtstr)
            expect(d.format(fmtstr)).toEqual(datestr)

    it "Knows what am and pm mean", ->
        fmtstr = "%B %D, '%y, %i:%M %p"
        d = CoffeeDate.parse("January 27, '72, 8:00 p.m.", fmtstr)
        console.log(d.format("%Y-%m-%d %H:%M:%S"))
        expect(d.format(fmtstr)).toEqual("January 27, '72, 8:00 pm")

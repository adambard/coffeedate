FMT_PAIRS =
    "99042100": "%y%m%d%h"
    "2009-01-02, 11:00:00": "%Y-%m-%D, %h:%M:%S"
    "Mar 12, 1985": "%b %d, %Y"
    "12:01 pm": "%I:%M %p"
    "7804021230": "%y%m%D%H%M"
    "Mon, May 7, 2012": "%a, %B %d, %Y"
    "Mon, May 7, 12": "%a, %B %d, %y"
    "01/01/10": "%m/%D/%c"

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

    it "Can handle all sorts of year definitions", ->
        # Current century
        d = CoffeeDate.parse("10", "%c")
        expect(d.year).toEqual(2010)
        d = CoffeeDate.parse("90", "%c")
        expect(d.year).toEqual(2090)

        # DIY ones:
        # 1750-1849
        CoffeeDate.set_parser('%y', CoffeeDate.year_parser(1700, 50))
        d = CoffeeDate.parse("10", "%y")
        expect(d.year, 1810)
        d = CoffeeDate.parse("90", "%y")
        expect(d.year, 1790)

        # 1900-1999
        CoffeeDate.set_parser('%y', CoffeeDate.year_parser(1900, 0))
        d = CoffeeDate.parse("22", "%y")
        expect(d.year, 1922)
        d = CoffeeDate.parse("90", "%y")
        expect(d.year, 1990)




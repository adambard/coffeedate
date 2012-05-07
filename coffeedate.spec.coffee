describe "CoffeeDate", ->
    it "Formats dates as expected", ->

        fmtpairs = 
            "2009-01-02, 11:00:00": "%Y-%m-%d, %H:%M:%S",
            "99042100": "%y%m%d%H",
            "Mar 12, 1985": "%m %d, %Y",
            "12:08:10 pm": "%I:%M %p",
        for datestr, fmtstr of fmtpairs
            d = CoffeeDate.strptime(datestr, fmtstr)
            expect(d.strftime(fmtstr)).toEqual(datestr)

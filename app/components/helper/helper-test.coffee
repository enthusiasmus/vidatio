"use strict"

describe "Service Helper", ->
    beforeEach ->
        @Helper = new window.vidatio.Helper()

    it 'should recognize wgs84 degree decimal coordinates correctly', ->

        # with leading sign
        coordinate = "0"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "-180"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "180"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()

        # with classification at the front
        coordinate = "N 0"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "N 90"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "S 0"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "S 90"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "E 0"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "E 180"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "W 0"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "W 180"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()

        # with classification at the end
        coordinate = "0 N"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "90 N"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "0 S"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "90 S"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "0 E"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "180 E"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "0 W"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "180 W"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()

        # with degree symbol
        coordinate = "0°"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "-180°"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "W 180°"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "180° W"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()

        # without space between classification and decimal number
        coordinate = "N0"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "N90"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "0S"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "90S"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "E0"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "E180"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "0W"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()
        coordinate = "180W"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeTruthy()

        coordinate = "181"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "-181"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "N -90"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "N 91"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "S -90"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "S 91"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "E -180"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "E 181"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "W -180"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()
        coordinate = "W 181"
        expect(@Helper.isCoordinateWGS84DegreeDecimal(coordinate)).toBeFalsy()

    it 'should recognize wgs84 degree decimal minutes coordinates correctly', ->
        coordinate = "180 59"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeTruthy()
        coordinate = "E180 59"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeTruthy()
        coordinate = "N 90 0"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeTruthy()
        coordinate = "W 180° 59.999"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeTruthy()
        coordinate = "180° 59.999 W"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeTruthy()

        coordinate = "180"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeFalsy()
        coordinate = "181W 59.999"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeFalsy()
        coordinate = "W 0° 60"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeFalsy()
        coordinate = "S 90° 61"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutes(coordinate)).toBeFalsy()

    it 'should recognize wgs84 degree decimal minutes seconds coordinates correctly', ->
        coordinate = "180° 59' 0''"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeTruthy()
        coordinate = "E180 59 50"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeTruthy()
        coordinate = "N 90 59 59.999"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeTruthy()
        coordinate = "180° 1 59.999 W"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeTruthy()

        coordinate = "180 59"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeFalsy()
        coordinate = "180 59.1 50"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeFalsy()
        coordinate = "180° 59.1 50"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeFalsy()
        coordinate = "S 180° 59 60"
        expect(@Helper.isCoordinateWGS84DegreeDecimalMinutesSeconds(coordinate)).toBeFalsy()

    it "should remove null values of a two dimensional array", ->
        dataset = [
            [
                null, null, null, null, null
            ]
            [
                null, "true", "false", null, null
            ]
            [
                null, "true", "false", null, null
            ]
            [
                null, null, null, null, null
            ]
        ]

        result = [
            [
                "true", "false"
            ]
            [
                "true", "false"
            ]
        ]

        expect(@Helper.trimDataset dataset).toEqual result

    it "should create a matrix with the initial value", ->
        dataset = [
            [
                "true", "true", "true"
            ]
            [
                "true", "true", "true"
            ]
            [
                "true", "true", "true"
            ]
        ]

        result = [
            [
                true, true, true
            ]
            [
                true, true, true
            ]
            [
                true, true, true
            ]
        ]

        expect(@Helper.createMatrix dataset, true).toEqual result

    it "should check if a value is a number", ->
        expect(@Helper.isNumber 3.14159).toBeTruthy()
        expect(@Helper.isNumber 180).toBeTruthy()
        expect(@Helper.isNumber -42).toBeTruthy()
        expect(@Helper.isNumber "Test").toBeFalsy()
        expect(@Helper.isNumber undefined).toBeFalsy()
        expect(@Helper.isNumber null).toBeFalsy()
        expect(@Helper.isNumber true).toBeFalsy()

    it "should cut the dataset by the specified amount of rows", ->
        @Helper.rowLimit = 2

        dataset = [
            [
                true, true, true
            ]
            [
                true, true, true
            ]
            [
                false, false, false
            ]
        ]

        result = [
            [
                true, true, true
            ]
            [
                true, true, true
            ]
        ]

        expect(@Helper.cutDataset dataset).toEqual result

    it 'should identify phone numbers', ->
        expect(@Helper.isPhoneNumber "+43 902 128391" ).toBeTruthy()
        expect(@Helper.isPhoneNumber "+43-231-128391" ).toBeTruthy()
        expect(@Helper.isPhoneNumber "+43.902.128391" ).toBeTruthy()
        expect(@Helper.isPhoneNumber "+43-231" ).toBeFalsy()
        expect(@Helper.isPhoneNumber "+43.128." ).toBeFalsy()
        expect(@Helper.isPhoneNumber "43 902 128391" ).toBeFalsy()

    it 'should identify phone numbers', ->
        expect(@Helper.isEmailAddress "office.vidatio@vidatio.de" ).toBeTruthy()
        expect(@Helper.isEmailAddress "office@vidat.io" ).toBeTruthy()
        expect(@Helper.isEmailAddress "office-vidatio@vidat.io" ).toBeTruthy()
        expect(@Helper.isEmailAddress "@test.de" ).toBeFalsy()
        expect(@Helper.isEmailAddress "email@test@.de" ).toBeFalsy()
        expect(@Helper.isEmailAddress "@test.de" ).toBeFalsy()
        expect(@Helper.isEmailAddress "email@.de" ).toBeFalsy()
        expect(@Helper.isEmailAddress "+43 549 198012" ).toBeFalsy()

    it 'should identify urls', ->
        expect(@Helper.isURL "http://vidatio.mediacube.at" ).toBeTruthy()
        expect(@Helper.isURL "http://www.vidatio.mediacube.at" ).toBeTruthy()

        expect(@Helper.isURL "htt://.mediacube.at" ).toBeFalsy()
        expect(@Helper.isURL "http:vidatio.mediacube.at/delete?q=test&result=test" ).toBeFalsy()

    it 'should identify dates', ->
        expect(@Helper.isDate "01.01.2000" ).toBeTruthy()
        expect(@Helper.isDate "31.12.2000" ).toBeTruthy()
        expect(@Helper.isDate "12.31.2000" ).toBeTruthy()

        expect(@Helper.isDate "31.13.2000" ).toBeFalsy()
        expect(@Helper.isDate "32.12.2000" ).toBeFalsy()
        expect(@Helper.isDate "13/31/2000" ).toBeFalsy()
        expect(@Helper.isDate "12-32-2000" ).toBeFalsy()

        expect(@Helper.isDate "2016-01-13" ).toBeTruthy()
        expect(@Helper.isDate "2016-12-31" ).toBeTruthy()
        expect(@Helper.isDate "2016/12/31" ).toBeTruthy()
        expect(@Helper.isDate "2016/12/31" ).toBeTruthy()

        expect(@Helper.isDate "2016/00/31" ).toBeFalsy()
        expect(@Helper.isDate "2016/12/32" ).toBeFalsy()

    it 'should should transform 2 dimensional arrays to arrays of objects', ->
        test = [
            [ 123, "Hello World" ]
            [ 456, "This is a test" ]
        ]

        result = [
            {
                x: "Hello World"
                y: 123
            }
            {
                x: "This is a test"
                y: 456
            }
        ]

        xColumn = 1
        yColumn = 0

        transformedDataset = @Helper.subsetWithXColumnFirst(test, xColumn, yColumn)
        console.log "EXPECTED RESULT", transformedDataset
        expect(transformedDataset).toEqual(result)


//
//  HDDUtil.swift
//  SwiftIB
//
//  Created by Harry Li on 15/01/2015.
//  Copyright (c) 2014-2019 Hanfei Li. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to
// do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

struct HDDConfig {
    // default values
    var host = "127.0.0.1"
    var port: UInt32 = 4002
    var tickers = ["TQQQ","SQQQ"]//[String]()
    var exchange = "SMART"
    var primaryEx = "ISLAND"
    var rth = 1
    var barsize = "1 secs"//"1 secs"
    var unixts = 1
    var duration = "1800 S" // 3 hours
    var sleepInterval = 10.0
    var outputDir: String = FileManager.default.currentDirectoryPath
    var append = false
    var normal_filename = true
    var dayStart = "000000"
    var sinceDatetime = "20200701 00:00:00" //""
    var untilDatetime = "20200702 00:00:00" //""
    var clientID = 1 
    var help = false
    
    init(arg_array: [String]) {
        sinceDatetime = "20200702 00:00:00" //""
        untilDatetime = "20200703 00:00:00" //""

        var argValue:[Bool] = [Bool](repeating: false, count: arg_array.count)
        var index = 1
        for arg in arg_array[1..<arg_array.count] {
            switch arg {
            case "--help":
                let help = """
                Example of parameters
                --host 127.0.0.1
                --port 8080
                --rth true // regular trading hour
                --until "20190101 00:00:00" // end date time
                --since "20100101 00:00:00" // begin date time
                --barsize "1 min" // size of bar
                --duration "1 W" // duration of history data
                --exchange "SMART:ISLAND" // name of exchange
                --output ~/MarketData/ // path of output files
                --symbols symbols.symbols // input symbols file
                --sleep 20 // sleep for xx seconds between requests
                --day-start 0930 // set HHMM as start of day, do not request data earlier than this time
                --append // append new data to old file
                --clientID // custom client ID
                """
                self.help = true
                print(help)
            case "--host":
                if index+1<arg_array.count {self.host = arg_array[index+1]}
                argValue[index+1] = true
            case "--port":
                if index+1<arg_array.count {
                    if let p = Int(arg_array[index+1]) {
                        self.port = UInt32(p)
                    }
                }
                argValue[index+1] = true
            case "--rth":
                if index+1<arg_array.count {
                    if let p = Int(arg_array[index+1]) {
                        self.rth = p == 0 ? 0 : 1
                    } else {
                        self.rth = arg_array[index+1].lowercased() == "true" ? 1 : 0
                    }
                }
                argValue[index+1] = true
            case "--until":
                if index+1<arg_array.count {
                    self.untilDatetime = arg_array[index+1]
                }
                argValue[index+1] = true
            case "--since":
                if index+1<arg_array.count {
                    self.sinceDatetime = arg_array[index+1]
                }
                argValue[index+1] = true
            case "--barsize":
                if index+1<arg_array.count {
                    self.barsize = arg_array[index+1]
                }
                argValue[index+1] = true
            case "--duration":
                if index+1<arg_array.count {
                    self.duration = arg_array[index+1]
                }
                argValue[index+1] = true
            case "--exchange":
                if index+1<arg_array.count {
                    let ex = arg_array[index+1]
                    let exs = ex.components(separatedBy: ":")
                    if exs.count >= 2 { self.primaryEx = exs[1] }
                    if exs.count >= 1 { self.exchange = exs[0] }
                }
                argValue[index+1] = true
            case "--output":
                if index+1<arg_array.count { self.outputDir = arg_array[index+1] }
                argValue[index+1] = true
            case "--symbols":
                if index+1<arg_array.count {
                    let fileCont = try! String(contentsOfFile: arg_array[index+1], encoding: String.Encoding.utf8)
                    let arr = fileCont.components(separatedBy: "\n")
                    for sym in arr {
                        print(sym)
                        if !sym.hasPrefix("#") {
                            self.tickers.append(sym)
                        }
                    }
                }
                argValue[index+1] = true
            case "--sleep":
                if index+1<arg_array.count {
                    let sd = NSString(string: arg_array[index+1]).doubleValue
                    if sd != 0 {
                        self.sleepInterval = sd
                    }
                }
                argValue[index+1] = true
            case "--day-start":
                if index+1<arg_array.count {
                    self.dayStart = arg_array[index+1]
                }
                argValue[index+1] = true
            case "--append":
                self.append = true
            case "--no-normal-filename":
                self.normal_filename = false
            case "--clientID":
                if index+1<arg_array.count {
                    let iv = Int(arg_array[index+1])
                    if iv != nil {
                        self.clientID = iv!
                    }
                }
                argValue[index+1] = true
            default:
                if argValue[index] == false {
                    self.tickers.append(arg)
                }
            }
            index += 1
        }
    }
    
    func printConf() {
        print("Configuration:\nHost: \(host)")
        print("Client ID: \(clientID)")
        print("Port: \(port)")
        print("Output: \(outputDir)")
        print("Append mode: \(append)")
        print("==============================")
        print("Fetching tickers: \(tickers)")
        print("Start date: \(sinceDatetime) (Exchange local timezone)")
        print("End date: \(untilDatetime) (Exchange local timezone)")
        print("Exchange: \(exchange) - \(primaryEx)")
        print("Duration: \(duration)")
        print("Barsize: \(barsize)")
        print("Day start: \(dayStart)")
    }
}

class HDDUtil {

    class func tsToStr(timestamp: Int64, api: Bool, tz_name: String) -> String {
        let time = NSDate(timeIntervalSince1970: Double(timestamp))
        let fmt = DateFormatter()
        fmt.timeZone = TimeZone(identifier: tz_name)!
        fmt.dateFormat = api ? "yyyyMMdd HH:mm:ss" : "yyyy-MM-dd\tHH:mm:ss"
        return fmt.string(from: time as Date)
    }
    
    class func equalsDaystart(timestamp: Int64, tz_name: String, daystart: String, datestart: String) -> Bool {
        let time = NSDate(timeIntervalSince1970: Double(timestamp))
        let fmt = DateFormatter()
        fmt.timeZone = TimeZone(identifier: tz_name)!
        fmt.dateFormat = "HHmmss"
        let fmtd = DateFormatter()
        fmtd.timeZone = TimeZone(identifier: tz_name)!
        fmtd.dateFormat = "yyyyMMdd"
        let timeEq = fmt.string(from: time as Date) == daystart
        let date = fmtd.string(from: time as Date) == datestart
        return date && timeEq
    }
    
    class func fastStrToTS(timestamp: String, tz_name: String) -> Int64 {
        let year = Int((timestamp as NSString).substring(with: NSRange(location: 0, length: 4)))
        let month = Int((timestamp as NSString).substring(with: NSRange(location: 5, length: 2)))
        let day = Int((timestamp as NSString).substring(with: NSRange(location: 8, length: 2)))
        let hour = Int((timestamp as NSString).substring(with: NSRange(location: 11, length: 2)))
        let minute = Int((timestamp as NSString).substring(with: NSRange(location: 14, length: 2)))
        let second = Int((timestamp as NSString).substring(with: NSRange(location: 17, length: 2)))
        let components = NSDateComponents()
        components.year = year!
        components.month = month!
        components.day = day!
        components.hour = hour!
        components.minute = minute!
        components.second = second!
        components.timeZone = NSTimeZone(name: tz_name) as TimeZone?
        let cal = NSCalendar.current
        let dt = cal.date(from: components as DateComponents)
        return Int64(dt!.timeIntervalSince1970)
    }
    
    class func strToTS(timestamp: String, api: Bool, tz_name: String) -> Int64 {
        let fmt = DateFormatter()
        fmt.timeZone = TimeZone(identifier: tz_name)!
        fmt.dateFormat = api ? "yyyyMMdd HH:mm:ss" : "yyyy-MM-dd\tHH:mm:ss"
        if let dt = fmt.date(from: timestamp) {
            return Int64(dt.timeIntervalSince1970)
        }
        return -1
    }
    
    class func parseBarsize(sbarsize: String) -> Int {
        let cmps = sbarsize.components(separatedBy: " ")
        if cmps.count == 2 {
            var base = 1
            if cmps[1].hasPrefix("min") { base = 60 }
            else if cmps[1].hasPrefix("hour") { base = 60 * 60 }
            else if cmps[1].hasPrefix("day") { base = 60 * 60 * 24 }
            if let v = Int(cmps[0]) {
                return v * base
            }
        }
        return -1
    }
}

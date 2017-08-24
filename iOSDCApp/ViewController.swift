//
//  ViewController.swift
//  iOSDCApp
//
//  Created by sonson on 2017/08/24.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit

var starttime:timeval = timeval(tv_sec: 0, tv_usec: 0)

func tic() {
    gettimeofday(&starttime, nil)
}

func toc() {
    var endtime:timeval = timeval(tv_sec: 0, tv_usec: 0)
    gettimeofday(&endtime, nil)
    let t = (Double(endtime.tv_sec) * Double(1000) + Double(endtime.tv_usec) / Double(1000)) - (Double(starttime.tv_sec) * Double(1000) + Double(starttime.tv_usec) / Double(1000))
    print("\(t)[msec]")
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        testLinePerformance()
        testLinePerformance_NSString()
        
        testRemoveTagPerformance()
        testRemoveTagPerformance_NSString()
        
        testEscapePerformance()
        testEscapePerformance_GoogleToolbox()
        
        testUnescapePerformance()
        testUnescapePerformance_GoogleToolbox()
    }
    
    let testCount = 1000
    let stringToBeUnescaped = "&quot;&amp;&amp;apos;&lt;&gt;&OElig;&oelig;&Scaron;&scaron;&Yuml;&circ;&tilde;&ensp;&emsp;&thinsp;&zwnj;&zwj;&lrm;&rlm;&ndash;&mdash;&lsquo;&rsquo;&sbquo;&ldquo;&rdquo;&bdquo;&dagger;&Dagger;&permil;&lsaquo;&rsaquo;&euro;hoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahoghoge&copy;a&copy;aaaaa&copy;aaaaahog"
    let stringToBeEscaped = "\"&&apos;<>ŒœŠšŸˆ˜   ‌‍‎‏–—‘’‚“”„†‡‰‹›€hoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahoghoge©a©aaaaa©aaaaahog"
    
    func testLinePerformance() {
        print(#function)
        do {
            guard let url = Bundle.main.url(forResource: "subject.txt", withExtension: nil) else { return }
            let data = try Data(contentsOf: url)
            var n = 0
            tic()
            for _ in 0..<self.testCount {
                let a = data.lines()
                n = a.count
            }
            toc()
        } catch {
            print(error)
        }
    }
    
    func testLinePerformance_NSString() {
        print(#function)
        do {
            guard let url = Bundle.main.url(forResource: "subject.txt", withExtension: nil) else { return }
            let data = try Data(contentsOf: url)
            tic()
            var n = 0
            for _ in 0..<self.testCount {
                guard let string = String(data: data, encoding: .shiftJIS) else { return }
                let a = string.components(separatedBy: "\n")
                n = a.count
            }
            toc()
        } catch {
            print(error)
        }
    }
    
    func testRemoveTagPerformance() {
        print(#function)
        do {
            guard let url = Bundle.main.url(forResource: "html.txt", withExtension: nil) else { return }
            let data = try Data(contentsOf: url)
            tic()
            for _ in 0..<self.testCount {
                var n = ""
                guard let string = String(data: data, encoding: .utf8) else { return }
                n = string.removingHTMLTags
            }
            toc()
        } catch {
        }
    }
    
    func testRemoveTagPerformance_NSString() {
        print(#function)
        do {
            guard let url = Bundle.main.url(forResource: "html.txt", withExtension: nil) else { return }
            let data = try Data(contentsOf: url)
            tic()
            var n = ""
            for _ in 0..<self.testCount {
                guard let string = String(data: data, encoding: .utf8) else { return }
                n = string.eliminatingHTMLTag()
            }
            toc()
        } catch {
        }
    }
    
    func testEscapePerformance() {
        print(#function)
        var str = ""
        tic()
        for _ in 0..<self.testCount {
            str = self.stringToBeEscaped.unescapeHTML
        }
        toc()
    }
    
    func testEscapePerformance_GoogleToolbox() {
        print(#function)
        var str = ""
        tic()
        for _ in 0..<self.testCount {
            str = self.stringToBeEscaped.gtm_stringByEscapingForHTML()
        }
        toc()
    }
    
    func testUnescapePerformance() {
        print(#function)
        var str = ""
        tic()
        for _ in 0..<self.testCount {
            str = self.stringToBeUnescaped.escapeHTML
        }
        toc()
    }
    
    func testUnescapePerformance_GoogleToolbox() {
        print(#function)
        var str = ""
        tic()
        for _ in 0..<self.testCount {
            str = self.stringToBeUnescaped.gtm_stringByUnescapingFromHTML()
        }
        toc()
    }
    
}


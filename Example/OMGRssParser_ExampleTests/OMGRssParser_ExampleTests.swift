//
//  OMGRssParser_ExampleTests.swift
//  OMGRssParser_ExampleTests
//
//  Created by 林涛 on 2016/12/17.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import XCTest

import OMGRssParser

class OMGRssParser_ExampleTests: XCTestCase {
    
    let rssParser = OMGRssParser(urlStr: "http://ericasadun.com/feed/")
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Parse_Is_Success()   {
        let expectatio = expectation(description: "Parse Of Test Expectation")
        rssParser.parse { (info, error) in
            XCTAssertNotNil(info)
            XCTAssertNil(error)
            expectatio.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_Title_Is_EricaSadun()  {
        let expectatio = expectation(description: "Parse Of Test Expectation")
        rssParser.parse { (info, error) in
            XCTAssertEqual(info?.title, "Erica Sadun")
            expectatio.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_Parse_Six_Feed()  {
        var feeds = [OMGFeedInfo]()
        let expectatio = expectation(description: "Parse Of Test Expectation")
        let rss = ["http://ericasadun.com/feed/",
                   "https://littlebitesofcocoa.com/rss",
                   "http://www.swiftandpainless.com/feed.xml",
                   "http://developer.apple.com/swift/blog/news.rss",
                   "http://masilotti.com/atom.xml",
                   "http://appventure.me/rss-feed"]
        
        for url in rss {
            let rssParser = OMGRssParser(urlStr: url)
            rssParser.parse(completionHandler: { (info, error) in
                guard let info = info else {return}
                feeds.append(info)
                if feeds.count == 6 {
                    expectatio.fulfill()
                }
            })
        }
        
        waitForExpectations(timeout: 60, handler: nil)
    }
    
}

//
//  LempelTests.swift
//  LempelTests
//
//  Created by Benedikt Terhechte on 17/12/15.
//  Copyright © 2015 Benedikt Terhechte. All rights reserved.
//

import XCTest
@testable import Lempel

class LempelTests: XCTestCase {
    
    var testData: NSData!
    
    override func setUp() {
        super.setUp()
        let bundle = NSBundle(forClass: self.classForCoder)
        let file = bundle.URLForResource("archive", withExtension: "txt.gz")
        self.testData = NSData(contentsOfURL: file!)!
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        do {
            let newData = try self.testData.decompressGzip()
            XCTAssertNotNil(newData)
            let converted = String(data: newData, encoding: NSUTF8StringEncoding)
            XCTAssertNotNil(converted)
            let convertedString = (converted! as NSString)
            XCTAssertNotNil(convertedString)
            let checkString = NSString(string: "From austinzheng at gmail.com  Mon Dec 14 00:34:29 2015\nFrom: austinzhe")
            XCTAssertEqual(checkString.substringToIndex(32), convertedString.substringToIndex(32))
            
        } catch let error {
            print("error: \(error)")
            XCTAssertTrue(false)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

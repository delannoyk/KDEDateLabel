//
//  KDEDateLabelExampleTests.swift
//  KDEDateLabelExampleTests
//
//  Created by Kevin DELANNOY on 23/12/14.
//  Copyright (c) 2014 Kevin Delannoy. All rights reserved.
//

import UIKit
import XCTest
import KDEDateLabelExample

class KDEDateLabelExampleTests: XCTestCase {
    let date = NSDate()

    func testDateLabel() {
        var label = KDEDateLabel()
        label.date = self.date
        label.dateFormatTextBlock = { (date) in
            return "\(Int(date.timeIntervalSinceNow))"
        }

        XCTAssert(label.text == "\(Int(date.timeIntervalSinceNow))", "Label's text should be \(Int(date.timeIntervalSinceNow))")
    }
}

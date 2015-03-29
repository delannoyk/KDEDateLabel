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

    func testAutoUpdate() {
        //Setting initial text
        let label = KDEDateLabel()
        label.date = self.date
        label.dateFormatTextBlock = { date in
            return "\(Int(date.timeIntervalSinceNow))"
        }
        XCTAssert(label.text == "\(Int(self.date.timeIntervalSinceNow))", "Label's text isn't correct")

        //Sleeping 1s to check if text auto-updated
        let expectation = self.expectationWithDescription("Waiting for auto-update")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            sleep(1)
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                XCTAssert(label.text == "\(Int(self.date.timeIntervalSinceNow))", "Label's text isn't correct")

                expectation.fulfill()
            })
        })

        self.waitForExpectationsWithTimeout(2, handler: { (error) -> Void in
        })
    }
}

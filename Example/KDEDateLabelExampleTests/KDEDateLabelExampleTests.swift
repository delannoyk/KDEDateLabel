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
            sleep(2)

            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                let expected = "\(Int(self.date.timeIntervalSinceNow))"
                let text = label.text
                XCTAssert(text == expected, "Label's text isn't correct: \(text) when it should be \(expected)")

                expectation.fulfill()
            })
        })

        self.waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
        })
    }


    func testRefreshFrequencyChange() {
        var value = 0

        KDEDateLabel.refreshFrequency = 0.5

        //Setting initial text
        let label = KDEDateLabel()
        label.date = self.date
        label.dateFormatTextBlock = { date in
            value++
            return "\(Int(date.timeIntervalSinceNow))"
        }

        //Sleeping 1s to check if text auto-updated
        let expectation = self.expectationWithDescription("Waiting for auto-update")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let start = value
            sleep(1)
            let updatedTimes = value - start

            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                XCTAssert(updatedTimes == 2, "Label should have updated 2 times and it has \(updatedTimes) times")

                expectation.fulfill()
            })
        })

        self.waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
        })
    }
}

//
//  KDEDateLabel.swift
//  KDEDateLabelExample
//
//  Created by Kevin DELANNOY on 23/12/14.
//  Copyright (c) 2014 Kevin Delannoy. All rights reserved.
//

import UIKit

// MARK: - KDEWeakReferencer
////////////////////////////////////////////////////////////////////////////////

private class KDEWeakReferencer<T: NSObject>: NSObject {
    private(set) weak var value: T?

    init(value: T) {
        self.value = value
        super.init()
    }

    private override func isEqual(object: AnyObject?) -> Bool {
        return value?.isEqual(object) ?? false
    }

    private override var hash: Int {
        return value?.hash ?? 0
    }

    private override var hashValue: Int {
        return value?.hashValue ?? 0
    }
}

////////////////////////////////////////////////////////////////////////////////


// MARK: - KDEDateLabelsHolder
////////////////////////////////////////////////////////////////////////////////

class KDEDateLabelsHolder: NSObject {
    private var dateLabels = [KDEWeakReferencer<KDEDateLabel>]()
    private var timer: NSTimer?

    private static var instance = KDEDateLabelsHolder()

    private override init() {
        super.init()
        self.createNewTimer()
    }


    private func addReferencer(referencer: KDEWeakReferencer<KDEDateLabel>) {
        self.dateLabels.append(referencer)
    }

    private func removeReferencer(referencer: KDEWeakReferencer<KDEDateLabel>) {
        if let index = self.dateLabels.indexOf(referencer) {
            self.dateLabels.removeAtIndex(index)
        }
        self.dateLabels = self.dateLabels.filter { $0.value != nil }
    }


    private func createNewTimer() {
        self.timer?.invalidate()

        self.timer = NSTimer(timeInterval: KDEDateLabel.refreshFrequency,
            target: self,
            selector: "timerTicked:",
            userInfo: nil,
            repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }


    @objc private func timerTicked(_: NSTimer) {
        for referencer in self.dateLabels {
            referencer.value?.updateText()
        }
    }
}

////////////////////////////////////////////////////////////////////////////////


// MARK: - KDEDateLabel
////////////////////////////////////////////////////////////////////////////////

public class KDEDateLabel: UILabel {
    private lazy var holder: KDEWeakReferencer<KDEDateLabel> = {
        return KDEWeakReferencer<KDEDateLabel>(value: self)
    }()


    // MARK: Initialization
    public convenience init() {
        self.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    private func commonInit() {
        KDEDateLabelsHolder.instance.addReferencer(self.holder)
    }

    // MARK: Deinit
    deinit {
        KDEDateLabelsHolder.instance.removeReferencer(self.holder)
    }


    // MARK: Configuration
    public static var refreshFrequency: NSTimeInterval = 0.2 {
        didSet {
            KDEDateLabelsHolder.instance.createNewTimer()
        }
    }


    // MARK: Date & Text updating
    public var date: NSDate? = nil {
        didSet {
            self.updateText()
        }
    }

    public var dateFormatTextBlock: ((date: NSDate) -> String)? {
        didSet {
            self.updateText()
        }
    }

    public var dateFormatAttributedTextBlock: ((date: NSDate) -> NSAttributedString)? {
        didSet {
            self.updateText()
        }
    }

    private func updateText() {
        if let date = date {
            if let dateFormatAttributedTextBlock = self.dateFormatAttributedTextBlock {
                self.attributedText = dateFormatAttributedTextBlock(date: date)
            }
            else if let dateFormatTextBlock = self.dateFormatTextBlock {
                self.text = dateFormatTextBlock(date: date)
            }
            else {
                self.text = "\(Int(fabs(date.timeIntervalSinceNow)))s ago"
            }
        }
        else {
            self.text = nil
        }
    }
}

////////////////////////////////////////////////////////////////////////////////

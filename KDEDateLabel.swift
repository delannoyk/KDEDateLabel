//
//  KDEDateLabel.swift
//  KDEDateLabelExample
//
//  Created by Kevin DELANNOY on 23/12/14.
//  Copyright (c) 2014 Kevin Delannoy. All rights reserved.
//

import UIKit

// MARK: - WeakReferencer

private class WeakReferencer<T: NSObject>: NSObject {
    // MARK: Properties

    private(set) weak var value: T?
    private let _hash: Int
    private let _hashValue: Int

    // MARK: Initialization

    init(value: T) {
        self.value = value
        self._hash = value.hash
        self._hashValue = value.hashValue
        super.init()
    }

    // MARK: NSObject override

    override func isEqual(_ object: Any?) -> Bool {
        return value?.isEqual(object) ?? false
    }

    override var hash: Int {
        return _hash
    }

    override var hashValue: Int {
        return _hashValue
    }
}

// MARK: - DateLabelsHolder

private class DateLabelsHolder: NSObject {
    // MARK: Singleton

    static var instance = DateLabelsHolder()

    // MARK: Properties

    private var dateLabels = [WeakReferencer<DateLabel>]()
    private var timer: Timer?

    // MARK: Initialization

    override init() {
        super.init()
        createNewTimer()
    }

    // MARK: Label registration

    func addReferencer(_ referencer: WeakReferencer<DateLabel>) {
        dateLabels.append(referencer)
    }

    func removeReferencer(_ referencer: WeakReferencer<DateLabel>) {
        if let index = dateLabels.index(of: referencer) {
            dateLabels.remove(at: index)
        }
        dateLabels = dateLabels.filter { $0.value != nil }
    }

    // MARK: Timer

    func createNewTimer() {
        timer?.invalidate()

        let newTimer = Timer(timeInterval: DateLabel.refreshFrequency,
            target: self,
            selector: #selector(refreshLabels(_:)),
            userInfo: nil,
            repeats: true)
        timer = newTimer
        RunLoop.main.add(newTimer, forMode: .commonModes)
    }

    @objc private func refreshLabels(_: Any) {
        dateLabels.forEach { $0.value?.updateText() }
    }
}

// MARK: - DateLabel

open class DateLabel: UILabel {
    // MARK: Properties

    private lazy var holder: WeakReferencer<DateLabel> = {
        return WeakReferencer<DateLabel>(value: self)
    }()

    // MARK: Initialization

    public convenience init() {
        self.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        DateLabelsHolder.instance.addReferencer(holder)
    }

    // MARK: Deinit

    deinit {
        DateLabelsHolder.instance.removeReferencer(holder)
    }

    // MARK: Configuration

    open static var refreshFrequency: TimeInterval = 0.2 {
        didSet {
            DateLabelsHolder.instance.createNewTimer()
        }
    }

    // MARK: Date & Text updating

    open var date: Date? = nil {
        didSet {
            updateText()
        }
    }

    open var dateFormatTextBlock: ((_ date: Date) -> String)? {
        didSet {
            updateText()
        }
    }

    open var dateFormatAttributedTextBlock: ((_ date: Date) -> NSAttributedString)? {
        didSet {
            updateText()
        }
    }

    fileprivate func updateText() {
        if let date = date {
            if let dateFormatAttributedTextBlock = dateFormatAttributedTextBlock {
                attributedText = dateFormatAttributedTextBlock(date)
            }
            else if let dateFormatTextBlock = dateFormatTextBlock {
                text = dateFormatTextBlock(date)
            }
            else {
                text = "\(Int(fabs(date.timeIntervalSinceNow)))s ago"
            }
        }
        else {
            text = nil
        }
    }
}

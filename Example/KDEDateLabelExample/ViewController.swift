//
//  ViewController.swift
//  KDEDateLabelExample
//
//  Created by Kevin DELANNOY on 23/12/14.
//  Copyright (c) 2014 Kevin Delannoy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var label1: KDEDateLabel!
    @IBOutlet private weak var label2: KDEDateLabel!
    @IBOutlet private weak var label3: KDEDateLabel!


    //MARK: View controller's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.label1.date = NSDate()
        self.label2.date = NSDate(timeIntervalSinceNow: -100)
        self.label3.date = NSDate(timeIntervalSinceNow: -1000)
    }
}


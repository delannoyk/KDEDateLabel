//
//  ViewController.swift
//  KDEDateLabelExample
//
//  Created by Kevin DELANNOY on 23/12/14.
//  Copyright (c) 2014 Kevin Delannoy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    let dates = [NSDate(), NSDate(timeIntervalSinceNow: -10), NSDate(timeIntervalSinceNow: -60)]

    //MARK: UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell") as! TableViewCell
        cell.labelDate.date = dates[indexPath.row]
        return cell
    }
}


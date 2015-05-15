//
//  TableViewCell.swift
//  KDEDateLabelExample
//
//  Created by Kevin DELANNOY on 15/05/15.
//  Copyright (c) 2015 Kevin Delannoy. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet private(set) weak var imageViewAuthorAvatar: UIImageView!
    @IBOutlet private(set) weak var labelAuthor: UILabel!
    @IBOutlet private(set) weak var labelContent: UILabel!
    @IBOutlet private(set) weak var labelDate: KDEDateLabel!
}

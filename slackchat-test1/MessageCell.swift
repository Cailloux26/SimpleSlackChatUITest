//
//  MessageCell.swift
//  slackchat-test1
//
//  Created by koichi tanaka on 6/28/16.
//  Copyright © 2016 koichi tanaka. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    static let REUSE_ID = "MessageCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(message :MessageModel) {
        self.nameLabel.text = message.name
        self.bodyLabel.text = message.body
    }
    
}

//
//  MessageModel.swift
//  slackchat-test1
//
//  Created by koichi tanaka on 6/25/16.
//  Copyright © 2016 koichi tanaka. All rights reserved.
//

import Foundation
import Firebase

struct MessageModel {
    var messageId: String?
    var name: String
    var body: String
    
    init(snapshot: FDataSnapshot){
        messageId = snapshot.key
        name = snapshot.value["name"] as! String
        body = snapshot.value["body"] as! String
    }
    
    init(name: String, body: String){
        self.name = name
        self.body = body
    }
}
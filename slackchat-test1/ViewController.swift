//
//  ViewController.swift
//  slackchat-test1
//
//  Created by koichi tanaka on 6/25/16.
//  Copyright © 2016 koichi tanaka. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa
import SlackTextViewController
import FirebaseRxSwiftExtensions

class ViewController: SLKTextViewController {

    var messageModels : [MessageModel] = [MessageModel]()
    var isInitialLoad = true
    var disposeBag = DisposeBag()
    var messagesRef: Firebase!
    var pressedRightButtonSubject: PublishSubject<String> = PublishSubject()
    var name = "Koichi" // your name
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    override class func tableViewStyleForCoder(decoder: NSCoder) -> UITableViewStyle {
        return .Plain
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView!.registerNib(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: MessageCell.REUSE_ID)
        inverted = true
        
        // Change the url to yours.
        messagesRef = Firebase(url: "https://flamingpants-demo.firebaseio.com/").childByAppendingPath("messages")
        
        messagesRef.rx_observe(.ChildAdded)
            .map { snapshot in
                return MessageModel(snapshot: snapshot) }
            .subscribeNext { (messageModel: MessageModel) in
                self.messageModels.insert(messageModel, atIndex: 0)
                if self.isInitialLoad == false {
                    self.tableView?.beginUpdates()
                    self.tableView?.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
                    self.tableView?.endUpdates()
                }
            }
            .addDisposableTo(disposeBag)
        
        messagesRef.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) in
            self.tableView?.reloadData()
            self.isInitialLoad = false
        }
        
        pressedRightButtonSubject
            .flatMap { bodyText -> Observable<Firebase> in
                let name = self.name
                return self.messagesRef.childByAutoId().rx_setValue(["name": name, "body": bodyText])
            }
            .subscribeNext { (newMessageReference:Firebase) -> Void in
                print("a new message was commited to firebase.")
            }
            .addDisposableTo(disposeBag)
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageModels.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(MessageCell.REUSE_ID, forIndexPath: indexPath) as! MessageCell

        print(cell)
        
        let messageModelAtIndexPath = messageModels[indexPath.row]
        
        cell.setCell(messageModelAtIndexPath)
        
        cell.transform = tableView.transform //very important don't forget this
        return cell
    }
    
    override func didPressRightButton(sender: AnyObject?) {
        pressedRightButtonSubject.onNext(textView.text)
        super.didPressRightButton(sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


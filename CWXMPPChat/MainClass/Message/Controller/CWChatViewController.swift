//
//  CWChatViewController.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/28.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

///消息
class CWChatViewController: CWBaseMessageViewController {

    let queue = CWMessageDispatchQueue()
    
    /// 消息数据数组
    var messageList = [CWMessageProtocol]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.rowHeight = 64.0
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息";
        setupUI()
    }
    

    func setupUI() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(tableView)
        //测试发送消息
        let rightBarItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(sendMessage))
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func sendMessage() {
        let random = arc4random_uniform(10000)
        let to = "jerry"+"@chenweiim.com";

        let message = CWMessageModel()
        message.messageSendId = to
        message.messageType = .Text
        message.content = "\(random)\(String.UUIDString())"
        
        queue.sendMessage(message)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CWChatViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let message = messageList[indexPath.row]
        cell.textLabel?.text = message.content
        return cell
    }
    
}

extension CWChatViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}


// MARK: - CWMessageCrackerDelegate
extension CWChatViewController {
    
    //获取到消息
    override func receiveNewMessage(message: CWMessageModel) {
        if message.composing == false && message.content == nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.title = "消息"
            }
        } else if message.composing == true {
            dispatch_async(dispatch_get_main_queue()) {
                self.title = "对方正在输入中...."
            }
        } else {
            messageList.append(message)
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
 
    }
}

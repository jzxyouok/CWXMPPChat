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
    var toId: String?
    /// 消息数据数组
    var messageList = [CWMessageModel]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息";
        setupUI()
        
        registerCell()
    }
    

    func setupUI() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(tableView)
        //测试发送消息
        let rightBarItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(sendMessage))
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func registerCell() {
        
        tableView.registerClass(CWBaseMessageCell.self, forCellReuseIdentifier: CWMessageType.None.reuseIdentifier())
        tableView.registerClass(CWTextMessageCell.self, forCellReuseIdentifier: CWMessageType.Text.reuseIdentifier())
        tableView.registerClass(CWImageMessageCell.self, forCellReuseIdentifier: CWMessageType.Image.reuseIdentifier())
        tableView.registerClass(CWTimeMessageCell.self, forCellReuseIdentifier: CWMessageType.Time.reuseIdentifier())
    }
    
    func sendMessage() {
        let random = arc4random_uniform(10000)

        let message = CWMessageModel()
        message.messageSendId = toId
        message.messageOwnerType = .Myself
        message.chatType = .Single
        message.messageType = .Text
        message.content = "\(random)\(String.UUIDString())"
        sendAndShowMessage(message)
    }
    
    /**
     发送并显示消息
     
     - parameter message: 消息的实体类
     */
    func sendAndShowMessage(message: CWMessageModel) {
        queue.sendMessage(message)
    
        insertMessageToList(message)
    }
    
    func insertMessageToList(message: CWMessageModel) {
        messageList.append(message)
        tableView.reloadData()
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message = messageList[indexPath.row]
        return message.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        //configure
        let message = messageList[indexPath.row]
        if message.messageType == .Time {

            let cell = tableView.dequeueReusableCellWithIdentifier(message.messageType.reuseIdentifier(), forIndexPath: indexPath) as! CWTimeMessageCell
            
            return cell

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(message.messageType.reuseIdentifier(), forIndexPath: indexPath) as! CWBaseMessageCell
            cell.setMessage(message)
            return cell
        }
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

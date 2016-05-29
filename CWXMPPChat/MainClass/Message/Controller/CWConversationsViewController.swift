//
//  CWConversationsViewController.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/28.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

///会话列表
class CWConversationsViewController: UIViewController {

    let manager = CWXMPPManager.shareXMPPManager

    var conversationList = [CWConversationModel]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.rowHeight = 64.0
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        registerCellClass()
        addDefaultData()
        
        manager.connectProcess()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
        self.title = "微信"
        self.view.addSubview(self.tableView)
        
        //测试发送消息
        let rightBarItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(sendMessage))
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func sendMessage() {
        let random = arc4random_uniform(10000)
        let to = "tom"+"@chenweiim.com";
        manager.messageTransmitter.sendMessage(String(random), toId: to, messageId: String.UUIDString())
    }
    
    func addDefaultData() {

        let model1 = CWConversationModel()
        model1.partnerID = "tom@chenweiim.com"
        model1.content = "hello"
        model1.conversationDate = NSDate()
        
        let model2 = CWConversationModel()
        model2.partnerID = "jerry@chenweiim.com"
        model2.content = "world"
        model2.conversationDate = NSDate()

        conversationList.append(model1)
        conversationList.append(model2)

        self.tableView.reloadData()
    }
    
    func updateFriendList() {
        self.tableView.reloadData()
    }
    
    func registerCellClass() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateFriendList), name: CWFriendsNeedReloadNotification, object: nil)

        self.tableView.registerClass(CWConversationCell.self, forCellReuseIdentifier: "\(CWConversationCell.self)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}



//MARK: UITableViewDelegate
extension CWConversationsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteTitle = "删除"
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: deleteTitle) { (action:UITableViewRowAction, indexPath) in
           
            //获取当前model
            _ = self.conversationList[indexPath.row]
            //数组中删除
            self.conversationList.removeAtIndex(indexPath.row)
            //从数据库中删除

            //删除
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        let actionTitle = "标记已读"
        let moreAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: actionTitle) { (action:UITableViewRowAction, indexPath) in
            
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            
        }
        return [deleteAction,moreAction]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    
}


//MARK: UITableViewDataSource
extension CWConversationsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversationList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("\(CWConversationCell.self)", forIndexPath: indexPath) as! CWConversationCell
        cell.conversationModel = self.conversationList[indexPath.row]
        return cell
    }
}



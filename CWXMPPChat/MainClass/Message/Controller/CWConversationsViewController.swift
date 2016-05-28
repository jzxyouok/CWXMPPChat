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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "微信"
        setupUI()
        
        manager.connectProcess()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
        //测试发送消息
        let rightBarItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(CWConversationsViewController.sendMessage))
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func sendMessage() {
        
        let random = arc4random_uniform(10000)
        let to = "jerry"+"@chenweiim.com";
        manager.messageTransmitter.sendMessage(String(random), toId: to, messageId: String.UUIDString())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

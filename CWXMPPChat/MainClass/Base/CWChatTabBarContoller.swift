//
//  CWChatTabBarController.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/28.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

class CWChatTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewContollers()
        // Do any additional setup after loading the view.
    }
    
    func setupViewContollers() {
        
        let friendsVC = CWFriendsViewController()
        friendsVC.tabBarItem.title = "通讯录"
        friendsVC.tabBarItem.selectedImage = UIImage(named: "tabbar_contactsHL")
        friendsVC.tabBarItem.image = UIImage(named: "tabbar_contacts")
        
        let friendsNVC = CWChatNavigationController(rootViewController: friendsVC)
        
        
        let chatListVC = CWChatListViewController()
        chatListVC.tabBarItem.title = "消息"
        chatListVC.tabBarItem.selectedImage = UIImage(named: "tabbar_mainframeHL")
        chatListVC.tabBarItem.image = UIImage(named: "tabbar_mainframe")
        
        let chatListNVC = CWChatNavigationController(rootViewController: chatListVC)
        
        self.viewControllers = [chatListNVC,friendsNVC]
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

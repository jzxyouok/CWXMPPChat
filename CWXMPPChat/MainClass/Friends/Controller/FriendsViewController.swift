//
//  FriendsViewController.swift
//  CWChat
//
//  Created by chenwei on 16/4/5.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

class CWFriendsViewController: UIViewController {

    var userList = [ChatUserModel]()
    lazy var tableView:UITableView = {
        let frame = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height-Screen_NavigationHeight)
        let tableView = UITableView(frame: frame, style: .Plain)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(ChatFriendCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultData()
        setupUI()
    }
    
    func setupUI() {
        self.title = "通讯录"
        self.view.addSubview(tableView)
    }
    
    func setDefaultData() {
        
        let nameArray = ["李灵黛","冷文卿","阴露萍","柳兰歌","秦水支",
                         "李念儿","文彩依","柳婵诗","丁玲珑","凌霜华","景茵梦"]
        
        for i in 10...20 {
            let user = ChatUserModel()
            user.avatarPath = "\(i).jpg"
            user.userId = "100\(i)"
            user.username = nameArray[i-10]
            userList.append(user)
        }
        
    }
    
}

extension CWFriendsViewController:UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ChatFriendCell
        cell.setUserModel(userList[indexPath.row])
        return cell
    }

}


extension CWFriendsViewController:UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
}
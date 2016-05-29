//
//  CWFriendsViewController.swift
//  CWChat
//
//  Created by chenwei on 16/4/5.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

class CWFriendsViewController: UIViewController {

    //用户列表
    var userList = [CWChatUserModel]()
    
    lazy var searchController: CWSearchController = {
        let searchController = CWSearchController(searchResultsController: self.searchResultController)
        searchController.searchResultsUpdater = self.searchResultController
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.delegate = self
        searchController.showVoiceButton = true
        return searchController
    }()
    
    //搜索结果
    var searchResultController:CWFriendSearchViewController = {
        let searchResultController = CWFriendSearchViewController()
        return searchResultController
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        tableView.backgroundColor = UIColor.tableViewBackgroundColorl()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(ChatFriendCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = self.searchController.searchBar
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateFriendList()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CWFriendsViewController.updateFriendList), name: CWFriendsNeedReloadNotification, object: nil)
    }
    
    func setupUI() {
        self.title = "通讯录"
        self.view.addSubview(tableView)
        self.view.backgroundColor = UIColor.tableViewBackgroundColorl()
    }

    func updateFriendList() {
        self.userList = FriendsHelper.shareFriendsHelper.userList
        self.tableView.reloadData()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension CWFriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ChatFriendCell
        cell.userModel = userList[indexPath.row]
        return cell
    }

}


extension CWFriendsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
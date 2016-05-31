//
//  CWNewMessageSettingViewController.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/31.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

class CWNewMessageSettingViewController: CWSettingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "新消息通知"
        
        let helper = CWNewMessageSettingHelper()
        self.settingDataSource = helper.messageSettingData
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

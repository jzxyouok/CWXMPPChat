//
//  CWMineSettingViewController.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/31.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

class CWMineSettingViewController: CWSettingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置"

        let helper = CWMineSettingHelper()
        self.settingDataSource = helper.mineSettingData
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

extension CWMineSettingViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        if indexPath.section == 1 {
            let messageSettingVC = CWNewMessageSettingViewController()
            self.navigationController?.pushViewController(messageSettingVC, animated: true)
        }
        
        else if indexPath.section == 2 {
            let privacySettingVC = CWPrivacySettingViewController()
            self.navigationController?.pushViewController(privacySettingVC, animated: true)
            
        }
        
    }
}
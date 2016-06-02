//
//  CWMineSettingViewController.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/31.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

class CWMineSettingViewController: CWSettingViewController {

    var viewControllerArray = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置"

        viewControllerArray.appendContentsOf(<#T##newElements: CollectionType##CollectionType#>)
        
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
            
            if indexPath.row == 0 {
                let messageSettingVC = CWNewMessageSettingViewController()
                self.navigationController?.pushViewController(messageSettingVC, animated: true)
            } else if indexPath.row == 1 {
                let privacySettingVC = CWPrivacySettingViewController()
                self.navigationController?.pushViewController(privacySettingVC, animated: true)
            } else if indexPath.row == 2 {
                
                let commonSettingVC = CWCommonSettingViewController()
                self.navigationController?.pushViewController(commonSettingVC, animated: true)
            }
            
        }
        
        if indexPath.section == 2 {
            
        }

        
    }
}
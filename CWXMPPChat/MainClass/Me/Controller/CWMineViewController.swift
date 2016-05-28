//
//  CWMineViewController.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/28.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

class CWMineViewController: CWMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我"
        
        let mineHelper = CWMineHelper()
        self.dataSource = mineHelper.mineMenuData
        
        self.tableView.registerClass(CWMineUserCell.self, forCellReuseIdentifier: "usercell")
        // Do any additional setup after loading the view.
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

extension CWMineViewController {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 90
        }

        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("usercell", forIndexPath: indexPath) as! CWMineUserCell
            let model = CWChatUserModel()
            model.userId = "chenwei@chenweiim.com"
            model.nikeName = "陈威"
            model.userName = "chenwei19921222"
            cell.userModel = model
            return cell
        }
        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
}


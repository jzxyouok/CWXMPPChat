//
//  CWAccountSafetyHelper.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/6/2.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

class CWAccountSafetyHelper: NSObject {
    
    var safetySettingData = [CWSettingGroup]()
    
    init(userModel: CWChatUserModel) {
        
        
        let usernameItem = CWSettingItem(title: "微信号")
        if let username = userModel.userName  {
            usernameItem.subTitle = username
            usernameItem.showDisclosureIndicator = false
        } else {
            usernameItem.subTitle = "未设置"
        }
        let group1 = CWSettingGroup(items: [usernameItem])
        
        let qqNumber = userModel.qq
        
        super.init()
    }

}

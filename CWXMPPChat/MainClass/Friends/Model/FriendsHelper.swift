//
//  FriendsHelper.swift
//  CWChat
//
//  Created by chenwei on 16/4/13.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import Foundation

class FriendsHelper: NSObject {
    
    static let shareFriendsHelper = FriendsHelper()
    
    var userList = [ChatUserModel]()
    
    override init() {
        super.init()
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
    
    class func findFriend(userid:String?) -> ChatUserModel? {
        for user in FriendsHelper.shareFriendsHelper.userList {
            if userid == user.userId {
                return user
            }
        }
        return nil
    }
}
//
//  FriendsHelper.swift
//  CWChat
//
//  Created by chenwei on 16/4/13.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import Foundation

//好友列表刷新
let CWFriendsNeedReloadNotification:String = "com.CWFriendsNeedReloadNotification.chat"

class FriendsHelper: NSObject {
    
    static let shareFriendsHelper = FriendsHelper()
    var userList = [CWChatUserModel]()
    
    override init() {
        super.init()
    }
    
    ///添加好友
    func addChatUser(user: CWChatUserModel) {
        objc_sync_enter(userList)
        if !userList.contains(user) {
            userList.append(user)
        }
        objc_sync_exit(userList)
    }
    
    
    class func findFriend(userId:String?) -> CWChatUserModel? {
        for user in FriendsHelper.shareFriendsHelper.userList {
            if userId == user.userId {
                return user
            }
        }
        return nil
    }
}
//
//  ChatUserModel.swift
//  CWChat
//
//  Created by chenwei on 16/4/2.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import Foundation

class ChatUserModel: NSObject {

    //用户id
    var userId: String!
    //用户名
    var username: String?
    //昵称
    var nikename: String?
    //备注名
    var remarkName: String?
    //头像URL
    var avatarURL: String?
    //头像路径
    var avatarPath: String?
    
    init(info: Dictionary<String, AnyObject>) {
        
    }
    
    override init() {
        
    }
    
}

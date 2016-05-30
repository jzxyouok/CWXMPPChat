//
//  CWMessageModel.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/30.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

class CWMessageModel: NSObject {

    ///消息ID
    var messageID: String
    
    var messageSendId : String?    //发送人 ID
    var messageReceiveId : String? //接受人 ID
    
    ///消息类型
    var messageType: CWMessageType
    ///消息所属者
    var messageOwnerType: CWMessageOwnerType
    ///消息发送时间
    var messageSendDate:NSDate
    
    ///消息状态
    var messageState:CWMessageSendState
    
    /// 在主页需要显示
    var conversationContent:String {
        get {
            return "子类定义"
        }
    }
    
    override init() {
        let random = arc4random() % 1000
        messageID = String(format: "\(String.UUIDString())%04d", random)
        messageType = .Unknow
        messageOwnerType = .Unknow
        messageSendDate = NSDate()
        messageState = .None
        super.init()
    }
}

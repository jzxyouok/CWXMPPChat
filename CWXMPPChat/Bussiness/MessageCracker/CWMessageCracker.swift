//
//  CWMessageCracker.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/30.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import Foundation
import XMPPFramework

/// 消息接收处理
class CWMessageCracker: XMPPModule {
    
    lazy var messagehandle: CWChatMessageHandle = {
       let messagehandle = CWChatMessageHandle()
        return messagehandle
    }()
    
    override init!(dispatchQueue queue: dispatch_queue_t!) {
        super.init(dispatchQueue: queue)
    }
    
    override init!() {
        super.init()
    }
    
}

extension CWMessageCracker: XMPPStreamDelegate {
    
    /**
     收到消息 并处理
     */
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        //如果是聊天消息
        if message.isChatMessage() {
            
            let cwMessage = CWXMPPMessage(message: message)
            //处理消息
            messagehandle.handleMessage(cwMessage)
            
        }
        
    }
    
    ///收到错误消息
    func xmppStream(sender: XMPPStream!, didReceiveError error: DDXMLElement!) {
        
        
        
    }
    
}
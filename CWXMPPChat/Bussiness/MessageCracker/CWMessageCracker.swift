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
    
    override init!(dispatchQueue queue: dispatch_queue_t!) {
        super.init(dispatchQueue: queue)
    }
    
    override init!() {
        super.init()
    }
    
}

extension CWMessageCracker: XMPPStreamDelegate {
    
    ///收到消息
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        print("message---\(message)")
    }
    
    ///收到错误消息
    func xmppStream(sender: XMPPStream!, didReceiveError error: DDXMLElement!) {
        
    }
    
}
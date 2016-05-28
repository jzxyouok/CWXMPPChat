//
//  CWMessageTransmitter.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/28.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

protocol CWMessageTransmitterDelegate:class {
    //消息发送结果
    func messageSendCallback(result:Bool)
}

/**
 消息发送的类
 
 * 生成各种消息的XML
 * 发送消息
 
 */
class CWMessageTransmitter: NSObject {

    static let shareMessageTransmitter = CWMessageTransmitter()
    private var delegateArray = [CWMessageTransmitterDelegate]()
    
    
    func addMessageSendDelegate(delegate: CWMessageTransmitterDelegate) {
        delegateArray.append(delegate)
    }
    
    func removeMessageSendDelegate(delegate: CWMessageTransmitterDelegate) {
        delegateArray = delegateArray.filter{ $0 !== delegate}
        print(delegateArray)
    }
    
    func sendMessage(contet:String, toID:String, messageID:String,type:Int = 1) {

    }
    
}

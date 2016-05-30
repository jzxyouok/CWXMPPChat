//
//  CWMessageTransmitter.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/28.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit
import XMPPFramework

///发送消息等待时间
let sendMessageTimeoutInterval: NSTimeInterval = 30

protocol CWMessageTransmitterDelegate:class {
    //消息发送结果
    func messageSendCallback(result:Bool)
}

/**
 消息发送的类
 
 * 生成各种消息的XML
 * 发送消息
 
 */
class CWMessageTransmitter: XMPPModule {

    static let shareMessageTransmitter = CWMessageTransmitter()

    override init!(dispatchQueue queue: dispatch_queue_t!) {
        super.init(dispatchQueue: queue)
    }
    
    override init!() {
        super.init()
    }
    
    func sendMessage(content:String, toId:String, messageId:String,type:Int = 1) {

        let messageElement = self.messageElement(content, to: toId, messageId: messageId)
        
        var receipte: XMPPElementReceipt? = nil
        
        self.xmppStream.sendElement(messageElement, andGetReceipt: &receipte)
        
        let result = receipte?.wait(sendMessageTimeoutInterval)
        if result?.boolValue == false {
           print("消息发送成功")
        }
        
    }
    
    func messageElement(message: String, to: String, messageId: String) -> DDXMLElement {
    
        //消息内容
        let body = DDXMLElement.elementWithName("body") as! DDXMLElement
        body.setStringValue(message)
        
        //消息体
        let message = DDXMLElement.elementWithName("message") as! DDXMLElement
        message.addAttributeWithName("xmlns", stringValue: "jabber:client")

        let from = "chenwei"+"@chenweiim.com";
        message.addAttributeWithName("from", stringValue: from)
        message.addAttributeWithName("to", stringValue: to)
        message.addAttributeWithName("type", stringValue: "chat")
        message.addAttributeWithName("id", stringValue: messageId)
        
        message.addChild(body)
        print(message)
        return message
    }
    
//    #if test
    //MARK: 另一种实现方式
    //可以自定义delegate来完成
    private var delegateArray = [CWMessageTransmitterDelegate]()
    func addMessageSendDelegate(delegate: CWMessageTransmitterDelegate) {
        delegateArray.append(delegate)
    }
    
    func removeMessageSendDelegate(delegate: CWMessageTransmitterDelegate) {
        delegateArray = delegateArray.filter{ $0 !== delegate}
    }
    
    func sendMessageResult(result: Bool) {
        for observer in self.delegateArray {
            observer.messageSendCallback(result)
        }
    }
//    #endif
    
}

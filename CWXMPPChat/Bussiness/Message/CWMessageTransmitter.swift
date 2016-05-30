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

    class func shareMessageTransmitter() -> CWMessageTransmitter {
        return CWXMPPManager.shareXMPPManager.messageTransmitter
    }
    
    override init!(dispatchQueue queue: dispatch_queue_t!) {
        super.init(dispatchQueue: queue)
    }
    
    override init!() {
        super.init()
    }
    
    /**
     发送消息
     
     */
    func sendMessage(content:String, toId:String, messageId:String, type:Int = 1) -> Bool {

        let messageElement = self.messageElement(content, to: toId, messageId: messageId)
        
        var receipte: XMPPElementReceipt?
        self.xmppStream.sendElement(messageElement, andGetReceipt: &receipte)
        guard let elementReceipte = receipte else {
            return false
        }
        let result = elementReceipte.wait(sendMessageTimeoutInterval)
        return result
    }
    
    /**
     组装XML消息体
     
     - parameter message:   消息内容
     - parameter to:        发送到对方的JID
     - parameter messageId: 消息Id
     
     - returns: 消息XML的实体
     */
    func messageElement(message: String, to: String, messageId: String) -> DDXMLElement {
    
        //消息内容
        let body = DDXMLElement.elementWithName("body") as! DDXMLElement
        body.setStringValue(message)
        
        //消息体
        let message = DDXMLElement.elementWithName("message") as! DDXMLElement
        message.addAttributeWithName("xmlns", stringValue: "jabber:client")

        //可以自定义，看看是否显示是哪个端的。
        let myJID = self.xmppStream.myJID
        let from = "\(myJID.user)"+"@\(myJID.domain)";
        
        message.addAttributeWithName("from", stringValue: from)
        message.addAttributeWithName("to", stringValue: to)
        message.addAttributeWithName("type", stringValue: "chat")
        message.addAttributeWithName("id", stringValue: messageId)
        
        message.addChild(body)
        CWLog(message)
        return message
    }
    
    #if test
    //MARK: 另一种实现方式
    //可以自定义delegate来完成,
    private var delegateArray = [CWMessageTransmitterDelegate]()
    func addMessageSendDelegate(delegate: CWMessageTransmitterDelegate) {
        delegateArray.append(delegate)
    }
    
    func removeMessageSendDelegate(delegate: CWMessageTransmitterDelegate) {
        delegateArray = delegateArray.filter{ $0 !== delegate}
    }
    #endif
    
    func sendMessageResult(result: Bool) {
 
        
    }
    
}

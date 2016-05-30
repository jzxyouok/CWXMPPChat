//
//  CWXMPPMessage.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/27.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit
import XMPPFramework


let CWXMPPMessageChatType:String = "chat"


/**
 中间转换的消息
 

 */
class CWXMPPMessage: NSObject {
    
    var type: String
    var messageId: String
    var from: String
    var to: String
    
    var body: String?
    var delayDateString: String?
    var composing: Bool = false
    
    init(message: XMPPMessage) {
        
        self.type = message.type()
        self.messageId = message.attributeForName("id").stringValue()
        self.from = message.attributeForName("from").stringValue()
        self.to = message.attributeForName("to").stringValue()
        self.body = message.body()
        
        //对方正在输入
        if message.elementForName("composing") != nil {
            self.composing = true
        }
        
        //对方停止输入
        if message.elementForName("paused") != nil {
            self.composing = false
        }
        
        let delayElement = message.elementForName("delay")
        if (delayElement != nil) {
            
            let formatter = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            let delayTime = delayElement.attributeStringValueForName("stamp")
            self.delayDateString = ChatTimeTool.stringFromDateString(delayTime, fromDateFormat: formatter)
        }
        super.init()
    }
    
    override var description: String {
        return "[type:"
    }
    
}

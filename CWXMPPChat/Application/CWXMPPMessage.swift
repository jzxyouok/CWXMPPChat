//
//  CWXMPPMessage.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/27.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit
import XMPPFramework

class CWXMPPMessage: NSObject {
    
    var type: String
    var messageId: String
    var from: String
    var to: String
    var body: String
    
    init(message: XMPPMessage) {
        
        self.type = message.type()
        self.messageId = message.attributeForName("id").stringValue()
        self.from = message.attributeForName("from").stringValue()
        self.to = message.attributeForName("to").stringValue()
        self.body = message.body()
    }
    
    
}

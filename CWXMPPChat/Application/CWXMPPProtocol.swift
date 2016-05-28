//
//  CWXMPPProtocol.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/28.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

protocol CWXMPPProtocol {
    
}


/**
 配置xmpp账户信息
 */
protocol CWXMPPManagerDataSource: NSObjectProtocol {
    
    var serverAddress: String {get}
    var userName: String {get}
    var password: String {get}

}



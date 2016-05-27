//
//  CWXMPPManager.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/27.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit
import XMPPFramework

private let xmppManager = CWXMPPManager()

class CWXMPPManager: NSObject {
    
    ///xmpp流
    var xmppStream:XMPPStream
    ///xmpp重新连接
    var xmppReconnect:XMPPReconnect
    
    ///单利模式    
    class func shareInstance() -> CWXMPPManager {
        return xmppManager
    }
    
    private override init() {
        let queue = dispatch_queue_create("com.cwxmppchat.cwcoder", DISPATCH_QUEUE_SERIAL)
        
        xmppStream = XMPPStream()
        xmppReconnect = XMPPReconnect()
        
        super.init()
        
        xmppStream.addDelegate(self, delegateQueue: queue)
        
        ///配置xmpp重新连接的服务
        xmppReconnect.reconnectDelay = 3.0
        xmppReconnect.reconnectTimerInterval = DEFAULT_XMPP_RECONNECT_TIMER_INTERVAL
        xmppReconnect.activate(xmppStream)
        xmppReconnect.addDelegate(self, delegateQueue: queue)
    }
    
    
    func setupXMPPReconnect() {

    }
    
    ///连接服务器
    func connectProcess() {
        
        guard xmppStream.isConnecting() || !xmppStream.isConnected() else {
            return
        }
        
        let xmppAccount = "tom@chenweiim.com"
        let hostName = "localhost"
        let hostPort:UInt16 = 5222
        
        let timeoutInterval:NSTimeInterval = 10
        
        xmppStream.myJID = XMPPJID.jidWithString(xmppAccount)
        
        xmppStream.hostName = hostName
        xmppStream.hostPort = hostPort
        
        do {
            try xmppStream.connectWithTimeout(timeoutInterval)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func goOnline() {
        let presence = XMPPPresence()
        xmppStream.sendElement(presence)
    }
    
    func goOffline() {
        let offline = XMPPPresence(type: CWUserStatus.Offline.rawValue)
        xmppStream.sendElement(offline)
    }

}

extension CWXMPPManager: XMPPStreamDelegate {
    
    ///
    func xmppStreamWillConnect(sender: XMPPStream!) {
        print("xmppStream-xmppStreamWillConnect")

    }
    
    ///
    func xmppStreamDidConnect(sender: XMPPStream!) {
        print("xmppStream-xmppStreamDidConnect")

        let password = "123456"
        do {
            try xmppStream.authenticateWithPassword(password)
        } catch let error as NSError {
            print(error)
        }
    }
    
    ///验证失败
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        print("xmppStream-didNotAuthenticate")
    }
    
    ///验证成功
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        print("xmppStream-xmppStreamDidAuthenticate")
        //上线
        goOnline()
    }
    
    ///收到消息
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        print(message)
        
        //如果是聊天消息
        if message.isChatMessage() {
            
            //对方正在输入
            if message.elementForName("composing") != nil {
                
            }
            
            //离线消息
            if message.elementForName("delay") != nil {
                
            }
            
            //消息正文
            if let body = message.body() {
                
            }
            
        }
        
    }
    
    ///收到状态信息
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        
        print(presence)
        
        let myUser = sender.myJID.user
        
        //好友的用户名
        let user = presence.from().user
    
        //用户所在的域
        let domain = presence.from().domain
        
        //状态
        let type = presence.type()
        
        guard user == myUser else {
            
            return
        }
        
        //如果是好友上下线
        //上线
        if type == CWUserStatus.Online.rawValue {
            
        }
        //下线
        else if type == CWUserStatus.Offline.rawValue {
            
        }
        
    }
    
}




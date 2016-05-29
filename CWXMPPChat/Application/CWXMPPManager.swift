//
//  CWXMPPManager.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/27.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit
import XMPPFramework

let xmppDomain:String = "@chenweiim.com"
let hostName = "192.168.0.121"
let hostPort:UInt16 = 5222

let password = "123456"




class CWXMPPManager: NSObject {
    
    ///单例
    internal static let shareXMPPManager = CWXMPPManager()
    
    ///xmpp流
    private var xmppStream:XMPPStream
    ///xmpp重新连接
    private var xmppReconnect:XMPPReconnect
    
    ///消息发送
    internal var messageTransmitter:CWMessageTransmitter
    var xmppRoster: XMPPRoster
    
    ///初始化方法
    private override init() {
        let queue = dispatch_queue_create("com.cwxmppchat.cwcoder", DISPATCH_QUEUE_CONCURRENT)

        xmppStream = XMPPStream()
        xmppReconnect = XMPPReconnect()
        messageTransmitter = CWMessageTransmitter()
        
        let xmppRosterStorage = XMPPRosterMemoryStorage()
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage, dispatchQueue: queue)
        
        super.init()
        
        ///xmpp
        xmppStream.enableBackgroundingOnSocket = true
        xmppStream.addDelegate(self, delegateQueue: queue)
        
        ///好友
        xmppRoster.activate(xmppStream)
        xmppRoster.addDelegate(self, delegateQueue: queue)
        
        ///配置xmpp重新连接的服务
        xmppReconnect.reconnectDelay = 3.0
        xmppReconnect.reconnectTimerInterval = DEFAULT_XMPP_RECONNECT_TIMER_INTERVAL
        xmppReconnect.activate(xmppStream)
        xmppReconnect.addDelegate(self, delegateQueue: queue)
        
        ///消息发送
        messageTransmitter.activate(xmppStream)
        
    }
    
    ///连接服务器
    func connectProcess() {
        
        guard xmppStream.isConnecting() || !xmppStream.isConnected() else {
            return
        }
        
        //可以添加是哪个端
        let resource = "weiweideMacBook-Simulator"
        let timeoutInterval:NSTimeInterval = 10

        xmppStream.myJID = XMPPJID.jidWithUser("chenwei", domain: "chenweiim.com", resource: resource)
        
        xmppStream.hostName = hostName
        xmppStream.hostPort = hostPort
        
        do {
            try xmppStream.connectWithTimeout(timeoutInterval)
        } catch let error as NSError {
            print(error)
        }
    }
    
    //发送在线信息
    func goOnline() {
        let presence = XMPPPresence(type: CWUserStatus.Online.rawValue)
        xmppStream.sendElement(presence)
    }
    
    func goOffline() {
        let offline = XMPPPresence(type: CWUserStatus.Offline.rawValue)
        xmppStream.sendElement(offline)
    }

}

// MARK: - XMPPStreamDelegate
extension CWXMPPManager: XMPPStreamDelegate {
    
    ///
    func xmppStreamWillConnect(sender: XMPPStream!) {
        print("xmppStream-xmppStreamWillConnect")

    }
    
    ///已经连接，就输入密码
    func xmppStreamDidConnect(sender: XMPPStream!) {
        print("xmppStream-xmppStreamDidConnect")

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
        xmppRoster.fetchRoster()
    }
    
    ///收到消息
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        
        //如果是聊天消息
        if message.isChatMessage() {
            
            //对方正在输入
            if message.elementForName("composing") != nil {
                
            }
            
            //对方停止输入
            if message.elementForName("paused") != nil {
                
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
        
        let myUser = sender.myJID.user
        
        //好友的用户名
        let user = presence.from().user
    
        //用户所在的域
        let domain = presence.from().domain
        
        //状态
        let type = presence.type()
        
        guard user != myUser else {
            
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

// MARK: - XMPPRosterDelegate 好友请求
extension CWXMPPManager: XMPPRosterDelegate {
    
    ///收到好友列表
    func xmppRosterDidEndPopulating(sender: XMPPRoster!) {
        print("获取好友信息界面")
        let story = sender.xmppRosterStorage as! XMPPRosterMemoryStorage
        let userArray = story.sortedUsersByName() as! [XMPPUser]
        
        for user in userArray {
            
            let chatUser = CWChatUserModel()
            chatUser.nikeName = user.nickname()
            chatUser.isOnline = user.isOnline()
            chatUser.userName = user.jid().user
            chatUser.userId = user.jid().full()
            
            FriendsHelper.shareFriendsHelper.addChatUser(chatUser)
        }
        
        dispatch_async(dispatch_get_main_queue()) { 
            NSNotificationCenter.defaultCenter().postNotificationName(CWFriendsNeedReloadNotification, object: nil)
        }
        //需要刷新好友列表
        
    }
}


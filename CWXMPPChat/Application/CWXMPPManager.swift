//
//  CWXMPPManager.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/27.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit
import XMPPFramework
import Alamofire

let xmppDomain:String = "@chenweiim.com"
let hostName = "192.168.0.121"
let hostPort:UInt16 = 5222

let password = "123456"

class CWXMPPManager: NSObject {
    
    ///单例
    internal static let shareXMPPManager = CWXMPPManager()
    
    private var xmppQueue: dispatch_queue_t
    ///xmpp流
    private var xmppStream: XMPPStream
    ///xmpp重新连接
    private var xmppReconnect: XMPPReconnect
    
    ///消息发送
    private(set) var messageTransmitter: CWMessageTransmitter
    ///消息解析
    private(set) var messageCracker: CWMessageCracker
    ///消息回执
    private var deliveryReceipts: XMPPMessageDeliveryReceipts
    ///获取好友请求
    var xmppRoster: XMPPRoster
    
    ///当前连接状态
    var currentState: CWXMPPStatus {
        var state: CWXMPPStatus = .None
        if xmppStream.isDisconnected() {
            state = .Disconnected
        }
        else if xmppStream.isConnected() && xmppStream.isAuthenticated() {
            state = .Connected
        } else {
            state = .Connecting
        }
        return state
    }
    
    var reachable: NetworkReachabilityManager?
    
    ///初始化方法
    private override init() {
        xmppQueue = dispatch_queue_create("com.cwxmppchat.cwcoder", DISPATCH_QUEUE_CONCURRENT)

        xmppStream = XMPPStream()
        xmppReconnect = XMPPReconnect()
        messageTransmitter = CWMessageTransmitter()
        messageCracker = CWMessageCracker()
        let xmppRosterStorage = XMPPRosterMemoryStorage()
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage, dispatchQueue: xmppQueue)
        
        ///消息回执
        deliveryReceipts = XMPPMessageDeliveryReceipts()
        
        super.init()
        
        ///xmpp
        xmppStream.enableBackgroundingOnSocket = true
        xmppStream.addDelegate(self, delegateQueue: xmppQueue)
        
        ///好友
        xmppRoster.activate(xmppStream)
        xmppRoster.addDelegate(self, delegateQueue: xmppQueue)
        
        ///配置xmpp重新连接的服务
        xmppReconnect.reconnectDelay = 3.0
        xmppReconnect.reconnectTimerInterval = DEFAULT_XMPP_RECONNECT_TIMER_INTERVAL
        xmppReconnect.activate(xmppStream)
        xmppReconnect.addDelegate(self, delegateQueue: xmppQueue)
        
        ///消息回执
        deliveryReceipts.activate(xmppStream)
        deliveryReceipts.autoSendMessageDeliveryReceipts = true
        
        ///消息发送
        messageTransmitter.activate(xmppStream)
        messageCracker.activate(xmppStream)
        
      
        setupNetworkReachable()
        registerApplicationNotification()
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
            CWLog(error)
        }
    }
    
    ///注册观察者
    func registerApplicationNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    func setupNetworkReachable() {
        ///监视网络变化
        reachable = NetworkReachabilityManager(host: "http://www.baidu.com")
        reachable?.startListening()
        let listener = { (status: NetworkReachabilityManager.NetworkReachabilityStatus) in
            CWLog("网络状态:\(status)")
        }
        reachable?.listener = listener
    }
    
    
    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
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
    
    ///MARK: 销毁
    deinit {
        xmppReconnect.removeDelegate(self, delegateQueue: xmppQueue)
        xmppReconnect.deactivate()
        
        xmppStream.removeDelegate(self, delegateQueue: xmppQueue)
        xmppStream.disconnect()
        
        reachable?.stopListening()
    }

}

// MARK: - XMPPStreamDelegate
extension CWXMPPManager: XMPPStreamDelegate {
    
    
    ///
    func xmppStreamWillConnect(sender: XMPPStream!) {
        CWLog("开始连接")
    }
    
    ///连接失败
    func xmppStreamDidDisconnect(sender: XMPPStream!, withError error: NSError!) {
        CWLog("断开连接")
    }
    
    ///已经连接，就输入密码
    func xmppStreamDidConnect(sender: XMPPStream!) {
        CWLog("连接成功")
        do {
            try xmppStream.authenticateWithPassword(password)
        } catch let error as NSError {
            print(error)
        }
    }
    
    ///验证失败
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        CWLog("认证失败")
    }
    
    ///验证成功
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        CWLog("认证成功")
        //上线
        goOnline()
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
    
    
    func xmppStream(sender: XMPPStream!, didReceiveIQ iq: XMPPIQ!) -> Bool {
        return true
    }
    
}

// MARK: - XMPPRosterDelegate 好友请求
extension CWXMPPManager: XMPPRosterDelegate {
    
    ///收到好友列表
    func xmppRosterDidEndPopulating(sender: XMPPRoster!) {
        CWLog("获取好友信息界面")
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


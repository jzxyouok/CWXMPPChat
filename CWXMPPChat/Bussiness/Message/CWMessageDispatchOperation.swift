//
//  CWMessageDispatchOperation.swift
//  CWChat
//
//  Created by chenwei on 16/4/10.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import Foundation

///重复发送次数
let Max_RepeatCount:Int = 3

/// 发送消息的基类
class CWMessageDispatchOperation: NSOperation {
    
    weak var chatmessage: CWMessageProtocol?
        /// 进度回调的block
    var progressBlock: ((Float,Bool)-> Void)?
    
    /// 控制并发的变量
    override var executing: Bool {
        return local_executing
    }
    
    override var finished: Bool {
        return local_finished
    }
    
    override var cancelled: Bool {
        return local_cancelled
    }
    
    /// 实现并发需要设置为YES
    override var concurrent: Bool {
        return true
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    ///控制并发任务的变量
    private var local_executing:Bool = false {
        willSet {
            self.willChangeValueForKey("isExecuting")
        }
        didSet {
            self.didChangeValueForKey("isExecuting")
        }
    }
    private var local_finished:Bool = false {
        willSet {
            self.willChangeValueForKey("isFinished")
        }
        didSet {
            self.didChangeValueForKey("isFinished")
        }
    }
    private var local_cancelled:Bool = false {
        willSet {
            self.willChangeValueForKey("isCancelled")
        }
        didSet {
            self.didChangeValueForKey("isCancelled")
        }
    }
    
    var messageSendResult:Bool
    //重复执行的次数
    internal var repeatCount: Int = 0
    
    /**
     根据消息类型生成对应的Operation
     
     - parameter message: 消息体
     
     - returns: 返回对应的消息Operation
     */
    class func transmitterWithMessage(message:CWMessageProtocol) -> CWMessageDispatchOperation {
        
        if message.messageType == .Text {
            return CWTextMessageDispatchOperation(message:message)
        }
        else if message.messageType == .Image {
            return CWImageMessageDispatchOperation(message:message)
        }
        else {
            return CWMessageDispatchOperation(message:message)
        }
    }
    
    init(message: CWMessageProtocol) {
        self.chatmessage = message
        repeatCount = 1
        messageSendResult = false
        super.init()
    }
    
    ///函数入口
    override func start() {
        //疑问
        if NSThread.isMainThread() {
            
        }
        
        if self.finished || self.cancelled {
            self.endOperation()
            return
        }
        self.local_executing = true
        self.performSelectorInBackground(#selector(CWMessageDispatchOperation.main), withObject: nil)
    }
    
    override func cancel() {
        
        self.local_cancelled = true
        super.cancel()
    }

    ///主要执行的过程
    override func main() {
    
        if self.finished || self.cancelled {
            self.endOperation()
            return
        }
        
        CWMessageTransmitter.shareMessageTransmitter.addMessageSendDelegate(self)
        //发送消息的任务
        sendMessage()
    }
    
    ///发送消息
    func sendMessage() {
//        endOperation()
    }
    
    ///消息状态
    func noticationWithOperationState(state:Bool) {
        self.messageSendResult = state
        endOperation()
    }
    
    /**
     结束线程
     */
    func endOperation() {
        self.local_executing = false
        self.local_finished = true
    }

    
    deinit {
        print("operation销毁....")
    }
    
}

extension CWMessageDispatchOperation:CWMessageTransmitterDelegate {
   
    func messageSendCallback(result:Bool) {
        print("发送消息结果\(chatmessage!.description)---\(result) \(NSDate())")
        if result == false {
            repeatCount += 1
            if repeatCount > Max_RepeatCount {
                CWMessageTransmitter.shareMessageTransmitter.removeMessageSendDelegate(self)
                noticationWithOperationState(false)
            } else {
                sendMessage()
            }
        } else {
            CWMessageTransmitter.shareMessageTransmitter.removeMessageSendDelegate(self)
            noticationWithOperationState(true)
        }
    }
}



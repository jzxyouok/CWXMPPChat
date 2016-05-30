//
//  CWMessageProtocol.swift
//  CWChat
//
//  Created by chenwei on 16/4/4.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

///MARK: 会话记录
///会话提示类型
public enum CWConversationClueType: Int {
    case None
    case Point
    case PointWithNumber
}

///会话的类型
public enum CWConversationType: Int {
    case Personal
    case Group
}


//MARK: 消息
///消息聊天类型
public enum CWMessagePartnerType: Int {
    case Personal
    case Group
}

///消息所属类型
public enum CWMessageOwnerType : Int {
    case Unknow  //未知
    case System   //系统消息
    case Myself   //自己发送的
    case Other    //接受到朋友发送的
}

///消息类型
public enum CWMessageType : Int {
    case Unknow             //未知
    case Text               //文字
    case Image              //图片
    case Voice              //声音
    case Video              //视频
    case Expression         //表情
    
    //获取cell的reuseIdentifier
    func reuseIdentifier() -> String {
        switch self {
        case .Text:
            return "ChatMessageTextCell"
        case .Image:
            return "ChatMessageImageCell"
        case .Voice:
            return "ChatMessageVoiceCell"
        case .Video:
            return "ChatMessageVideoCell"
        case .Expression:
            return "ChatMessageExpressionCell"
        default:
            return "ChatMessageCell"
        }
    }
}

///消息发送的状态
public enum CWMessageSendState : Int {
    case None               //默认消息状态
    case Sending            //消息发送中
    case Fail              //消息发送失败
    case Success           //消息发送成功
    
    init(state: Bool) {
        if state {
            self = .Success
        } else {
            self = .Fail
        }
    }
}

///消息读取的状态
public enum CWMessageReadState : Int {
    case Readed               //消息已读
    case Unread               //消息未读
}

///消息播放状态(声音和视频)
public enum CWMessagePlayState : Int {
    case None    = 0             //无播放（自己发送的默认是无播放）
    case UnPlay  = -1              //未播放 (接收的语言消息默认是未播放)
    case Playing = 1              //播放中
    case Played  = 2             //已经播放过
    
    init (state: Bool) {
        if state {
            self = .Played
        } else {
            self = .UnPlay
        }
    }
    
}

/**
 消息上传状态
 
 - None:    没有状态默认
 - Loading: 上传当中
 - Success: 上传成功
 - Fail:    上传失败
 */
public enum CWMessageUploadState: Int {
    case None    = -1
    case Loading = 0
    case Success = 1
    case Fail    = 2
}


let  MAX_SHOWTIME_MESSAGE_COUNT:Int  =     10
let  MAX_SHOWTIME_MESSAGE_SECOND:Double =     30

//MARK: 消息的协议
///消息的协议
protocol CWMessageProtocol: NSObjectProtocol {
    
    var messageID:String { get }            //消息ID
    var userID:String?  { get set }         //发送者ID
    var friendID:String? {get set}          //接收者ID
    
    ///是否显示时间
    var showTime:Bool { get set }
    ///是否用户名称
    var showUsername:Bool { get set }

    var messageSendDate:NSDate {get set}       //消息发送时间

    var partnerType:CWMessagePartnerType {get set}     //消息接收者
    var messageOwnerType:CWMessageOwnerType {get set}  //消息所属类型
    var messageType:CWMessageType {get set}            //消息类型
    
    var messageSendState:CWMessageSendState {get set}  //消息发送状态
    var messageReadState:CWMessageReadState {get set}  //消息读取状态
    var messagePlayState:CWMessagePlayState {get set}  //消息播放状态
    var messageUploadState:CWMessageUploadState {get set} //消息上传状态
    //
    //
    var conversationContent:String {get}
    var contentInfo:Dictionary<String,AnyObject>? {get}
}



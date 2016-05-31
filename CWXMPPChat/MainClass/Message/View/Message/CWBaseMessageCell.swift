//
//  CWBaseMessageCell.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/28.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

///头像
let AVATAR_WIDTH:CGFloat        = 38.0
let AVATAR_SPACE_X:CGFloat      = 8.0
let AVATAR_SPACE_Y:CGFloat      = 12.0

let kChatAvatarMarginLeft: CGFloat = 10             //头像的 margin left
let kChatAvatarMarginTop: CGFloat = 0               //头像的 margin top
let kChatAvatarWidth: CGFloat = 40                  //头像的宽度

//消息在左边的时候， 文字距离屏幕左边的距离
let kChatTextLeftPadding: CGFloat = 72
//消息在左边的时候， 文字距离屏幕左边的距离
let kChatTextRightPadding: CGFloat = 82
//消息在右边， 70：文本离屏幕左的距离，  82：文本离屏幕右的距
let kChatTextMaxWidth: CGFloat = Screen_Width - kChatTextLeftPadding - kChatTextRightPadding

class CWBaseMessageCell: UITableViewCell {
    
    ///
    var message:CWMessageProtocol?
    ///用户名称
    var usernameLabel:UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.backgroundColor = UIColor.clearColor()
        usernameLabel.font = UIFont.systemFontOfSize(12)
        return usernameLabel
    }()
    
    ///头像
    lazy var avatarButton:UIButton = {
        let avatarButton = UIButton(type: .Custom)
        avatarButton.frame.size = CGSize(width: AVATAR_WIDTH, height: AVATAR_WIDTH)
        avatarButton.addTarget(self,
                               action: #selector(avatarButtonClickDown(_:)),
                               forControlEvents: UIControlEvents.TouchUpInside)
        return avatarButton
    }()
    
    ///手势操作
    internal private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bubbleTapped(_:)))
        return tapGestureRecognizer
    }()
    
    internal private (set) lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let longpressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(bubbleLongPressed(_:)))
        longpressGestureRecognizer.delegate = self
        return longpressGestureRecognizer
    }()
    
    ///消息的背景图片
    lazy var messageBackgroundView:UIImageView = {
        let messageBackgroundView = UIImageView()
        messageBackgroundView.userInteractionEnabled = true
        
        return messageBackgroundView
    }()
    
    //引导
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var errorButton:UIButton = {
        let errorButton = UIButton(type: .Custom)
        errorButton.setImage(UIImage(named:"message_sendfaild"), forState: .Normal)
        errorButton.sizeToFit()
        errorButton.hidden = true
        return errorButton
    }()
    
    // MARK: 初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
        
        self.contentView.addSubview(self.usernameLabel)
        self.contentView.addSubview(self.avatarButton)
        self.contentView.addSubview(self.messageBackgroundView)
        self.contentView.addSubview(self.activityView)
        self.contentView.addSubview(self.errorButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///赋值
    func setMessage(message: CWMessageModel) {
        self.message = message
        if message.messageOwnerType == .Myself {
            let string = "http://o7ve5wypa.bkt.clouddn.com/"+"tom@chenweiim.com"
            self.avatarButton.af_setImageForState(.Normal, URL: NSURL(string:string)!)
            self.avatarButton.left = Screen_Width - kChatAvatarMarginLeft - AVATAR_WIDTH
        } else {
            let string = "http://o7ve5wypa.bkt.clouddn.com/"+"jerry@chenweiim.com"
            self.avatarButton.af_setImageForState(.Normal, URL: NSURL(string:string)!)
            self.avatarButton.left = kChatAvatarMarginLeft
        }

    }
    
    // MARK: cell中的事件处理
    ///头像点击
    func avatarButtonClickDown(button:UIButton) {
        
    }
    
    ///手势事件
    func bubbleTapped(tapGestureRecognizer: UITapGestureRecognizer) {

    }
    
    func bubbleLongPressed(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == .Began {

        }
    }
    
}

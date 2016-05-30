//
//  CWTimeMessageCell.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/30.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

/**
 格式化时间
 
 1. 如果是列表的第一项，则显示时间；
 2. 如果这一条与前面一条间隔两分钟以上，则显示时间
 3. 如果这一条是列表的第一项，但是下拉刷新后与前面一条间隔在两分钟之内，仍显示这一条的时间
 4. 时间显示格式：
 * 如果是今天的聊天，显示具体时间。如：11:05
 * 如果是昨天，或者前天，显示相对日期和具体时间，如：昨天 19:34，前天 20:22
 * 如果在七天之内，则显示 星期加时间，如：周二 12:23
 * 如果在一年之内，则显示月份日期 和时间，如：7月18日 12:34
 * 一年以上的，显示年月日 加时间，如： 2014年6月29日 8:20
 */

/// 显示时间的Label
class CWTimeMessageCell: UITableViewCell {

    ///时间
    var timeLabel:UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFontOfSize(12)
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.backgroundColor = UIColor.grayColor()
        timeLabel.alpha = 0.7
        timeLabel.layer.cornerRadius = 5
        timeLabel.clipsToBounds = true
        return timeLabel
    }()
    
    // MARK: 初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

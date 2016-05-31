//
//  CWSettingProtocol.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/31.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import Foundation

protocol CWSettingSwitchCellDelegate: class {
    func settingSwitchCellForItem(item: CWSettingItem, didChangeStatus status: Bool)
}

protocol CWSettingDataProtocol: class {
    var settingItem: CWSettingItem! {set get}
}

extension CWSettingDataProtocol {
    
}
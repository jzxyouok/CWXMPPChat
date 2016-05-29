//
//  UIBarButtonItem+Chat.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/29.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    class func fixBarItemSpaceWidth(spaceWidth: CGFloat) -> UIBarButtonItem {
        let fixspaceItem =  UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixspaceItem.width = spaceWidth
        return fixspaceItem
    }
    
    
}

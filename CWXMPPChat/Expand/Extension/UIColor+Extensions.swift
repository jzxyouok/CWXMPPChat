//
//  UIColor+Extensions.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/28.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        let alpha   = CGFloat( hex4 & 0x000F       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(hexString: String) {
        
        guard hexString.hasPrefix("#") else {
            self.init(white: 1, alpha: 1)
            return
        }
        
        guard let hexString: String = hexString.substringFromIndex(hexString.startIndex.advancedBy(1)),
            var   hexValue:  UInt32 = 0
            where NSScanner(string: hexString).scanHexInt(&hexValue) else {
                self.init(white: 1, alpha: 1)
                return
        }
        
        switch (hexString.characters.count) {
        case 3:
            self.init(hex3: UInt16(hexValue))
        case 4:
            self.init(hex4: UInt16(hexValue))
        case 6:
            self.init(hex6: hexValue)
        case 8:
            self.init(hex8: hexValue)
        default:
            self.init(white: 1, alpha: 1)
        }
    }
}


extension UIColor {
    

    class func chatSystemColor() -> UIColor {
        return UIColor(hexString: "#09BB07")
    }

    //tableView背景色
    class func tableViewBackgroundColorl() -> UIColor {
        return UIColor(hexString: "#EFEFF4")
    }
    
    //tableView分割线颜色
    class func tableViewCellLineColor() -> UIColor {
        return UIColor(white: 0.5, alpha: 0.3)
    }
    
    //searchBar Color
    class func searchBarTintColor() -> UIColor {
        return UIColor(hexString: "#EEEEF3")
    }
    
    class func searchBarBorderColor() -> UIColor {
        return UIColor(hexString: "#EEEEF3")
    }
    
    class func redTipColor() -> UIColor {
        return UIColor(hexString: "#D84042")
    }
    
    class func chatBoxColor() -> UIColor {
        return UIColor(hexString: "#F4F4F6")
    }
    
    class func chatBoxLineColor() -> UIColor {
        return UIColor(hexString: "#BCBCBC")
    }
    
}
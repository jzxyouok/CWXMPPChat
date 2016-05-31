//
//  UIImageView+Extensions.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/31.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit

extension UIImage {
    
    func drawRectWithRoundedCorner(radius radius: CGFloat, sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: sizetoFit)
        let context = UIGraphicsGetCurrentContext()
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius).CGPath
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        CGContextAddPath(context, path)
        CGContextClip(context)
        
        self.drawInRect(rect)
        
        CGContextDrawPath(context, .FillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return output
    }
    
    class func imageWithColor(color: UIColor) -> UIImage {
        
        let rect = CGRectMake(0, 0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    func resizableImage() -> UIImage {
        let edge = UIEdgeInsets(top: size.height*0.5, left: size.width*0.5, bottom: size.height*0.5, right: size.width*0.5)
        let image = self.resizableImageWithCapInsets(edge, resizingMode: .Stretch)
        return image
    }
    
}
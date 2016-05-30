//
//  CWLogger.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/29.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import Foundation
import XCGLogger

let documentsDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.endIndex - 1]
}()

let cacheDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
    return urls[urls.endIndex - 1]
}()

func CWLogMethod() {
    CWLog("")
}

func CWLog<T>(message: T, fileName: String = #file, methodName: String =  #function, lineNumber: Int = #line)
{
//    #if DEBUG
        let str : String = (fileName as NSString).pathComponents.last!.stringByReplacingOccurrencesOfString("swift", withString: "")
    
        print("\(str)\(methodName)[\(lineNumber)]:\(message)")
    
//    #endif
}

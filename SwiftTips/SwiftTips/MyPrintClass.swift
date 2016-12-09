//
//  MyPrintClass.swift
//  SwiftTips
//
//  Created by fangjiayou on 2016/12/9.
//  Copyright © 2016年 Ivan. All rights reserved.
//

import Foundation

class MyPrintClass {
    var num: Int
    init() {
        num = 1
    }
}

extension MyPrintClass: CustomDebugStringConvertible{
    var debugDescription: String{
        return "MyPrintClass Num : \(self.num)"
    }
}

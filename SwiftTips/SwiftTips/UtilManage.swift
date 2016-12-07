//
//  UtilManage.swift
//  SwiftTips
//
//  Created by fangjiayou on 2016/12/7.
//  Copyright © 2016年 Ivan. All rights reserved.
//

import UIKit

class UtilManage {
    
    static let shared = UtilManage()
    
    private init() {
        print("初始化")
    }
    
    typealias Task = (_ cancel: Bool) -> Void
    
    func delay(_ time: TimeInterval,task: @escaping () -> ()) -> Task? {
        
        //这个时候就体会到@escaping的含义了
        func dispatch_later(block: @escaping () -> ()){
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        
        var closure: (() -> Void)? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if cancel == false {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result{
                delayedClosure(false)
            }
        }
        
        return result
    }
    
    func cancel(_ task: Task?) {
        task?(true)
    }

}

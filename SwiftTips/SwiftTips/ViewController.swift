//
//  ViewController.swift
//  SwiftTips
//
//  Created by fangjiayou on 2016/12/7.
//  Copyright © 2016年 Ivan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var task: Task?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        view.backgroundColor = UIColor.cyan
//        
//        task = delay(2, task: {
//            print("2秒后执行")
//        })
        let printClass = MyPrintClass()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
//            print("AFD")
//        })
        print("取消了")
        cancel(task)
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


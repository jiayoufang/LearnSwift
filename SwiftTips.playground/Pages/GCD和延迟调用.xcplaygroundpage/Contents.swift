//: [Previous](@previous)

import Foundation

//创建目标队列
let workingQueue = DispatchQueue(label: "com.ivan.myqueue")

//派发到刚创建的队列中，GCD会负责线程调度
workingQueue.async { 
    //在workQueue中异步进行
    print("Working....")
    //模拟两秒的执行时间
    Thread.sleep(forTimeInterval: 2)
    print("Work finish")
    DispatchQueue.main.async {
        print("在主线程中更新UI")
    }
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
    
    return result
    
}

delay(2){
 print("aa")
}



//: [Next](@next)

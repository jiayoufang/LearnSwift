//: [Previous](@previous)

import Foundation

class MyManager{
    static let shared = MyManager()
    private init(){
        
    }
    
    //在初始化类变量的时候，Apple会将这个初始化包装在一次 swift_once_block_invoke 中，以保证他的唯一性，类似 dispatch_once 的方式
    //加入一个私有的初始化方法，覆盖默认的公开初始化方法，这样，其他地方就不能够通过 init 来生成自己的 MyManager 实例，也保证了单例的唯一性
}

let manager = MyManager.shared



//: [Next](@next)

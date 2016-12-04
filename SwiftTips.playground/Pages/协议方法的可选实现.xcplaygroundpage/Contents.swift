//: [Previous](@previous)

import Foundation

@objc protocol MyProtocol1 {
    @objc optional func method1() -> String
    
    func method2() -> Int
}

class MyClass1: MyProtocol1 {
    
    //不实现也是可以的
//    func method1() -> String {
//        return "Test"
//    }
    
    func method2() -> Int {
        return 2
    }
}

//是会报错的 error: non-class type 'MyStruct1' cannot conform to class protocol 'MyProtocol1'
//struct MyStruct1: MyProtocol1{
//    func method1() -> String {
//        return "Struct"
//    }
//    
//    func method2() -> Int {
//        return 3
//    }
//}

protocol MyProtocol2 {
    func method1() -> String
    
    func method2() -> Int
}

extension MyProtocol2 {
    func method1() -> String {
        return "MyProtocol2DefaultString"
    }
    
}

class MyClass2: MyProtocol2 {
    func method2() -> Int {
        return 3
    }
}

//: [Next](@next)

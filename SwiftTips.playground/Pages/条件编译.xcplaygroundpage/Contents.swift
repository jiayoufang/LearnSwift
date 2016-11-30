//: [Previous](@previous)

import Foundation

let flag = 0



//使用内置
#if os(macOS)
print("This is Mac")
#elseif os(watchOS)
print("This is watchos")
    #elseif os(tvOS)
print("This is tvOS")
#elseif os(iOS)
print("This is iOS")
#else
print("This is deafult")
#endif

//自定义
#if FREE_VERSION
let a = 12
print("Free \(a)")
#else
let a = 15
print("Not free \(a)")
    
#endif

//: [Next](@next)

//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

for character in str.characters {
    print(character)
}

//比如我们要实现一个替换第一个字符到第5个字符之前的字符的功能

//使用String
let startPosition = str.index(str.startIndex, offsetBy: 1)
let endPosition = str.index(str.startIndex, offsetBy: 5)

let range: Range = startPosition..<endPosition

str.replacingCharacters(in: range, with: "TEST") //"HTEST, playground"

//如果使用NSString

let nsRnage = NSMakeRange(1, 4)

(str as NSString).replacingCharacters(in: nsRnage, with: "TEST") //"HTEST, playground"

//: [Next](@next)

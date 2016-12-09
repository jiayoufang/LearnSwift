//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

class MyClass{
    var num: Int
    init() {
        num = 1
    }
}

let myClass = MyClass()
print(myClass)

class MyPrintClass{
    var num: Int
    init() {
        num = 1
    }
}

extension MyPrintClass: CustomStringConvertible{
    var description: String{
        return "Num: \(self.num)"
    }
}

let printClass = MyPrintClass()
print(printClass)

//: [Next](@next)

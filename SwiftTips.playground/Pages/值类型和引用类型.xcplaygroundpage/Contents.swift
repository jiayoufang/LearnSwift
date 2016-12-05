//: [Previous](@previous)

import Foundation

//验证 数组在swift中是值类型
var array = ["A","B","C"]

var array1 = array

array1.removeLast()

array //["A", "B", "C"]

array1 //["A", "B"]


//验证值  值类型在复制时，将存储在其中的值类型进行复制，但对于其中的引用类型，只是复制一份引用

//引用类型
class MyClass{
    var num: Int
    
    init(num: Int) {
        self.num = num
    }
}

var myObj = MyClass(num: 1)

var classArray = [myObj]

myObj.num = 101

classArray[0].num //101

//值类型
struct MyStruct{
    var num: Int
}

var myStruct = MyStruct(num: 2)

var structArray = [myStruct]

myStruct.num = 102

structArray[0].num //2

//: [Next](@next)

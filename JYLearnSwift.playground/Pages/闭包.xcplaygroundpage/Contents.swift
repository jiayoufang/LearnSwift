//: [Previous](@previous)

import Foundation

//sorted方法
let names = ["A","B","C","D"]

let sortedNames = names.sorted { (name1, name2) -> Bool in
    name1 > name2
}

//sorted(by:)方法接受一个闭包，该闭包函数需要传入与数组元素类型相同的两个值，并返回一个布尔类型值来表明当排序结束后传入的第一个参数排在第二个参数的前面还是后面。如果第一个参数值出现在前面，则返回true，反之，返回false


/* 闭包表达式  闭包表达式的参数可以是inout参数，但不能有默认值。
 闭包的函数部分由关键字 in 引入。该关键字表示闭包的参数和返回值类型已经完成，闭包函数体即将开始
*/

//尾随闭包的使用

func someFunc(name: String,closure: (String,Int) -> String){
    print("name:\(name)")
    closure("a",12)
}

//: [Next](@next)

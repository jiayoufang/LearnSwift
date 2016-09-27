//: [Previous](@previous)

/*
 声明函数时，如果参数不同，则是不同的函数
 函数的参数可以有默认值
 函数参数个数为可变个数的实现方式
 函数的参数作为传出值的实现方式
 */

import Foundation

func testFunc( a: Int){
    
}


func testFunc(age a: Int,name: String){
    
}

func someFunction(paramWithoutDefault: Int,paramWithDefault: Int = 1){
    
}

someFunction(paramWithoutDefault: 3)
someFunction(paramWithoutDefault: 4, paramWithDefault: 4)

func sum(numbers: Int...){
    
}
sum(numbers: 0)
sum(numbers: 0,1,2)

func swapTwoInts(a: inout Int,b: inout Int){
    let tmp = a
    a = b
    b = tmp
}

var a = 1
var b = 2
swapTwoInts(a: &a, b: &b)


//: [Next](@next)

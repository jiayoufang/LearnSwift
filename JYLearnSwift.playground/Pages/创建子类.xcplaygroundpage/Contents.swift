//: [Previous](@previous)

/*
 创建子类时，对属性和构造器的使用
 - 步骤1 对子类属性赋值
 - 步骤2 调用父类构造器
 - 步骤3 给父类属性赋值
 */

import Foundation

class Father{
    let age: Int
    var num = 0
    
    init(age: Int) {
        self.age = age
    }
}

class Child1: Father{
    let name: String
    init(name: String,age: Int) {
        //步骤1 对子类属性赋值 步骤2 调用父类构造器 步骤3 给父类属性赋值
        self.name = name
        super.init(age: age)
        num = 2
    }
}


//: [Next](@next)

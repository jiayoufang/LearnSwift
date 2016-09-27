//: Playground - noun: a place where people can play

/*
 验证结构体是值传递。类是值引用
 */
import UIKit

class TestClass {
    var name : String
    init(name : String) {
        self.name = name
    }
}

struct TestStruct {
    var name : String
}

let  classArray = [TestClass(name: "A")]

let structArray = [TestStruct(name: "B")]

var testClass = classArray.first
testClass!.name = "C"

print(classArray.first!.name) // "C"

var testStruct = structArray.first
testStruct!.name = "C"

print(structArray.first!.name) // "B"

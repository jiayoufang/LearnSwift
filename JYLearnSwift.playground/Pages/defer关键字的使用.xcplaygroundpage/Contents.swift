//: [Previous](@previous)

import Foundation

/*
 使用defer关键字  说明，该段代码最终无论如何都会执行
 */

import Foundation

var fridgeIsOpen = false
let fridgeContent = ["milk","eggs","leftover"]

func fridgeContains(itemName : String) -> Bool{
    fridgeIsOpen = true
    defer {
        fridgeIsOpen = false
    }
    
    let result = fridgeContent.contains(itemName)
    return result
}

fridgeContains(itemName: "banana")
print(fridgeIsOpen)  //false


//: [Next](@next)

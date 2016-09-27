//: [Previous](@previous)

/*
 注意 if 和 guard 语句，作用范围的不同
 */

import Foundation

var optionStr: NSString? = "AA"

func testOption(){
    guard let option1 = optionStr else {
        print("无值") //在这里是不能获取到option1的
        return
    }
    
    print(option1)
    
}

testOption()

if let a = Int("12"), let b = Int("12d"){
    print("true")
}else{
    print("false") //false
}

//隐式解析可选类型
let possibleString: String! = "AA"

if possibleString == nil {
    
}


//: [Next](@next)

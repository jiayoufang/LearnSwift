//: [Previous](@previous)

import Foundation

class MyClass{
    
}

private var key: Void?

//error: extensions may not contain stored properties
extension MyClass {
    var title: String?{
        get{
            return objc_getAssociatedObject(self, &key) as? String
        }
        set{
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

let myClass = MyClass()

if let title = myClass.title {
    print("设置了title: \(title)")
}else{
    print("该属性为空")
}

myClass.title = "Tom"

if let title = myClass.title {
    print("设置了title: \(title)")
}else{
    print("该属性为空")
}

//: [Next](@next)

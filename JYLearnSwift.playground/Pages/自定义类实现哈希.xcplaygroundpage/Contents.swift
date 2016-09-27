//: [Previous](@previous)

/*
 为了使自定义类可以存放在Set数据集合中，或作为字典的Key来使用，需要是实现Hashable
 */

import Foundation

class SetClass : Hashable,Equatable{
    let age: Int
    init(age : Int) {
        self.age = age
    }
    
    //Hashable协议
    var hashValue: Int{
        return age;
    }
    
    //Equatable协议
    public static func ==(lhs: SetClass, rhs: SetClass) -> Bool{
        return lhs.age == rhs.age
    }
}

let set: Set<SetClass> = [SetClass(age: 1),SetClass(age: 1),SetClass(age: 2)]
set.count  //2

set.contains(SetClass(age: 1))

for item in set.sorted(by: { (first, second) -> Bool in
    first.age < second.age
}) {
    print(item.age)
}

let letters = Set<Character>()


//: [Next](@next)

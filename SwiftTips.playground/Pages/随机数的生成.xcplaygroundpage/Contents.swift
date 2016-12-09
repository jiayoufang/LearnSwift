//: [Previous](@previous)

import Foundation

//创建一个Range的随机数的方法

func randomInRange(inRange range: Range<Int>) -> Int{
    let count = UInt32(range.upperBound - range.lowerBound)
    return Int(arc4random_uniform(UInt32(count))) + range.lowerBound
}

for _ in 0...10 {
    let range = Range(1...6)
    print(randomInRange(inRange: range))
}

//: [Next](@next)

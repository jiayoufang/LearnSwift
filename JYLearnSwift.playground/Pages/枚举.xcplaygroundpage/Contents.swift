//: [Previous](@previous)

import Foundation

enum CompassPoint {
    case North
    case South
    case East
    case West
}


//声明关联值，把其他类型的关联值和成员值一起存储起来，每次在代码中使用该枚举成员时，还可以修改这个关联值

enum Barcode{
    case UPCA(Int,Int,Int,Int)
    case QRCode(String)
}

var qr = Barcode.QRCode("ASD")
qr = .UPCA(1, 2, 3, 4)

//原始值
//枚举成员可以被默认值预填充，这些原始值类型必须相同
enum ASCIIControlCharacter: Character{
    case Tab = "\t"
    case LineFeed = "\n"
}

//原始值可以是字符串，字符，或者任意整型值或浮点型值。但是每个原始值在枚举声明中必须是唯一的。
//可以使用原始值来进行初始化
let asc = ASCIIControlCharacter(rawValue: "\t")

//枚举递归
//在枚举成员前添加 indirect 来表示该成员可递归。或直接在枚举类型开头加上 indirect 来表名所有成员都可递归

enum ArithmeticExpression{
    case Number(Int)
    indirect case Addition(ArithmeticExpression,ArithmeticExpression)
    indirect case Multiplication(ArithmeticExpression,ArithmeticExpression)
}

let five = ArithmeticExpression.Number(5)
let four = ArithmeticExpression.Number(4)
let sum = ArithmeticExpression.Addition(five, four)
let product = ArithmeticExpression.Multiplication(sum, ArithmeticExpression.Number(2))



//: [Next](@next)

//: [Previous](@previous)

import Foundation

//void method(const int *num){
//    printf("%d",*num);
//}



func method(_ num: UnsafePointer<CInt>){
    print(num.pointee)
    
    print(num)
}

var num: CInt = 10

method(&num)

//: [Next](@next)

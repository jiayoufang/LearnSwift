//: [Previous](@previous)

/*
 实现Error协议
 使用 throws 来表名该函数可以返回错误
 使用try-catch来判定错误
 使用try?来判定错误
 */

import Foundation


enum PrinterError : Error{
    case OutOfPaper
    case NoToner
    case OnFire
}

func sendToPrinter(printerName : String) throws -> String{
    if printerName == "Never Has Tonner" {
        throw PrinterError.NoToner
    }
    return "Job sent"
}


do {
    try sendToPrinter(printerName: "Never Has Tonner")
    print("Response")
} catch PrinterError.OutOfPaper {
    print("OutOfPaper")
} catch let printError as PrinterError {
    print(printError) //NoToner
}catch{
    print("default \(error)")
}

let printer = try? sendToPrinter(printerName: "Never Has Tonner")



//: [Next](@next)

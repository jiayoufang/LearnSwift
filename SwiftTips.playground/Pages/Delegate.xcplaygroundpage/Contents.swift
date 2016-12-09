//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

var str = "Hello, playground"

protocol MyClassDelegate: class{
    func method()
}

@objc protocol MyClassDelegate1 {
    func method()
}

class MyClass {
    weak var delegate: MyClassDelegate?
    weak var delegate1: MyClassDelegate1?
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
    }
}

PlaygroundPage.current.liveView = ViewController()

//: [Next](@next)

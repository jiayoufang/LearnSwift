//
//  GCD.swift
//  SwiftTips
//
//  Created by fangjiayou on 2016/12/7.
//  Copyright © 2016年 Ivan. All rights reserved.
//

import XCTest

class GCD: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGCG() {
        //创建目标队列
        let workingQueue = DispatchQueue(label: "com.ivan.myqueue")
        
        //派发到刚创建的队列中，GCD会负责线程调度
        workingQueue.async {
            //在workQueue中异步进行
            print("Working....")
            //模拟两秒的执行时间
            Thread.sleep(forTimeInterval: 2)
            print("Work finish")
            DispatchQueue.main.async {
                //
                print(Thread.current)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

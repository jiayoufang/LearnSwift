## 2016-11-29
###单例的创建

````

class MyManager{
    static let shared = MyManager()
    private init(){
        
    }
    
    //在初始化类变量的时候，Apple会将这个初始化包装在一次 swift_once_block_invoke 中，以保证他的唯一性，类似 dispatch_once 的方式
    //加入一个私有的初始化方法，覆盖默认的公开初始化方法，这样，其他地方就不能够通过 init 来生成自己的 MyManager 实例，也保证了单例的唯一性
}

let manager = MyManager.shared


````

###实例方法的动态调用

````

class MyClass{
    func method(num: Int) -> Int {
        return num + 1
    }
}

//如果想要调用method方法，一般是生成 MyClass 的实例，使用 .method 来调用

let obj = MyClass()
obj.method(num: 2)

//或者使用 Swift 的 Type.instanceMethod 的语法来生成一个可以柯里化的方法
let f = MyClass.method //f 的类型是 (MyClass) -> (Int) -> Int
let obj1 = MyClass()
//知道了f的类型，就不难理解为何这样调用了
f(obj1)(2)

//注：这种方法只适用于实例方法，对于属性的getter和setter不可以

//还有一种情况，实例方法和类型方法名字冲突时

class MyClass1{
    func method(num: Int) -> Int {
        return num + 1
    }
    
    class func method(num: Int) -> Int{
        return num + 2
    }
}

// 使用 MyClass1.method 默认取出来的是类型方法，解决方法是显式的加上类型声明

let method1 = MyClass1.method // class func
let method2: (Int) -> Int = MyClass1.method // class func
let method3: (MyClass1) -> (Int) -> Int = MyClass1.method // func method 的柯里化版本

````

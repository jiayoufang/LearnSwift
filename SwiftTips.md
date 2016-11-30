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

## 2016-11-30

### 条件编译
swift中没有宏的概念，所以不能使用`#ifdef`的方法来检测某个符号是否经过宏定义

####编译标记的使用语法

````

 #if <condition>

 #elseif <condition> //可选

 #else //可选

 #endif
 

````

#### `condition`的内建组合

方法 | 可选参数
--- | ---
os() | masOS、iOS、tvOS、watchOS、Linux
arch() | i386、x86_64(对应模拟器上的32位和64位CPU),arm、arm54(对应真机)
swift() | >= 某个版本

可以配合 `typealias`使用，更强大

####自定义`condition`进行条件编译

使用方法一样，主要是如何定义编译符合

在项目的编译选项中进行设置，Building Settings - Swift Compiler - Custom Flags,在其中的 Other Swift Flags 加上 `-D 定义的编译符号` 就可以了

可用于

- 在同一个Target中完成同一个APP的不同版本，进行区分
- 在Debug或Release版本中进行不同的操作

### 编译标记

在OC中，使用 `#param `来标记代码区间
在Swift中，使用`// MARK: `来标记代码区间
还有 `// TODO: `和`// FIXME: `来提示工作尚未完成或需要修改的地方

**注意：这些都是区分大小写的**

给方法添加文档说明，可使用快捷键  `alt+command+/`，这样在使用时候，使用`alt+单击`可以查看该方法的文档说明
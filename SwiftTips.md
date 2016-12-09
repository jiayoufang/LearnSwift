##2016-12-7

###创建随机数

使用`arc4random()`来创建随机数是一个不错的方法，并且在swift中也可以使用，如果想要某个范围内的数，可以使用模运算`%`来实现。

>API
public func arc4random() -> UInt32
public func arc4random_uniform(_ __upper_bound: UInt32) -> UInt32

但是有一个问题：
在iPhone5s及之后的设备上没问题，但是在iPhone5及之前的设备上**有时候**会崩溃

原因：
Swift的`Int`是和CPU的架构相关的：在32位的CPU上，实际上他是`Int32`，在64位的CPU上，他是`Int64`的。而使用`arc4random()`返回的值始终是`UInt32`的，所以在32位的机器上有一个班的概率会在进行Int转换时候越界，从而崩溃。

实践，实现创建一个Range的随机数的方法

````
//创建一个Range的随机数的方法

func randomInRange(inRange range: Range<Int>) -> Int{
    let count = UInt32(range.upperBound - range.lowerBound)
    return Int(arc4random_uniform(UInt32(count))) + range.lowerBound
}

for _ in 0...10 {
    let range = Range(1...6)
    print(randomInRange(inRange: range))
}
````

###自定制print数据的格式

实现该功能，在Objective-C中，主要靠重载`description`方法来实现

在Swift中通过实现`CustomStringConvertible`协议来实现

````
class MyPrintClass{
    var num: Int
    init() {
        num = 1
    }
}

extension MyPrintClass: CustomStringConvertible{
    var description: String{
        return "Num: \(self.num)"
    }
}

let printClass = MyPrintClass()
print(printClass)

````

其实主要是学习一种思想：**实现和定义一个类型的时候，先定义最简单的类型结构，再通过扩展(extension)的方式来实现各种协议和功能**

还有另外一个协议`CustomDebugStringConvertible `，通过实现它可以设置在调试中使用debugger来进行打印时候的输出，类似`po printClass`的命令进行打印

未实现时打印结果类似

````
 (lldb)  po printClass
<MyPrintClass: 0x608000029da0>
````

实现后打印结果类似

````
(lldb) po printClass
MyPrintClass Num : 1

````
打断点观察对象时十分有用，实现方式

````
class MyPrintClass {
    var num: Int
    init() {
        num = 1
    }
}

extension MyPrintClass: CustomDebugStringConvertible{
    var debugDescription: String{
        return "MyPrintClass Num : \(self.num)"
    }
}
````

##2016-12-6

###delegate的使用

协议-委托模式太常见了，不多说

在OC中，使用ARC，通常将delegate设置为weak，这样可以使得delegate实际的对象被释放时候，被置为nil。但在Swift中，不能直接将其设置为weak，要解决这个问题，首先要知道原因

swift中的`protocol`不仅可以被`class `所遵循，还可以被`struct `或`enum `这样的类型遵循，而对于这些类型，本身就不会通过引用计数来进行内存管理，所以不能用`weak `这样的概念来修饰

明白了原因就好解决，就是设法将`protocol `限制在class 内

#####方法一
因为在Objective-C中的`protocol `只有类能实现，所以可以将`protocol `声明为Objective-C的，通过在`protocol `前添加`@objc `来实现

````
@objc protocol MyClassDelegate {
    func method()
}

class MyClass {
    weak var delegate: MyClassDelegate?
}
````

####方法二

在protocol声明的后面加上`class `，为编译器显示的指明该protocol只能由`class `实现

````
protocol MyClassDelegate: class{
    func method()
}

class MyClass {
    weak var delegate: MyClassDelegate?
}

````

### 关联对象的实现

在Objective-C中，我们可以利用Objective-C的运行时和Key-Value Coding的特性，在运行时实现向一个对象添加值存储。在使用Category扩展现有类的功能时，直接添加实例变量是不被允许的，但可以使用property配合 Associated Object 的方式，将一个对象关联到一个已有的要扩展的对象上，从外部来看，就像是直接通过属性访问对象的实例变量一样。

在Swift中实现向`extension`中使用 Associated Object的方式将对象进行关联

````
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

````

说明：
`key `的类型被声明为 `Void? `，并通过`& `符号取地址作为`UnsafePointer<Void> `类型传入。

##2016-12-5

###GCD和延迟调用

使用GCD来实现多线程编程，先来个最经常使用的例子

````
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
        print("在主线程中更新UI")
    }
}

````

实现延迟调用，这样写主要是为了实现能够在调用之前取消该操作

````
    typealias Task = (_ cancel: Bool) -> Void
    
    func delay(_ time: TimeInterval,task: @escaping () -> ()) -> Task? {
        
        //这个时候就体会到@escaping的含义了
        func dispatch_later(block: @escaping () -> ()){
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        
        var closure: (() -> Void)? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if cancel == false {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result{
                delayedClosure(false)
            }
        }
        
        return result
    }
    
    func cancel(_ task: Task?) {
        task?(true)
    }
````


##2016-12-4

###值类型和引用类型

在swift中，有值类型和引用类型两种，值类型在传递和赋值时将进行复制，引用类型只会使用引用对象的一个‘指向’。在swift中有几点需要注意
- swift中的`struct `和`enum `定义的类型都是值类型，使用`class `定义的对象是引用类型
- swift中所有的內建类型都是值类型，不仅包括`Int `，`Bool `，甚至连`String `、`Array `和`Dictionary `都是值类型。

这样做的好处是可以减少堆内存上内存分配和回收的次数。

验证一下在swift中数组是值类型

````
//验证: 数组在swift中是值类型
var array = ["A","B","C"]

var array1 = array

array1.removeLast()

array //["A", "B", "C"]

array1 //["A", "B"]
````

验证一下值类型中存储值类型和引用类型时的操作

````
//验证:  值类型在复制时，将存储在其中的值类型进行复制，但对于其中的引用类型，只是复制一份引用

//引用类型
class MyClass{
    var num: Int
    
    init(num: Int) {
        self.num = num
    }
}

var myObj = MyClass(num: 1)

var classArray = [myObj]

myObj.num = 101

classArray[0].num //101

//值类型
struct MyStruct{
    var num: Int
}

var myStruct = MyStruct(num: 2)

var structArray = [myStruct]

myStruct.num = 102

structArray[0].num //2

````

###区分一下String和NSString

先来个自己的总结

** `String `和`NSString `其实并没有太大的区别，他们两个基本上市可以无缝转换的，之所以有时候需要转换，只是他们有很少一部分没有相互实现的API，只是为了使用起来方便**

比如遍历一个字符串

使用`String `会更方便，因为它实现了`ColletionType `这样的协议

````
var str = "Hello, playground"

for character in str.characters {
    print(character)
}

````

但如果是要和`Range `配合使用，使用`NSString `会更方便一些

````
//比如我们要实现一个替换第一个字符到第5个字符之前的字符的功能

//使用String
let startPosition = str.index(str.startIndex, offsetBy: 1)
let endPosition = str.index(str.startIndex, offsetBy: 5)

let range: Range = startPosition..<endPosition

str.replacingCharacters(in: range, with: "TEST") //"HTEST, playground"

//如果使用NSString

let nsRnage = NSMakeRange(1, 4)

(str as NSString).replacingCharacters(in: nsRnage, with: "TEST") //"HTEST, playground"
````

JUST DO IT.

##2016-12-3

###在Swift中实现协议方法的可选实现

在Objective-C中的`protocol`可是使用关键字`@optional`来实现可选方法。但是在Swift中，默认所有的方法都是必须要实现的。但是也并非不能实现，有两种方法

####将协议本身和可选方法都定义为Objective-C
其实也就是在协议之前和协议方法之前都加上`@objc`，这样就可以使用`optional`关键字了

有一些限制，说明一下：

- 使用`@objc`修饰的`protocol`只能被class实现，对于`struct`和`enum`类型，无法令他们实现可选方法和属性了
- 实现他的class 的方法也必须被标注为`@objc`，或者整个类就是继承自NSObject

````
@objc protocol MyProtocol1 {
    @objc optional func method1() -> String
    
    func method2() -> Int
}

class MyClass1: MyProtocol1 {
    
    //不实现也是可以的
//    func method1() -> String {
//        return "Test"
//    }
    
    func method2() -> Int {
        return 2
    }
}

//是会报错的 error: non-class type 'MyStruct1' cannot conform to class protocol 'MyProtocol1'
struct MyStruct1: MyProtocol1{
    func method1() -> String {
        return "Struct"
    }
    
    func method2() -> Int {
        return 3
    }
}
````

####使用extension

这个方法是在swift2.0之后才支持的，其实就是使用`protocol ` 的`extension `给出方法的默认实现，这样，这些方法在实际的类中就是可选实现的了

````
protocol MyProtocol2 {
    func method1() -> String
    
    func method2() -> Int
}

extension MyProtocol2 {
    func method1() -> String {
        return "MyProtocol2DefaultString"
    }
    
}

class MyClass2: MyProtocol2 {
    func method2() -> Int {
        return 3
    }
}
````

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


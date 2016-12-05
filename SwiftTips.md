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


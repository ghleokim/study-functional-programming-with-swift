import Foundation

func c2p0() {
    print(" ------------------ ")
    print("chapter 2 problem 5")
    
    print(" ------------------ ")
}

public func c2p1() {
    func fib(i: Int) -> Int {
        func go(_ n: Int, _ a: Int, _ b: Int) -> Int {
            if n == i { return a }
            return go(n+1, b, a+b)
        }
        return go(0, 0, 1)
    }
    
    print(" ------------------ ")
    print("chapter 2 problem 1")
    
    for i in 0...10 {
        printAnswer(" fib(\(i)) -> \(fib(i:i))")
    }
    print(" ------------------ ")
}

public func c2p2() {
    // isSorted를 구현하라. list<A> 타입의 single linked list를 받아서 비교 함수에 맞춰 정렬되어있는지 검사.
    
    class LinkedList<T> {
        var list: [T]
        init(list: [T]) {
            self.list = list
        }
        
        var head: T?
        var tail: LinkedList? {
            if self.list.count == 1 { return nil }
            self.list.removeFirst()
            return LinkedList(list: self.list)
        }
    }
    // ..?
}

public func c2p3() {
    
    // partial 함수
    func partial1<A, B, C>(a: A, f: @escaping (A, B) -> C) -> ((B) -> C) {
        return { b in
            return f(a, b)
        }
    }
    
    print(" ------------------ ")
    print("chapter 2 problem 3-0")
    
    let f: (Int, Int) -> String = { a, b in
        return "this is partial function. \(a) and \(b)"
    }
    
    let partial1ResultFunc: ((Int) -> String) = partial1(a: 10, f: f)
    
    print(partial1ResultFunc(100))
    print(partial1ResultFunc(1000))
    print(" ------------------ ")
    
    func curry<A, B, C>(f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
        return { a in
            return { b in
                f(a, b)
            }
        }
    }
    
    print(" ------------------ ")
    print("chapter 2 problem 3")
    
    let curryTarget: (Int, Float) -> String = { _int, _float in
        return "curried func \(_int) and \(_float)"
    }
    
    let curried1234 = curry(f: curryTarget)(1234)
    
    print(curried1234(1.1))
    print(curried1234(1.2))
    
    print(" ------------------ ")
}

public func c2p4() { // curry의 역변환인 uncurry를 구현하라.
    // uncurry 함수
    func uncurry<A, B, C>(f: @escaping (A) -> (B) -> C) -> (A, B) -> C {
        return { a, b in
            f(a)(b)
        }
    }
    
    print(" ------------------ ")
    print("chapter 2 problem 4")
    
    // curry 함수 from problem 3
    func curry<A, B, C>(f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
        return { a in
            return { b in
                f(a, b)
            }
        }
    }
    
    let curryTarget: (Int, Float) -> String = { _int, _float in
        return "curried func \(_int) and \(_float)"
    }
    
    let curriedFunc = curry(f: curryTarget)
    let curried1234 = curriedFunc(1234)
    print("curried: \(curried1234(1.1234))")
    
    let uncurried = uncurry(f: curriedFunc)
    print("uncurried: \(uncurried(10, 1234))")
    
    print(" ------------------ ")
}

public func c2p5() { // 두 함수를 합성하는 고차함수를 작성하라.
    
    typealias F<X, Y> = (X) -> Y
    typealias G<U, V> = (U) -> V
    func compose<A, B, C>(f: @escaping F<B, C>, g: @escaping G<A, B>) -> (A) -> C {
        return { a in
            f(g(a))
        }
    }
    
    print(" ------------------ ")
    print("chapter 2 problem 5")
    
    let plus = { $0 + 5 }
    let times = { $0 * 10 }
    
    let timesAndPlus = compose(f: plus, g: times)
    let plusAndTimes = compose(f: times, g: plus)
    
    print("times10AndPlus5 4 -> \(timesAndPlus(4))") // 45
    print("plus5Andtimes10 4 -> \(plusAndTimes(4))") // 90
    print(" ------------------ ")
}

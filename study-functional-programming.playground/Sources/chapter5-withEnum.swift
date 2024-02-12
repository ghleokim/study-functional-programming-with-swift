import Foundation


// Enum으로 Stream 구현하기
enum StreamEnum<T> {
    case Cons(head: () -> T, tail: () -> StreamEnum<T>)
    case Empty
}

extension StreamEnum: CustomStringConvertible {
    var description: String {
        switch self {
        case .Empty:
            return "End of the stream."
        case .Cons(let head, let tail):
            return "\(head())," + "\(tail().description)"
        }
    }
}

extension StreamEnum {
    func headOption() -> T? {
        switch self {
        case .Empty:
            return nil
        case .Cons(let head, _):
            return head()
        }
    }
    
    // create a new stream
    static func of(_ xs: T...) -> StreamEnum<T> {
        return of(xs)
    }
    
    static func of(_ xs: [T]) -> StreamEnum<T> {
        if xs.count == 0 {
            return .Empty
        } else {
            return .Cons(head: { xs[0] }, tail: { StreamEnum<T>.of(Array(xs[1...])) })
        }
    }
}

public func c5_2p0() {
    printProblem(chapter: "5.2", problem: "0") {
        printAnswer("Usages of StreamEnum.of()")
        printAnswer("Empty stream:                StreamEnum<Int>.of() -> ", StreamEnum<Int>.of())
        printAnswer("Stream with variadic params: StreamEnum.of(1,2,3) -> ", StreamEnum.of(1,2,3))
        printAnswer("Stream from Array:           StreamEnum.of([1,2,3]) -> ", StreamEnum.of([1,2,3]))
    }
}


extension StreamEnum {
    func toList() -> List<T> {
        switch self {
        case .Empty:
            return List(head: nil, next: nil)
        case .Cons(let head, let tail):
            return List(head: head(), next: tail().toList())
        }
    }
}

public func c5_2p1() {
    let stream = StreamEnum.of(1,2,3)
    let listFromStream = stream.toList()
    
    printProblem(chapter: "5.2", problem: "1") {
        printAnswer("Testing stream.toList()")
        printAnswer("Stream: ", stream)
        printAnswer("List: ", listFromStream)
    }
}

extension StreamEnum {
    func take(n: Int) -> StreamEnum<T> {
        func tk(stream: Self, n: Int) -> Self {
            guard n > 0 else { return .Empty }
            switch stream {
            case .Empty:
                return .Empty
            case .Cons(let head, let tail):
                return .Cons(head: head, tail: { tk(stream: tail(), n: n-1) })
            }
        }
        return tk(stream: self, n: n)
    }
    
    func drop(n: Int) -> StreamEnum<T> {
        func dp(stream: Self, n: Int) -> Self {
            guard n > 0 else { return stream }
            
            switch stream {
            case .Empty:
                return .Empty
            case .Cons(_, let tail):
                if n == 1 {
                    return tail()
                } else {
                    return dp(stream: tail(), n: n-1)
                }
            }
        }
        return dp(stream: self, n: n)
    }
}

public func c5_2p2() {
    let stream = StreamEnum.of(1,2,3,4)
    
    printProblem(chapter: "5.2", problem: "2") {
        printAnswer("Original stream:    ", stream)
        // take
        printAnswer("StreamEnum.take(n: 2): ", stream.take(n: 2)) // 1,2
        printAnswer("StreamEnum.take(n: 5): ", stream.take(n: 5)) // 1,2,3,4
        // drop
        printAnswer("StreamEnum.drop(n: 2): ", stream.drop(n: 2)) // 3,4
        printAnswer("StreamEnum.drop(n: 5): ", stream.drop(n: 5)) // Empty
    }
}

extension StreamEnum {
    func takeWhile(p: @escaping (T) -> Bool) -> StreamEnum<T> {
        func tw(stream: Self, p: @escaping (T) -> Bool) -> StreamEnum<T> {
            switch stream {
            case .Empty:
                return .Empty
            case .Cons(let head, let tail):
                if p(head()) {
                    return .Cons(head: head, tail: { tw(stream: tail(), p: p) } )
                } else {
                    return .Empty
                }
            }
        }
        return tw(stream: self, p: p)
    }
}

public func c5_2p3() {
    let stream = StreamEnum.of(2,4,3,4)
    let takeWhileEvenNumber = stream.takeWhile(p: { $0 % 2 == 0 })
    
    printProblem(chapter: "5.2", problem: "3") {
        printAnswer("Original stream:                 ", stream)
        printAnswer("StreamEnum.takeWhile(p: isEven): ", takeWhileEvenNumber) // 2,4
    }
}

extension StreamEnum {
    func forAll(p: @escaping (T) -> Bool) -> Bool {
        func fa(stream: Self, p: @escaping (T) -> Bool) -> Bool {
            switch stream {
            case .Empty:
                return true
            case .Cons(let head, let tail):
                if p(head()) {
                    return fa(stream: tail(), p: p)
                } else {
                    return false
                }
            }
        }
        return fa(stream: self, p: p)
    }
}

public func c5_2p4() {
    let evenStream = StreamEnum.of(2,4,6,8)
    let nonEvenStream = StreamEnum.of(2,4,7,8)
    
    printProblem(chapter: "5.2", problem: "4") {
        let isEven: (Int) -> Bool = { $0 % 2 == 0 }
        
        printAnswer("evenStream                     :", evenStream)
        printAnswer("evenStream.forAll(p: isEven)   :", evenStream.forAll(p: isEven))
        printAnswer("nonEvenStream                  :", nonEvenStream)
        printAnswer("nonEvenStream.forAll(p: isEven):", nonEvenStream.forAll(p: isEven))
    }
}

extension StreamEnum {
    func foldRight<B>(z: @escaping () -> B, f: @escaping (T, @escaping () -> B) -> B) -> B {
        switch self {
        case .Empty:
            return z()
        case .Cons(let head, let tail):
            return f(head(), { tail().foldRight(z:z, f: f) } )
        }
    }
}

extension StreamEnum {
    func takeWhile(withFoldRight p: @escaping (T) -> Bool) -> StreamEnum<T> {
        return self.foldRight(z: { StreamEnum<T>.Empty }) { headValue, tailStream in
            if p(headValue) {
                return .Cons(head: { headValue }, tail: tailStream)
            } else {
                return .Empty
            }
        }
    }
}

public func c5_2p5() {
    let stream = StreamEnum.of(2,4,3,4)
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let takeWhileEvenNumber = stream.takeWhile(withFoldRight: isEven)
    
    printProblem(chapter: "5.2", problem: "3") {
        printAnswer("Original stream:                             ", stream)
        printAnswer("StreamEnum.takeWhile(withFoldRight: isEven): ", takeWhileEvenNumber) // 2,4
    }
}

extension StreamEnum {
    //    func headOption() -> T? {
    //        switch self {
    //        case .Empty:
    //            return nil
    //        case .Cons(let head, _):
    //            return head()
    //        }
    //    }
    func headOptionWithFoldRight() -> T? {
        return self.foldRight(z: { return nil }) { headValue, _ in
            return headValue
        }
    }
}

public func c5_2p6() {
    let stream = StreamEnum.of(1,2,3,4)
    let emptyStream = StreamEnum<Int>.Empty
    printProblem(chapter: "5.2", problem: "6") {
        printAnswer("stream", stream)
        printAnswer("headOptionWithFoldRight: Cons ", stream.headOptionWithFoldRight())
        printAnswer("emptyStream", emptyStream)
        printAnswer("headOptionWithFoldRight: Empty ", emptyStream.headOptionWithFoldRight())
    }
}

extension StreamEnum {
    func map<B>(f: @escaping (T) -> B) -> StreamEnum<B> {
        return self.foldRight(z: { return .Empty }) { headValue, tailStream in
            return .Cons(head: { f(headValue) }, tail: tailStream)
        }
    }
    
    func filter(f: @escaping (T) -> Bool) -> StreamEnum<T> {
        return self.foldRight(z: { return .Empty }) { headValue, tailStream in
            if f(headValue) {
                return .Cons(head: { headValue }, tail: tailStream)
            } else {
                return tailStream()
            }
        }
    }
    
    mutating func append(element: T) {
        self = self.foldRight(z: { StreamEnum<T>.Cons(head: { element }, tail: { .Empty }) }, f: { headValue, tailStream in
            return .Cons(head: { headValue }, tail: tailStream)
        })
    }
}

public func c5_2p7() {
    var stream = StreamEnum.of(1,2,3)
    
    printProblem(chapter: "5.2", problem: "7") {
        printAnswer("stream:", stream)
        
        printAnswer("stream.map(+10):", stream.map { $0 + 10 } ) // 11, 12, 13
        printAnswer("stream.map(Stringify):", stream.map { "str_" + String($0) } )
        printAnswer("stream.filter(isEven):", stream.filter { $0 % 2 == 0 } ) // 2
        
        stream.append(element: 10)
        printAnswer("stream after .append(10):", stream) // 1, 2, 3, 10
    }
}

extension StreamEnum {
    static func constant(of element: T) -> StreamEnum<T> {
        return .Cons(head: { element }, tail: { constant(of: element) })
    }
}

public func c5_2p8() {
    let twos = StreamEnum.constant(of: 2)
    
    printProblem(chapter: "5.2", problem: "8") {
        var headStream: StreamEnum<Int> = twos
        for i in 1..<10 {
            switch headStream {
            case .Cons(let head, let tail):
                printAnswer("\(i)th head: ", head())
                headStream = tail()
            case .Empty:
                printAnswer("Empty")
            }
        }
    }
}

extension StreamEnum where T == Int {
    static func from(n: T) -> StreamEnum<T> {
        return .Cons(head: { n }, tail: { from(n: n+1)} )
    }
}

public func c5_2p9() {
    let fromTwoThousand = StreamEnum.from(n: 2_000)
    
    printProblem(chapter: "5.2", problem: "9") {
        var headStream: StreamEnum<Int> = fromTwoThousand
        for i in 1..<10 {
            switch headStream {
            case .Cons(let head, let tail):
                printAnswer("\(i)th head: ", head())
                headStream = tail()
            case .Empty:
                printAnswer("Empty")
            }
        }
    }
}

extension StreamEnum where T == Int {
    static func fibs() -> StreamEnum<T> {
        func fb(current: T, next: T) -> StreamEnum<T> {
            return .Cons(head: { current }, tail: { fb(current: next, next: current + next) })
        }
        return fb(current: 0, next: 1)
    }
}

public func c5_2p10() {
    let fibsStream = StreamEnum.fibs()
    
    printProblem(chapter: "5.2", problem: "10") {
        var headStream: StreamEnum<Int> = fibsStream
        for i in 1..<11 {
            switch headStream {
            case .Cons(let head, let tail):
                printAnswer("\(i)th head: ", head())
                headStream = tail()
            case .Empty:
                printAnswer("Empty")
            }
        }
    }
}

extension StreamEnum {
    // z: initial status
    // f: function that creates next status and next value of stream
    func unfold<S>(z: S, f: @escaping (S) -> (T, S)?) -> StreamEnum<T> {
        switch f(z) {
        case .some(let pair):
            return .Cons(head: { pair.0 }, tail: { unfold(z: pair.1, f: f) })
        case .none:
            return .Empty
        }
    }
}

// extension for problem 11
extension Date {
    static var currentTimeStamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

public func c5_2p11() {
    let runForTwoMilliSecond: (Int64) -> (String, Int64)? = { originalTimeStamp in
        let currentTimeStamp = Date.currentTimeStamp
        if currentTimeStamp - originalTimeStamp > 2 {
            return nil
        } else {
            return ("Executed in \(currentTimeStamp)", originalTimeStamp)
        }
    }
    
    let streamOfTwo = StreamEnum.constant(of: "2")
    
    printProblem(chapter: "5.2", problem: "11") {
        var headStream = streamOfTwo.unfold(z: Date.currentTimeStamp, f: runForTwoMilliSecond)
        var i: Int = 0
        
        // Labeled Statements: escape while loop inside a switch https://docs.swift.org/swift-book/documentation/the-swift-programming-language/controlflow/#Labeled-Statements
    outerLoop: while (true) {
        switch headStream {
        case .Cons(let head, let tail):
            printAnswer("\(i)th head: ", head())
            headStream = tail()
            i += 1
        case .Empty:
            printAnswer("Empty")
            break outerLoop
        }
    }
    }
}

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
    func takeWhile(p: (T) -> Bool) -> StreamEnum<T> {
        func tw(stream: Self, p: (T) -> Bool) -> StreamEnum<T> {
            switch stream {
            case .Empty:
                return .Empty
            case .Cons(let head, let tail):
                if p(head()) {
                    return tw(stream: tail(), p: p)
                } else {
                    return .Empty
                }
            }
        }
        return tw(stream: self, p: p)
    }
}

public func c5_2p3() {
    let stream = StreamEnum.of(2,2,3,4)    
}

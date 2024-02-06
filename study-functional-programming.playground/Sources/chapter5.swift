import Foundation

public func c5p0() {
    func lazyIf<A>(condition: Bool, onTrue: () -> A, onFalse: () -> A) -> A {
        return condition ? onTrue() : onFalse()
    }
    
//    var y = lazyIf(condition: (a < 22), onTrue: {
//        print("a")
//    }, onFalse: {
//        print("b")
//    })
}

// 5.2 확장 예제: 지연 리스트
class Stream<A> {
    var head: (() -> A)?
    var tail: (() -> Stream<A>)?
    
    init(head: (() -> A)?, tail: (() -> Stream<A>)?) {
        self.head = head
        self.tail = tail
    }
    
    var isEmpty: Bool { head == nil }
    static var empty: Stream<A> {
        return Stream(head: nil, tail: nil)
    }
}

// Option is defined in chapter4
extension Stream {
    func headOption() -> Option<A> {
        guard let head = self.head else { return .none }
        
        return .some(head())
    }
}

// chapter 5 problem 1
extension Stream {
    /// List is defined in ``chapter3.swift``
    func toList() -> List<A> {
        return List(head: self.head?(), next: self.tail?().toList())
    }
}

public func c5p1() {
    let stream = Stream { 1 } tail: {
        return Stream(head: { 2 }, tail: {
            return Stream(head: { 3 }, tail: nil)
        })
    }

    let streamToList = stream.toList()
    
    printProblem(chapter: 5, problem: 1) {
        printAnswer(streamToList.head) // 1
        printAnswer(streamToList.next?.head) // 2
    }
}


// chapter 5 problem 2

extension Stream {
    func take(n: Int) -> Stream<A> {
        func tk(stream: Stream<A>, n: Int) -> Stream<A> {
            if stream.isEmpty {
                return Stream<A>.empty
            } else if n == 0 {
                return .empty
            } else {
                return Stream(head: stream.head, tail: { tk(stream: stream.tail?() ?? .empty, n: n-1) })
            }
        }
        return tk(stream: self, n: n)
    }
    
    func drop(n: Int) -> Stream<A> {
        func dp(stream: Stream<A>, n: Int) -> Stream<A> {
            if stream.isEmpty {
                return Stream<A>.empty
            } else if n == 0 {
                return stream
            } else if n == 1 {
                return stream.tail?() ?? .empty
            } else {
                return dp(stream: stream.tail?() ?? .empty, n: n-1)
            }
        }
        return dp(stream: self, n: n)
    }
}

public func c5p2() {
    let stream = Stream { 1 } tail: {
        return Stream(head: { 2 }, tail: {
            return Stream(head: { 3 }, tail: {
                return Stream(head: { 4 }, tail: nil)
            })
        })
    }
    
    let oldList = stream.toList()

    let takenStream = stream.take(n: 2)
    let newListTakeTwo = takenStream.toList()
    
    let droppedStream = stream.drop(n: 1)
    let newListDropOne = droppedStream.toList()
    
    printProblem(chapter: 5, problem: 2) {
        //        Optional(1)
        //         Optional(2)
        //         Optional(3)
        //         Optional(4)
        printAnswer(oldList.head)
        printAnswer(oldList.next?.head)
        printAnswer(oldList.next?.next?.head)
        printAnswer(oldList.next?.next?.next?.head)
        printAnswer(" ---- ")
        
        //          ----
        //         Optional(1)
        //         Optional(2)
        //         nil
        //         nil
        
        printAnswer(newListTakeTwo.head)
        printAnswer(newListTakeTwo.next?.head)
        printAnswer(newListTakeTwo.next?.next?.head)
        printAnswer(newListTakeTwo.next?.next?.next?.head)
        printAnswer(" ---- ")
        
        //          ----
        //         Optional(2)
        //         Optional(3)
        //         Optional(4)
        //         nil
        printAnswer(newListDropOne.head)
        printAnswer(newListDropOne.next?.head)
        printAnswer(newListDropOne.next?.next?.head)
        printAnswer(newListDropOne.next?.next?.next?.head)
    }
}

extension Stream {
    func takeWhile(p: @escaping (A) -> Bool) -> Stream<A> {
        func tw(stream: Stream<A>, p: @escaping (A) -> Bool) -> Stream<A> {
            guard let head = stream.head?() else { return .empty }
            if p(head) {
                return Stream(head: { head }, tail: { tw(stream: stream.tail?() ?? .empty, p: p) })
            } else {
                return .empty
            }
        }
        return tw(stream: self, p: p)
    }
}

public func c5p3() {
    let stream = Stream { 4 } tail: {
        return Stream(head: { 2 }, tail: {
            return Stream(head: { 3 }, tail: {
                return Stream(head: { 4 }, tail: nil)
            })
        })
    }
    
    let oldList = stream.toList()
    
    let takeWhileEvenNumber = stream.takeWhile(p: { $0 % 2 == 0 })
    let newList = takeWhileEvenNumber.toList()
    
    
    printProblem(chapter: 5, problem: 3) {
        //        Optional(1)
        //         Optional(2)
        //         Optional(3)
        //         Optional(4)
        printAnswer(oldList.head)
        printAnswer(oldList.next?.head)
        printAnswer(oldList.next?.next?.head)
        printAnswer(oldList.next?.next?.next?.head)
        printAnswer(" ---- ")
        
        //          ----
        //         Optional(1)
        //         Optional(2)
        //         nil
        //         nil
        
        printAnswer(newList.head)
        printAnswer(newList.next?.head)
        printAnswer(newList.next?.next?.head)
        printAnswer(newList.next?.next?.next?.head)
        printAnswer(" ---- ")
    }
}











//private func foldRight<A, B>(xs: List<A>, z: B, f: (A, B) -> B) -> B {
//    guard let head = xs.head else { return z }
//
//    return f(head, foldRight(xs: xs.next, z: z, f: f))
//}
//


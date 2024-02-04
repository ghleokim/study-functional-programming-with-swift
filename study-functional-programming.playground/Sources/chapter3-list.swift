import Foundation

func c3p0() {
    print(" ------------------ ")
    print("chapter 3 problem 0")
    
    print(" ------------------ ")
}

// 3.1. 함수형 데이터 구조 정의하기
///
/// 함수형 데이터 구조는 순수함수만으로 조작된다.
/// 순수 함수는 제자리에서 데이터를 변경하거나 부수효과를 수행해서는 안된다. 정의상 불변이다.
///
func chapter3_1() {
    // 단일 연결 리스트 데이터구조 정의
    
    class List<A> {}
    
    typealias Nothing = Optional<Any>
    class Nil: List<Nothing> {}
    class Cons<A>: List<A> {
        var head: A
        var tail: List<A>?
        init(head: A, tail: List<A>?) {
            self.head = head
            self.tail = tail
        }
    }
    
    var ex1: List<Double>? = nil
    var ex2: List<Int> = Cons(head: 1, tail: nil)
    var ex3: List<String> = Cons(head: "a", tail: Cons(head: "b", tail: nil))
}


class List<T> {
    let head: T
    var next: List<T>?
    
    init(head: T, next: List<T>?) {
        self.head = head
        self.next = next
    }
}

public func c3p1() {
    // List의 첫번째 원소를 제거하는 tail 함수 구현
    func tail<T>(xs: List<T>) -> List<T>? {
        guard let next = xs.next else { return nil }
        return List(head: next.head, next: next.next)
    }
    
//    print(" ------------------ ")
    print("chapter 3 problem 1")
    let length3list = List(head: 10, next: List(head: 9, next: List(head: 8, next: nil)))
    printAnswer(tail(xs: length3list), tail(xs: length3list)?.head)
    
    let length1list = List(head: 123, next: nil)
    printAnswer(tail(xs: length1list))
    
    print(" ------------------ ")
}

public func c3p2() {
    // setHead 함수 작성
    func setHead<T>(xs: List<T>, x: T) -> List<T> {
        return List(head: x, next: xs.next)
    }
}

public func c3p3() {
    // drop 함수 작성
    func drop<T>(l: List<T>, n: Int) -> List<T>? {
        guard n > 0 else { return l }
        guard let next = l.next else { return nil }
        
        return drop(l: next, n: n-1)
    }
    
//    print(" ------------------ ")
    print("chapter 3 problem 3")
    let length3list = List(head: 10, next: List(head: 9, next: List(head: 8, next: nil)))
    let droppedlist = drop(l: length3list, n: 2)
    printAnswer(droppedlist?.head)
    print(" ------------------ ")

}

public func c3p4() {
    // dropWhile 구현. 이 함수는 인자로 주어진 함수를 만족하는 연속적인 원소를 삭제한다.
    func dropWhile<T>(l: List<T>, f: (T) -> Bool) -> List<T>? {
        guard f(l.head) == true else { return l }
        guard let next = l.next else { return nil }
        
        return dropWhile(l: next, f: f)
    }
    
//    print(" ------------------ ")
    print("chapter 3 problem 4")
    let list = List(head: 10, next: List(head: 12, next: List(head: 8, next: List(head: 7, next: List(head: 6, next: List(head: 5, next: nil))))))
    let droppedlist = dropWhile(l: list, f: { ($0 % 2) == 0 }) // drop 짝수 접두사
    print(droppedlist?.head) // 7
    print(droppedlist?.next?.head) // 6
    print(" ------------------ ")
}

public func c3p5() {
    
}


import Foundation

// Define Option
public enum Option<Wrapped> {
    case none
    case some(Wrapped)
    
    init(_ value: Wrapped?) {
        if let value = value {
            self = .some(value)
        } else {
            self = .none
        }
        return
    }
}

/// 연습문제 4.1. option 함수 구현하기
extension Option {
    func map<B>(_ f: (Wrapped) -> B) -> Option<B> {
        switch self {
        case .some(let value):
            return .some(f(value))
        case .none:
            return .none
        }
    }
    
    func flatMap<B>(_ f: (Wrapped) -> Option<B>) -> Option<B> {
        switch self {
        case .some(let value):
            return f(value)
        case .none:
            return .none
        }
    }
    
    func getOrElse(_ `default`: () -> Wrapped) -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return `default`()
        }
    }
    
    func orElse(_ ob: () -> Option<Wrapped>) -> Option<Wrapped> {
        switch self {
        case .some(_):
            return self
        case .none:
            return ob()
        }
    }
    
    func filter(_ f: (Wrapped) -> Bool) -> Option<Wrapped> {
        switch self {
        case .some(let value):
            if f(value) { return self }
            fallthrough
        case .none:
            return .none
        }
    }
}

public func c4p1() {
    printProblem(chapter: 4, problem: 1) {
        /// using map function and Option enum
        let optionalValue: Option = .some("Hello")
        let uppercased = optionalValue.map { $0.uppercased() }
        printAnswer("Map: string uppercase -> ", uppercased)
        
        /// following use case from book
        class Employee {
            public var name: String
            public var department: String
            public var manager: Option<String> = .none
            
            init(name: String, department: String) {
                self.name = name
                self.department = department
            }
        }
        func lookupByName(name: String) -> Option<Employee> {
            return .some(Employee(name: name, department: "HR"))
//            return .none
        }
        
        func timDepartment() -> Option<String> {
            lookupByName(name: "Tim").map { $0.department }
        }
        
        printAnswer("TimDepartment -> ", timDepartment())
        
        let manager: String = lookupByName(name: "Tim")
            .flatMap { $0.manager }
            .getOrElse { "Unemployed" }
        
        printAnswer("manager -> ", manager)
    }
}

public func c4p2() {
    printProblem(chapter: 4, problem: 2) {
        /// Flatmap을 이용해 variance 함수 구하기
        /// - variance: 시퀀스의 평균이 m일 때, 시퀀스의 원소 (x - m)^2 의 평균.
        func mean(sequence: [Double]) -> Option<Double> {
            guard !sequence.isEmpty else { return .none }
            let sum = sequence.reduce(0, +)
            return .some(sum / Double(sequence.count))
        }
        
        func variance(sequence: [Double]) -> Option<Double> {
            guard !sequence.isEmpty else { return .none }
            let mean = mean(sequence: sequence)
            return mean.flatMap { mean in
                let sumOfSquaredDeviations = sequence.map { pow(($0 - mean), 2) }.reduce(0, +)
                return .some(sumOfSquaredDeviations / Double(sequence.count))
            }
        }
        
        let sequence: [Double] = [4.2, 10, 3, 7, 8.3]
        
        printAnswer("getting variance of sequence \(sequence) -> ", variance(sequence: sequence))
    }
}

public func c4e1() {
    // 함수 끌어올리기

    func lift<A, B>(_ f: @escaping (A) -> B) -> (Option<A>) -> Option<B> {
        return { $0.map(f) }
    }

    printExample(chapter: 4) {
        printAnswer("Example: Lift")
        
        let liftedSqrt = lift(sqrt)
        let optionalDouble: Option<Double> = .some(16)
        printAnswer(liftedSqrt(optionalDouble))
    }
}

public func c4p3() {
    printProblem(chapter: 4, problem: 3) {
        func map2<A,B,C>(a: Option<A>, b: Option<B>, f: (A,B) -> C) -> Option<C> {
            // SOLUTION_HERE
            return a.flatMap { val_A in
                return b.flatMap { val_B in
                    return .some(f(val_A, val_B))
                }
            }
        }
        
        // `insuranceRate` function with Integer parameters
        func insuranceRateQuote(_ age: Int, _ speedingTickets: Int) -> Double {
            return Double(age * speedingTickets)
        }
        
        
        // map2를 사용하면 기존의 insuranceRateQuote 함수를 재사용하면서
        // age, speeding Tickets 어느 것 하나라도 .none일 경우 결과가 .none을 리턴하도록 만들 수 있다.
        func parseInsuranceRateQuote(age: String, speedingTickets: String) -> Option<Double> {
            let optAge: Option<Int> = .init(Int(age))
            let optTickets: Option<Int> = .init(Int(speedingTickets))
            
            return map2(a: optAge, b: optTickets) { a, t in
                insuranceRateQuote(a, t)
            }
        }
        
        //    some(15129.0)
        printAnswer(parseInsuranceRateQuote(age: "123", speedingTickets:"123"))

        //     none
        printAnswer(parseInsuranceRateQuote(age: "stringage", speedingTickets: "10"))
    }
}

public func c4p4() {
    printProblem(chapter: 4, problem: 4) {
        // 원소가 Option인 리스트를 원소라 리스트인 Option으로 합쳐주는 sequence 함수를 작성.
        // 반환되는 Option의 원소는 원래 리스트에서 Some인 값만 모은 리스트.
        // 원래 리스트에 none이 하나라도 있으면 결괏값이 none.
        // 그렇지 않으면 모든 정상 값이 들어있는 리스트의 옵션.
        
        // Define List<A>
        class List<A> {
            let head: A
            let next: Option<List<A>>
            
            init(head: A, next: Option<List<A>>) {
                self.head = head
                self.next = next
            }
        }
//
//        func foldRight<X, Y>(xs: List<X>, z: Y, f: @escaping (X, Y) -> Y) -> Y {
//            switch xs.next {
//            case .none:
//                return z
//            case .some(let tail):
//                return f(xs.head, foldRight(xs: tail, z: z, f: f))
//            }
//        }
//
        func map2<A,B,C>(a: Option<A>, b: Option<B>, f: (A,B) -> C) -> Option<C> {
            // SOLUTION_HERE
            return a.flatMap { val_A in
                return b.flatMap { val_B in
                    return .some(f(val_A, val_B))
                }
            }
        }
        
//        func sequence<A>(xs: [Option<A>]) -> Option<[A]> {
//            var b: Option<[A]> = .some([])
//
//            xs.forEach { element in
//                map2(a: element, b: b) { a, b in
//                    b.append(a)
//                    return
//                }
//            }
//        }
    }
}

public func c4p5() {
    // traverse 함수를 구현하라.
    
    // Define List<A>
    class List<A>: CustomStringConvertible {
        let head: A
        let next: Option<List<A>>
        
        init(head: A, next: Option<List<A>>) {
            self.head = head
            self.next = next
        }
        
        var description: String {
            var resultString = "\(self.head),"
            switch self.next {
            case .some(let value):
                resultString += value.description
            case .none:
                resultString += "end."
            }
            return resultString
        }
    }
    
    // map2 가져오기
    func map2<A,B,C>(a: Option<A>, b: Option<B>, f: (A,B) -> C) -> Option<C> {
        return a.flatMap { val_A in
            return b.flatMap { val_B in
                return .some(f(val_A, val_B))
            }
        }
    }
    
    func traverse<A, B>(xa: List<A>, f: (A) -> Option<B>) -> Option<List<B>> {
        return map2(a: xa.next, b: f(xa.head)) { a, b in
            print(a, b)
            return List(head: b, next: traverse(xa: a, f: f))
        }
    }
    
    // traverse: List<Option<A>> 를 Option<List<B>>로 만들어줄 수 있다.
    let testList: List<String> = List(head: "10",
                                      next: .some(List(head: "123",
                                                       next: .some(List(head: "456", next: .none)))))
    let resultList = traverse(xa: testList) { str in
        return Option.init(Int(str))
    }
    
    printProblem(chapter: 4, problem: 5) {
        printAnswer(resultList)
    }
    
    let testList2: List<String> = List(head: "10",
                                      next: .some(List(head: "abc",
                                                       next: .some(List(head: "456", next: .none)))))
    let resultList2 = traverse(xa: testList2) { str in
        return Option.init(Int(str))
    }
    
    printProblem(chapter: 4, problem: 5_2) {
        printAnswer(resultList2)
    }
}

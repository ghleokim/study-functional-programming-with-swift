import Foundation

public func c4p0() {
    print(" ------------------ ")
    print("chapter 4 problem 0")
    
    print(" ------------------ ")
}

// Option

enum Option<Wrapped> {
    case none
    case some(Wrapped)
    
    init(_ value: Wrapped?) {
        guard let value = value else {
            self = .none
            return
        }
        self.init(value)
    }
}

// p117 Option 데이터 타입 개선하기
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
        case .some(let value):
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
        var optionalValue: Option = .some("Hello")
        var uppercased = optionalValue.map { $0.uppercased() }
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
        
        var liftedSqrt = lift(sqrt)
        var optionalDouble: Option<Double> = .some(16)
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
        
        func insuranceRateQuote(_ age: Int, _ speedingTickets: Int) -> Double {
            return Double(age * speedingTickets)
        }
        
        func parseInsuranceRateQuote(age: String, speedingTickets: String) -> Option<Double> {
            var optAge: Option<Int> = .init(Int(age))
            var optTickets: Option<Int> = .init(Int(speedingTickets))
            
            print(age, speedingTickets, optAge, optTickets)
            return map2(a: optAge, b: optTickets) { a, t in
                insuranceRateQuote(a, t)
            }
        }
        
        printAnswer(parseInsuranceRateQuote(age: "123", speedingTickets:"123"))
    }
}



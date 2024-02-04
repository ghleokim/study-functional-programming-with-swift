import Foundation

public func printExample(chapter: Int, _ answer: () -> ()) {
    print("chapter \(chapter) example")
    answer()
    print(" ------------------ ")
}

public func printProblem(chapter: Int, problem: Int, _ answer: () -> ()) {
    print("chapter \(chapter) problem \(problem)")
    answer()
    print(" ------------------ ")
}

public func printAnswer(_ items: Any...) {
    print("     ", terminator: "")
    items.forEach { print($0, terminator: " ")}
    print()
}

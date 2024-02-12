import Foundation

public func printChapter(chapter: String, _ problems: () -> ()) {
    print()
    print("     chapter \(chapter)")
    print(" ------------------ ")
    problems()
}

public func printChapter(chapter: Int, _ problems: () -> ()) {
    printChapter(chapter: "\(chapter)", problems)
}

public func printExample(chapter: String, _ answer: () -> ()) {
    print("chapter \(chapter) example")
    answer()
    print(" ------------------ ")
}

public func printExample(chapter: Int, _ answer: () -> ()) {
    printExample(chapter: "\(chapter)", answer)
}

public func printProblem(chapter: String, problem: String, _ answer: () -> ()) {
    print("chapter \(chapter) problem \(problem)")
    answer()
    print(" ------------------ ")
}

public func printProblem(chapter: Int, problem: Int, _ answer: () -> ()) {
    printProblem(chapter: "\(chapter)", problem: "\(problem)", answer)
}

public func printAnswer(_ items: Any...) {
    print("     ", terminator: "")
    items.forEach { print($0, terminator: " ")}
    print()
}

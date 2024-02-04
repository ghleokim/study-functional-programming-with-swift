import Foundation

// Not implemented yet
//
//class Tree<A> {}
//class Leaf<A>: Tree {
//    let value: A
//    
//    init(value: A) {
//        self.value = value
//    }
//}
//
//class Branch<A>: Tree {
//    let left: Tree<A>
//    let right: Tree<A>
//    
//    init(left: Tree<A>, right: Tree<A>) {
//        self.left = left
//        self.right = right
//    }
//}
//
//
//public func c3p24() {
//    // 노드 leaf, branch의 개수를 반환하는 size함수를 작성
//    func size(tree: Tree, n: Int = 0) -> Int {
//        if let _ = tree as? Tree { return 0 }
//        if let _ = tree as? Leaf { return 1 }
//        
//        guard let tree = tree as? Branch else { return 0 }
//        return size(tree.left, 1) + size(tree: tree.right, n: 1)
//    }
//    
//    ///      B
//    ///      / \
//    ///     B   B
//    ///     /    / \
//    ///    3    4  5
//    ///
//    let tree = Branch(left: Branch(left: Leaf(value: 3),
//                                   right: Tree()),
//                      right: Branch(left: Leaf(value: 4),
//                                    right: Leaf(value: 5)))
//    
//    print(size(tree: tree))
//}

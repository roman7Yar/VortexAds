import Foundation


// you can write to stdout for debugging purposes, e.g.
// print("this is a debug message")

public func solution(_ A : inout [Int], _ K : Int) -> [Int] {
    
    if K == 0 || A.count == 0 {
        return A
    } else if A.count < K {
        var arr: [Int] = []
        for _ in K - A.count..<K {
            
            let lastElement = A.last
            A.removeLast()
            arr.append(lastElement!)
        }
        arr.reverse()
        
        return arr + A
    }
    var arr: [Int] = []
    
    for _ in 0..<K {
        
        let lastElement = A.last
        A.removeLast()
        arr.append(lastElement!)
    }
    arr.reverse()
    
    return arr + A
}
//public func solution(_ A : [Int], _ K : Int) -> [Int] {
//    var newA = A
//    if A.count < K || K == 0 || A.count == 0 {
//        return A
//    }
//    var arr: [Int] = []
//    for _ in 0..<K {
//        let lastElement = newA.last
//        newA.removeLast()
//        arr.append(lastElement!)
//    }
//    arr.reverse()
//    newA = arr + newA
//    return newA
//}

solution([1,2,3,4,5,6,7,8], 6)
//solution([0], 3)

if A.count < K || K == 0 || A.count == 0 {
        return A
    }
    var arr: [Int] = []
    
    for _ in 0..<K {
        
        let lastElement = A.last
        A.removeLast()
        arr.append(lastElement!)
    }
    arr.reverse()
    
    return arr + A

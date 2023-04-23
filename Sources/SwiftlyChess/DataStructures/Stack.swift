//
//  Stack.swift
//
//  Created by Jeffrey Thompson on 1/22/23.
//

import Foundation

struct Stack<Element> {
    
    private var collection = [Element]()
    var count: Int { collection.count }
    
    func peek() -> Element? {
        collection.last
    }
    
    mutating func push(_ element: Element) {
        collection.append(element)
    }
    
    @discardableResult
    mutating func pop() -> Element? {
        collection.popLast()
    }
    
    func suffix(maxLength: Int) -> [Element] {
        collection.suffix(maxLength)
    }
    
}

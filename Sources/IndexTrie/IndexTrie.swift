//
//  IndexTrie.swift
//  IndexTrieTest
//
//  Created by buza on 1/4/20.
//  Copyright © 2020 BuzaMoto. All rights reserved.
//

import Foundation

public class IndexTrie<T : Comparable & Codable & Hashable> : Codable {

    private struct PendingItem: Codable {
        let string: String
        let index: T
    }
    
    private class IndexTrieNode : Codable {
        var index                   : T?
        var childIndices            = Array<T>()
        private var childIndicesSet = Set<T>() // Fast O(1) lookups for duplicates
        var parent                  : IndexTrieNode?
        var children                = Dictionary<String, IndexTrieNode>()
        lazy var pending            = Array<(string:String, index:T)>()
        
        init(index:T, parent:IndexTrieNode?=nil) {
            self.index = index
            self.parent = parent
        }
        
        func insertIndexOptimized(_ index: T) -> Bool {
            // Fast O(1) duplicate check using Set
            guard childIndicesSet.insert(index).inserted else {
                return false // Already exists
            }
            
            // Binary search for insertion position (O(log n))
            var left = 0
            var right = childIndices.count
            while left < right {
                let mid = (left + right) / 2
                if childIndices[mid] < index {
                    left = mid + 1
                } else {
                    right = mid
                }
            }
            childIndices.insert(index, at: left)
            return true
        }
        
        private enum CodingKeys: String, CodingKey {
            case index
            case childIndices
            case children
            case pending
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            index = try container.decodeIfPresent(T.self, forKey: .index)
            childIndices = try container.decode([T].self, forKey: .childIndices)
            childIndicesSet = Set(childIndices) // Rebuild set from array
            children = try container.decode([String: IndexTrieNode].self, forKey: .children)
            let pendingItems = try container.decode([PendingItem].self, forKey: .pending)
            pending = pendingItems.map { (string: $0.string, index: $0.index) }
            parent = nil // Will be restored during trie reconstruction
            
            // Restore parent relationships
            for child in children.values {
                child.parent = self
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(index, forKey: .index)
            try container.encode(childIndices, forKey: .childIndices)
            try container.encode(children, forKey: .children)
            let pendingItems = pending.map { PendingItem(string: $0.string, index: $0.index) }
            try container.encode(pendingItems, forKey: .pending)
            // Note: parent is not encoded to avoid circular references
        }
    }

    private var lazyLimit = -1;
    private var rootDict : Dictionary<String, IndexTrieNode>!
    
    public init(lazyLimit: Int = -1) {
        self.lazyLimit = lazyLimit
        rootDict = Dictionary<String, IndexTrieNode>()
    }
    
    private enum CodingKeys: String, CodingKey {
        case lazyLimit
        case rootDict
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lazyLimit = try container.decode(Int.self, forKey: .lazyLimit)
        rootDict = try container.decode([String: IndexTrieNode].self, forKey: .rootDict)
        
        // Restore parent relationships for root nodes
        for rootNode in rootDict.values {
            rootNode.parent = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lazyLimit, forKey: .lazyLimit)
        try container.encode(rootDict, forKey: .rootDict)
    }
    
    public func clear() {
        rootDict.removeAll()
    }

    private func getIndicesWithParent(_ characters: [Character],
                                      parentNode: IndexTrieNode? = nil,
                                      offset: Int = 0) -> Array<T>? {
        guard offset < characters.count else {
            if parentNode?.childIndices.isEmpty ?? false {
                if let item = parentNode?.index {
                    return [item]
                }
            }
            return parentNode?.childIndices
        }
        
        //Because the node index itself is useless (always is the first used to generate it), need to add a pair
        //to the pending list and use that
        if let parent = parentNode, !parent.pending.isEmpty {
            parent.pending.forEach( { 
                let chars = Array($0.string)
                add(chars, index: $0.index, parentNode:parent) 
            })
            parent.pending.removeAll()
        }

        let charKey = String(characters[offset])

        let tn : IndexTrieNode? = (parentNode != nil ? parentNode?.children[charKey] : rootDict[charKey])
        
        guard let foundNode = tn else {
            return nil
        }
        
        return getIndicesWithParent(characters, parentNode:foundNode, offset:offset+1)
    }
    
    private func insertIndex(_ node: IndexTrieNode, index: T) {
        _ = node.insertIndexOptimized(index)
    }

    private func add(_ characters: [Character], index: T, parentNode: IndexTrieNode? = nil, charOffset: Int = 0) {
        guard charOffset < characters.count else {
            if let parent = parentNode {
                insertIndex(parent, index: index)
            }
            return
        }

        let charKey = String(characters[charOffset])
  
        if lazyLimit == charOffset {
            let remainingChars = Array(characters[charOffset...])
            let remain = String(remainingChars)
            if let parentNodeVal = parentNode {
                insertIndex(parentNodeVal, index: index)
            }
            parentNode?.pending.append((remain, index))
            return
        }

        var tn : IndexTrieNode? = (parentNode != nil ? parentNode?.children[charKey] : rootDict[charKey])
        if let node = tn {
            node.parent = parentNode
            parentNode?.children[charKey] = node
        } else {
            tn = IndexTrieNode(index:index, parent:parentNode)
            tn!.parent?.children[charKey] = tn
        }
        
        if parentNode == nil {
            rootDict[charKey] = tn
        }
        
        add(characters, index:index, parentNode: tn, charOffset: charOffset+1)
        
        // Update parent indices only once at the end of recursion
        if let parentNodeVal = parentNode {
            insertIndex(parentNodeVal, index: index)
        }
    }
        
    public func getIndices(_ string: String) -> Array<T>? {
        let characters = Array(string)
        return getIndicesWithParent(characters)
    }
    
    public func addString(_ string: String, index: T) {
        let characters = Array(string)
        add(characters, index:index)
    }
}

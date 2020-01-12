//
//  IndexTrie.swift
//  IndexTrieTest
//
//  Created by buza on 1/4/20.
//  Copyright © 2020 BuzaMoto. All rights reserved.
//

import Foundation

public class IndexTrie<T : Comparable> {

    private class IndexTrieNode {
        var index                   : T?
        var childIndices            = Array<T>()
        var parent                  : IndexTrieNode?
        var children                = Dictionary<String, IndexTrieNode>()
        lazy var pending            = Array<(string:String, index:T)>()
        
        init(index:T, parent:IndexTrieNode?=nil) {
            self.index = index
            self.parent = parent
        }
    }

    private var lazyLimit = -1;
    private var rootDict : Dictionary<String, IndexTrieNode>!
    
    public init(lazyLimit: Int = -1) {
        self.lazyLimit = lazyLimit
        rootDict = Dictionary<String, IndexTrieNode>()
    }
    
    public func clear() {
        rootDict.removeAll()
    }

    private func getIndicesWithParent<T : Equatable>(_ string: String,
                                                     parentNode: IndexTrieNode? = nil,
                                                     offset: Int = 1) -> Array<T>? {
        guard let endIndex = string.index(string.startIndex, offsetBy: offset, limitedBy: string.endIndex) else {
            if parentNode?.childIndices.isEmpty ?? false {
                if let item = parentNode?.index as? T {
                    return [item]
                }
            }
            return parentNode?.childIndices as? Array<T>
        }
        
        //Because the node index itself is useless (always is the first used to generate it), need to add a pair
        //to the pending list and use that
        if let parent = parentNode, !parent.pending.isEmpty {
            parent.pending.forEach( { add($0.string, index: $0.index, parentNode:parent) })
            parent.pending.removeAll()
        }

        let first = String(string[string.index(before: endIndex)..<endIndex])

        let tn : IndexTrieNode? = (parentNode != nil ? parentNode?.children[first] : rootDict[first])
        
        guard let foundNode = tn else {
            return nil
        }
        
        return getIndicesWithParent(string, parentNode:foundNode, offset:offset+1)
    }
    
    private func insertIndex(_ childIndices: inout Array<T>, index: T) {
        var desiredInsert = 0;
        for i in 0..<childIndices.count {

            guard childIndices[i] != index else {
                return
            }
            
            if index > childIndices[i] {
                desiredInsert = i + 1
            }
        }
        
        childIndices.insert(index, at: desiredInsert)
    }

    private func add(_ string: String, index: T, parentNode: IndexTrieNode? = nil, charOffset: Int = 1) {
        guard let endIndex = string.index(string.startIndex, offsetBy: charOffset, limitedBy: string.endIndex) else {
            insertIndex(&parentNode!.childIndices, index:index)
            return
        }

        let first = String(string[string.index(before: endIndex)..<endIndex])
  
        if lazyLimit == charOffset - 1 {
            
            let remain = string[string.index(before: endIndex)..<string.endIndex]
            if let parentNodeVal = parentNode {
                insertIndex(&parentNodeVal.childIndices, index:index)
            }
            parentNode?.pending.append((String(remain), index))
            return
        }

        var tn : IndexTrieNode? = (parentNode != nil ? parentNode?.children[first] : rootDict[first])
        if let node = tn {
            node.parent = parentNode
            parentNode?.children[first] = node
        } else {
            tn = IndexTrieNode(index:index, parent:parentNode)
            var tmpParent  = tn!.parent
            while let tmpParentVal = tmpParent {
                insertIndex(&tmpParentVal.childIndices, index:index)
                tmpParent = tmpParentVal.parent
            }
            tn!.parent?.children[first] = tn
        }
        
        if let parentNodeVal = parentNode {
            insertIndex(&parentNodeVal.childIndices, index:index)
        } else {
            rootDict[first] = tn
        }
        
        add(string, index:index, parentNode: tn, charOffset: charOffset+1)
    }
        
    public func getIndices(_ string: String) -> Array<T>? {
        return getIndicesWithParent(string)
    }
    
    public func addString(_ string: String, index: T) {
        add(string, index:index)
    }
}

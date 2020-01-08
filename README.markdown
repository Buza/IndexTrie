# IndexTrie

<p align="left">
    <img src="https://img.shields.io/badge/Swift-5.1-orange.svg" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
     <img src="https://img.shields.io/badge/platforms-mac+linux-brightgreen.svg?style=flat" alt="Mac + Linux" />
</p>

This is a simple Swift-based Trie implementation which supports mappings between strings and their prefixes to sets of objects (often array indexes).

## Background

Find more information on the Trie data structure [here](https://en.wikipedia.org/wiki/Trie).

As an example, consider an array of companies that have a relationship to a set of programming languages or libraries:

["Google", "Apple", "Facebook", "Netflix"]

An association between programming languages / libraries to offsets into the above array might look as follows:


| String    |      Indices      | 
|-----------|:-----------------:|
| "react"   |  [2, 3]           | 
| "redux"   |  [2, 3]           | 
| "angular" |  [0]              | 
| "piet"    |  nil              |

After building the IndexTrie, we can perform prefix searches to find the set of matching indices (e.g. searching the IndexTrie for "re" will return indices 2,3)

The trie structure ensures minimal prefix duplication.

## Installation
IndexTrie is distributed using the [Swift Package Manager](https://swift.org/package-manager). To add it to a project, add it as a dependency in your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/buza/indextrie.git", from: "0.1.0")
    ],
    ...
)
```

Then import IndexTrie wherever you’d like to use it:

```swift
import IndexTrie
```

More information on how to use the Swift Package Manager, can be found [here](https://github.com/apple/swift-package-manager/tree/master/Documentation).


## Examples

### Simple usage:

```swift
import IndexTrie

let indexTrie = IndexTrie<Int>()
indexTrie.addString("abc", index:1)
indexTrie.addString("ghi", index:2)
indexTrie.addString("gab", index:3)

var indices = indexTrie.getIndices("ab")!    // [1]
indices = indexTrie.getIndices("hi")!        // nil
indices = indexTrie.getIndices("g")!         // [2,3]
```

### Lazy evaluation:

Populating the IndexTrie can be expensive. IndexTrie supports specifying a
lazy limit, which is a maximum depth to generate nodes up until, saving the 
remaining suffix in the node that will be used to generate the remainder of the
trie if a node at this depth is visited. 

```swift
import IndexTrie

let lazyTrie = IndexTrie<Int>(lazyLimit: 2)
indexTrie.addString("abcd", index:1)

//This returns the same index result [1] as in the previous example,
//but the IndexTrie will generate the remaining subtree during the lookup.
let indices = indexTrie.getIndices("abc")!
```

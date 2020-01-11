import XCTest
@testable import IndexTrie

final class IndexTrieTests: XCTestCase {
    func test1() {
        let indexTrie = IndexTrie<Int>()
        indexTrie.addString("abc", index:1)
        indexTrie.addString("ghi", index:2)

        let indices = indexTrie.getIndices("g")
        XCTAssert(indices != nil, "Indices are nil")
        XCTAssert(!indices!.isEmpty, "Indices are empty")
    }
    
    func test2() {
        let indexTrie = IndexTrie<Int>()
        indexTrie.addString("abc", index:1)
        indexTrie.addString("ghi", index:2)

        let indices = indexTrie.getIndices("h")
        XCTAssert(indices == nil)
    }
    
    func test3() {
        let indexTrie = IndexTrie<Int>()
        indexTrie.addString("abc", index:1)
        indexTrie.addString("abd", index:2)

        let indices = indexTrie.getIndices("a")
        XCTAssert(indices != nil, "Indices are nil")
        XCTAssert(indices!.count == 2, "Indices should have 2 entries")
    }
    
    func test4() {
        let indexTrie = IndexTrie<Int>()
        indexTrie.addString("abc", index:1)
        indexTrie.addString("abd", index:2)

        let indices = indexTrie.getIndices("a")
        XCTAssert(indices != nil, "Metadata is nil")
        XCTAssert(indices!.first! == 1, "First index should be 1")
        XCTAssert(indices!.last! == 2, "Last index should be 2")
    }
    
    func test5() {
        let indexTrie = IndexTrie<Int>()
        indexTrie.addString("abcasdfasdfasdf", index:1)
        indexTrie.addString("abdx", index:2)

        let indices = indexTrie.getIndices("abdx")
        XCTAssert(indices != nil, "Metadata is nil")
        XCTAssert(indices!.count == 1, "Indices should have 1 entry")
        XCTAssert(indices!.first! == 2, "Last index should be 2")
    }
    
    func test6() {
        let indexTrie = IndexTrie<Int>(lazyLimit: 2)
        indexTrie.addString("abcasdfasdfasdf", index:5)

        let indices = indexTrie.getIndices("abcasdfasdfasd")
        XCTAssert(indices != nil, "Metadata is nil")
        XCTAssert(indices!.count == 1, "Indices should have 1 entry")
        XCTAssert(indices!.first! == 5, "Last index should be 5")
    }
    
    func test7() {
        self.measure {
            
            let indexTrie = IndexTrie<Int>()
            indexTrie.addString("abcasdfasdfasdfabcasdfasdfasdf", index:1)
            indexTrie.addString("bcasdfasdfasdfaabcasdfasdfasdf", index:2)
            indexTrie.addString("casdfasdfasdfababcasdfasdfasdf", index:3)
            indexTrie.addString("asdfasdfasdfabcabcasdfasdfasdf", index:4)
            indexTrie.addString("abcasdfasdfasdfabcasdfasdfasdf", index:5)
            indexTrie.addString("xabcasdfasdfasdfabcasdfasdfasdf", index:6)
            indexTrie.addString("arbcasdfasdfasdfabcasdfasdfasdf", index:7)
            
            indexTrie.addString("abcasdfasdfasdfabcasdfasdfasdf", index:8)
            indexTrie.addString("bcasdfasdfasdfaabcasdfasdfasdf", index:9)
            indexTrie.addString("casdfasdfasdfababcasdfasdfasdf", index:10)
            indexTrie.addString("asdfasdfasdfabcasdfasdfasdfabc", index:11)
            indexTrie.addString("abcasdfasdfasabcasdfasdfasdfdf", index:12)
            indexTrie.addString("xabcasdfasdfasabcasdfasdfasdfdf", index:13)
            indexTrie.addString("arbcasdfasdfabcasdfasdfasdfasdf", index:14)

            let _ = indexTrie.getIndices("ab")
        }
    }
    
    func test8() {
        self.measure {
            
            let indexTrie = IndexTrie<Int>(lazyLimit: 5)
            indexTrie.addString("abcasdfasdfasdfabcasdfasdfasdf", index:1)
            indexTrie.addString("bcasdfasdfasdfaabcasdfasdfasdf", index:2)
            indexTrie.addString("casdfasdfasdfababcasdfasdfasdf", index:3)
            indexTrie.addString("asdfasdfasdfabcabcasdfasdfasdf", index:4)
            indexTrie.addString("abcasdfasdfasdfabcasdfasdfasdf", index:5)
            indexTrie.addString("xabcasdfasdfasdfabcasdfasdfasdf", index:6)
            indexTrie.addString("arbcasdfasdfasdfabcasdfasdfasdf", index:7)
            
            indexTrie.addString("abcasdfasdfasdfabcasdfasdfasdf", index:8)
            indexTrie.addString("bcasdfasdfasdfaabcasdfasdfasdf", index:9)
            indexTrie.addString("casdfasdfasdfababcasdfasdfasdf", index:10)
            indexTrie.addString("asdfasdfasdfabcasdfasdfasdfabc", index:11)
            indexTrie.addString("abcasdfasdfasabcasdfasdfasdfdf", index:12)
            indexTrie.addString("xabcasdfasdfasabcasdfasdfasdfdf", index:13)
            indexTrie.addString("arbcasdfasdfabcasdfasdfasdfasdf", index:14)

            let _ = indexTrie.getIndices("ab")
        }
    }
    
    func test9() {
        let indexTrie = IndexTrie<String>()
        indexTrie.addString("abc", index:"valuz")

        let indices = indexTrie.getIndices("a")
        XCTAssert(indices != nil, "Indices are nil")
        XCTAssert(indices!.first! == "valuz", "Indices are incorrect")
    }
    
    static var allTests = [
        ("test1", test1),
        ("test2", test2),
        ("test3", test3),
        ("test4", test4),
        ("test5", test5),
        ("test6", test6),
        ("test7", test7),
        ("test8", test8),
        ("test9", test9)
    ]
}

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
        indexTrie.addString("acre kyxy", index:4)
        indexTrie.addString("acre aczt", index:6)
        indexTrie.addString("acre acbr", index:7)

        let indices = indexTrie.getIndices("acre ")
        XCTAssert(indices != nil, "Metadata is nil")
        XCTAssert(indices!.count == 3, "Indices should have 3 entries")
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
    
    func test10() {
        let indexTrie = IndexTrie<Int>(lazyLimit: 2)
        indexTrie.addString("acre kyxy", index:4)
        indexTrie.addString("acre aczt", index:6)
        indexTrie.addString("acre acbr", index:7)

        let indices = indexTrie.getIndices("acre acbr")
        XCTAssert(indices != nil, "Metadata is nil")
        XCTAssert(indices!.count == 1, "Lazy index count have 3 entries")
        XCTAssert(indices![0] == 7, "Matching lazy index incorrect")
    }
    
    func testSerialization() {
        let indexTrie = IndexTrie<Int>()
        indexTrie.addString("abc", index: 1)
        indexTrie.addString("abd", index: 2)
        indexTrie.addString("ghi", index: 3)
        
        // Serialize
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(indexTrie) else {
            XCTFail("Failed to encode IndexTrie")
            return
        }
        
        // Deserialize
        let decoder = JSONDecoder()
        guard let deserializedTrie = try? decoder.decode(IndexTrie<Int>.self, from: data) else {
            XCTFail("Failed to decode IndexTrie")
            return
        }
        
        // Test that deserialized trie works correctly
        let indices1 = deserializedTrie.getIndices("a")
        XCTAssert(indices1 != nil, "Indices for 'a' should not be nil")
        XCTAssert(indices1!.count == 2, "Should have 2 indices for 'a'")
        XCTAssert(indices1!.contains(1) && indices1!.contains(2), "Should contain indices 1 and 2")
        
        let indices2 = deserializedTrie.getIndices("g")
        XCTAssert(indices2 != nil, "Indices for 'g' should not be nil")
        XCTAssert(indices2!.count == 1, "Should have 1 index for 'g'")
        XCTAssert(indices2!.first! == 3, "Should contain index 3")
        
        let indices3 = deserializedTrie.getIndices("abc")
        XCTAssert(indices3 != nil, "Indices for 'abc' should not be nil")
        XCTAssert(indices3!.count == 1, "Should have 1 index for 'abc'")
        XCTAssert(indices3!.first! == 1, "Should contain index 1")
    }
    
    func testLazyTrieSerialization() {
        let lazyTrie = IndexTrie<Int>(lazyLimit: 2)
        lazyTrie.addString("acre kyxy", index: 4)
        lazyTrie.addString("acre aczt", index: 6)
        lazyTrie.addString("acre acbr", index: 7)
        
        // Serialize
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(lazyTrie) else {
            XCTFail("Failed to encode lazy IndexTrie")
            return
        }
        
        // Deserialize
        let decoder = JSONDecoder()
        guard let deserializedTrie = try? decoder.decode(IndexTrie<Int>.self, from: data) else {
            XCTFail("Failed to decode lazy IndexTrie")
            return
        }
        
        // Test that lazy evaluation still works after deserialization
        let indices = deserializedTrie.getIndices("acre ")
        XCTAssert(indices != nil, "Indices should not be nil")
        XCTAssert(indices!.count == 3, "Should have 3 indices")
        XCTAssert(indices!.contains(4) && indices!.contains(6) && indices!.contains(7), "Should contain all expected indices")
    }
    
    func testStringTypeSerialization() {
        let indexTrie = IndexTrie<String>()
        indexTrie.addString("test", index: "value1")
        indexTrie.addString("testing", index: "value2")
        
        // Serialize
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(indexTrie) else {
            XCTFail("Failed to encode String IndexTrie")
            return
        }
        
        // Deserialize
        let decoder = JSONDecoder()
        guard let deserializedTrie = try? decoder.decode(IndexTrie<String>.self, from: data) else {
            XCTFail("Failed to decode String IndexTrie")
            return
        }
        
        // Test functionality
        let indices = deserializedTrie.getIndices("test")
        XCTAssert(indices != nil, "Indices should not be nil")
        XCTAssert(indices!.count == 2, "Should have 2 indices")
        XCTAssert(indices!.contains("value1") && indices!.contains("value2"), "Should contain both values")
    }

}

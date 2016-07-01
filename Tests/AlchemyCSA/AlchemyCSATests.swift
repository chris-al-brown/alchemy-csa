// -----------------------------------------------------------------------------
// Copyright (c) 2016, Christopher A. Brown (chris-al-brown)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// AlchemyCSA
// AlchemyCSATests.swift
// 06/29/2016
// -----------------------------------------------------------------------------

import XCTest
@testable import AlchemyCSA

/// Returns a uniform in [0.0, 1.0)
public func uniform() -> Float {
    let input = arc4random_uniform(UINT32_MAX)
    let kExponentBits = UInt32(0x3F800000)
    let kMantissaMask = UInt32(0x007FFFFF)
    let u = (input & kMantissaMask) | kExponentBits
    return unsafeBitCast(u, to:Float.self) - 1.0
}

/// ...
class AlchemyCSATests: XCTestCase {

    /// ...
    func assayAlphabet<A: Alphabet>(alphabet: A.Type, alphabetSize: Int) {
        for letter in A.allValues {
            let character: Character
            if uniform() < 0.5 {
                character = String(letter).uppercased().characters.first!
            } else {
                character = String(letter).lowercased().characters.first!
            }
            XCTAssert(A(character) != nil, "\(character) failed to convert to \(A.self)")
        }
        XCTAssert(A.allValues.count == alphabetSize, "\(A.self) has size of \(A.allValues.count) not \(alphabetSize)")
    }
    
    /// ... 
    func assayAlignments(resource: String, sequenceCount: Int, sequenceLength: Int) {
        guard let path = Bundle(for:self.dynamicType).pathForResource(resource, ofType:nil) else {
            XCTFail("Failed to locate \"\(resource)\"")
            return
        }
        guard var stream = FastaStream<Protein>(open:path) else {
            XCTFail("Failed to stream \"\(resource)\"")
            return
        }
        var record = stream.read()
        var count: Int = 0
        while record != nil {
            let header = record!.0
            let sequence = record!.1
            XCTAssert(sequence.count == sequenceLength, "\(header) has a sequence length of \(sequence.count) not \(sequenceLength)")
            count += 1
            record = stream.read()
        }
        XCTAssert(count == sequenceCount, "\"\(resource)\" contained \(count) sequences and not \(sequenceCount)")
    }
    
    /// ...
    func testAlphabets() {
        assayAlphabet(alphabet:DNA.self, alphabetSize:4)
        assayAlphabet(alphabet:Aligned<DNA>.self, alphabetSize:5)
        assayAlphabet(alphabet:Protein.self, alphabetSize:20)
        assayAlphabet(alphabet:Aligned<Protein>.self, alphabetSize:21)
        assayAlphabet(alphabet:RNA.self, alphabetSize:4)
        assayAlphabet(alphabet:Aligned<RNA>.self, alphabetSize:5)
    }
    
    /// ...
    func testDataStreams() {
        assayAlignments(resource:"small.aln", sequenceCount:5, sequenceLength:15)
        assayAlignments(resource:"large.aln", sequenceCount:800, sequenceLength:272)
    }

    /// ...
    static var allTests : [(String, (AlchemyCSATests) -> () throws -> Void)] {
        return [
            ("testAlphabets", testAlphabets),
            ("testDataStreams", testDataStreams)
        ]
    }
}

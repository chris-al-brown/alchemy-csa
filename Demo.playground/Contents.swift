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
// Demo.playground
// 06/29/2016
// -----------------------------------------------------------------------------

import Foundation
import AlchemyCSA

/// print a fasta record
func fastaPrint<T: Alphabet where T: CustomStringConvertible>(record: (String, [T?])?) -> String {
    guard let record = record else {
        return "..."
    }
    let header = record.0
    let sequence = record.1.map {return $0?.description ?? "•"}
    return ">\(header): \(sequence)"
}

/// stream an alignment as simple protein sequences
if let path = Bundle.main().pathForResource("small.aln", ofType:nil) {
    var stream = try FastaStream<Protein>(open:path)
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    stream.reset()
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
}

/// stream an alignment as aligned protein sequences
if let path = Bundle.main().pathForResource("small.aln", ofType:nil) {
    var stream = try FastaStream<Gapped<Protein>>(open:path)
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    stream.reset()
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
    fastaPrint(record:stream.read())
}

/// stream an alignment as aligned protein sequences
if let path = Bundle.main().pathForResource("small.aln", ofType:nil) {
    var alignment = try Alignment<Protein>(open:path)
    let rowBased = alignment
    alignment.memoryLayout = .column
    let colBased = alignment
    rowBased[0, 1]
    colBased[0, 1]
    rowBased[0, 1] == colBased[0, 1]
    rowBased.memoryLayout == colBased.memoryLayout
    
    rowBased["sequence1"]
    colBased["sequence1"]
    rowBased["sequence1"]! == colBased["sequence1"]!
    
    rowBased.row(at:1)
    colBased.row(at:1)
    rowBased.row(at:1) == colBased.row(at:1)

    rowBased.column(at:1)
    colBased.column(at:1)
    rowBased.column(at:1) == colBased.column(at:1)
}




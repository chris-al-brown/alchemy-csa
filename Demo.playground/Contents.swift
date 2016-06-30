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

sizeof(Character)

/// print a fasta record
func fastaPrint<T: Alphabet>(record: (String, [T?])?) {
    guard let record = record else {
        print("...")
        return
    }
    let header = record.0
    print(">\(header)")
    let sequence = String(record.1.map { return $0?.token ?? "•"})
    print("\(sequence)")
}

/// load a simple alignment and stream fasta records
if let path = Bundle.main().pathForResource("small.aln", ofType:nil),
   var stream = FastaStream<Gapped<AminoAcid>>(openAtPath:path)
{
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

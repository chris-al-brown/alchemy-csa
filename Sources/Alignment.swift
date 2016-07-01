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
// Alignment.swift
// 07/01/2016
// -----------------------------------------------------------------------------

import Foundation

/// ...
public enum AlignmentError: ErrorProtocol {

    /// ...
    case VariableSequenceLength(expected: Int, received: Int)
}

/// ...
public struct AlignmentSettings {
    
    /// ...
    public enum MemoryLayout {
        
        /// ...
        case column
        
        /// ...
        case row
    }
    
    /// ...
    public init(layout: MemoryLayout = .row) {
        self.memoryLayout = layout
    }
    
    /// ...
    public var memoryLayout: MemoryLayout
}

/// ...
public struct Alignment<Letter: Alphabet> {

    /// ...
    public typealias Column = Sequence

    /// ...
    public typealias Header = String

    /// ...
    public typealias Position = Gapped<Letter>

    /// ...
    public typealias Row = Sequence

    /// ...
    public typealias Sequence = [Position]
    
    /// ...
    private typealias Storage = [Position]

    /// ...
    public init(open path: String, settings: AlignmentSettings = AlignmentSettings()) throws {
        var fasta = try FastaStream<Letter>(open:path)
        self.columnCount = 0
        self.headers = [:]
        self.memory = .row
        self.rowCount = 0
        self.storage = []
        var record = fasta.read()
        while let (header, sequence) = record {
            if columnCount > 0 && sequence.count != columnCount {
                throw AlignmentError.VariableSequenceLength(expected:columnCount, received:sequence.count)
            }
            columnCount = sequence.count
            headers[header] = rowCount
            for s in sequence {
                storage.append(s == .none ? .gap : .wrapped(s.unsafelyUnwrapped))
            }
            rowCount += 1
            record = fasta.read()
        }
        reorder(to:settings.memoryLayout)
    }

    /// ...
    public subscript (header: Header) -> Row? {
        if let index = headers[header] {
            return row(at:index)
        } else {
            return nil
        }
    }
    
    /// ...
    public subscript (row: Int, column: Int) -> Position {
        switch memory {
        case .column:
            return storage[column * rowCount + row]
        case .row:
            return storage[row * columnCount + column]
        }
    }
    
    /// ...
    public func column(at index: Int) -> Column {
        switch memory {
        case .column:
            return Array(storage[index * rowCount..<(index + 1) * rowCount])
        case .row:
            var output: Sequence = []
            output.reserveCapacity(rowCount)
            for i in stride(from:index, to:rowCount * columnCount, by:columnCount) {
                output.append(storage[i])
            }
            return output
        }
    }

    /// ...
    public func row(at index: Int) -> Row {
        switch memory {
        case .column:
            var output: Sequence = []
            output.reserveCapacity(columnCount)
            for i in stride(from:index, to:rowCount * columnCount, by:rowCount) {
                output.append(storage[i])
            }
            return output
        case .row:
            return Array(storage[index * columnCount..<(index + 1) * columnCount])
        }
    }
    
    /// ...
    private mutating func reorder(to value: AlignmentSettings.MemoryLayout) {
        if value == memory { return }
        if rowCount == 0 && columnCount == 0 { return }
        var tmp = Array(repeating:storage[0], count:storage.count)
        switch value {
        case .column:
            for c in 0..<columnCount {
                for r in 0..<rowCount {
                    tmp[c * rowCount + r] = storage[r * columnCount + c]
                }
            }
        case .row:
            for c in 0..<columnCount {
                for r in 0..<rowCount {
                    tmp[r * columnCount + c] = storage[c * rowCount + r]
                }
            }
        }
        storage = tmp
        memory = value
    }
    
    /// ...
    public var memoryLayout: AlignmentSettings.MemoryLayout {
        get {
            return memory
        }
        mutating set {
            reorder(to:newValue)
        }
    }

    /// ...
    public private(set) var columnCount: Int

    /// ...
    private var headers: [Header: Int]
    
    /// ...
    private var memory: AlignmentSettings.MemoryLayout
    
    /// ...
    public private(set) var rowCount: Int

    /// ...
    private var storage: Storage
}

/// ...
extension Alignment: CustomStringConvertible {
    
    /// ...
    public var description: String {
        return "Alignment<\(Letter.self)>(\(rowCount)x\(columnCount))"
    }
}















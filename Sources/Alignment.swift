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
public enum AlignmentMemoryLayout {
    
    /// ...
    case column

    /// ...
    case row
}

/// ...
public struct Alignment<Letter: Alphabet> {
    
    /// ...
    public typealias Header = String

    /// ...
    public typealias Sequence = [Gapped<Letter>]

    /// ...
    public init?(open path: String, layout: AlignmentMemoryLayout) {
        if var fasta = FastaStream<Letter>(open:path) {
            self.columnCount = 0
            self.headers = [:]
            self.memory = .row
            self.rowCount = 0
            self.storage = []
            var record = fasta.read()
            while let (header, sequence) = record {
                if columnCount > 0 && sequence.count != columnCount {
                    return nil
                }
                columnCount = sequence.count
                headers[header] = rowCount
                let contents: Sequence = sequence.map {
                    if let w = $0 {
                        return .wrapped(w)
                    } else {
                        return .gap
                    }
                }
                storage.append(contentsOf:contents)
                rowCount += 1
                record = fasta.read()
            }
            reorder(to:layout)
        } else {
            return nil
        }
    }
    
    /// ...
    public subscript (header: Header) -> Sequence? {
        if let index = headers[header] {
            return row(at:index)
        } else {
            return nil
        }
    }
    
    /// ...
    public subscript (row: Int, column: Int) -> Gapped<Letter> {
        switch memory {
        case .column:
            return storage[column * rowCount + row]
        case .row:
            return storage[row * columnCount + column]
        }
    }
    
    /// ...
    public func column(at index: Int) -> Sequence {
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
    public func row(at index: Int) -> Sequence {
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
    private mutating func reorder(to value: AlignmentMemoryLayout) {
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
    public var layout: AlignmentMemoryLayout {
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
    private var memory: AlignmentMemoryLayout
    
    /// ...
    public private(set) var rowCount: Int

    /// ...
    private var storage: Sequence
}

/// ...
extension Alignment: CustomStringConvertible {
    
    /// ...
    public var description: String {
        return "Alignment<\(Letter.self)>(\(rowCount)x\(columnCount))"
    }
}

/// ...
public enum Gapped<Wrapped: Alphabet>: Alphabet {
    
    /// ...
    case gap
    
    /// ...
    case wrapped(Wrapped)
    
    /// ...
    public static var allValues: Set<Gapped<Wrapped>> {
        return Set(Wrapped.allValues.map { return .wrapped($0) } + [.gap])
    }
    
    /// ...
    public init?(_ value: String) {
        switch value {
        case "-", ".":
            self = .gap
        default:
            if let w = Wrapped(value) {
                self = .wrapped(w)
            } else {
                return nil
            }
        }
    }
}

/// ...
extension Gapped: CustomStringConvertible {
    
    /// ...
    public var description: String {
        switch self {
        case .gap:
            return "-"
        case .wrapped(let w):
            return String(w)
        }
    }
}

/// ...
extension Gapped: Hashable {
    
    /// ...
    public var hashValue: Int {
        switch self {
        case .gap:
            return Wrapped.allValues.count
        case .wrapped(let w):
            return w.hashValue
        }
    }
}

/// ...
extension Gapped: Equatable {}
public func ==<T>(lhs: Gapped<T>, rhs: Gapped<T>) -> Bool {
    switch (lhs, rhs) {
    case (.gap, .gap):
        return true
    case (.wrapped(let l), .wrapped(let r)):
        return l == r
    default:
        return false
    }
}















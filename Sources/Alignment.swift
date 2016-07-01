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
    public typealias Header = FastaStream<Letter>.Header
    
    /// ...
    public init?(open path: String, layout: AlignmentMemoryLayout) {
        if var fasta = FastaStream<Gapped<Letter>>(open:path) {
            self.columns = 0
            self.headers = [:]
            self.memory = .row
            self.rows = 0
            self.storage = []
            var record = fasta.read()
            while let (header, sequence) = record {
                if columns > 0 && sequence.count != columns {
                    return nil
                }
                columns = sequence.count
                headers[header] = rows
                storage.append(contentsOf:sequence)
                rows += 1
                record = fasta.read()
            }
            reorderMemory(layout)
        } else {
            return nil
        }
    }
    
    /// ...
    public subscript (row: Int, column: Int) -> Gapped<Letter>? {
        switch memory {
        case .column:
            return storage[column * rows + row]
        case .row:
            return storage[row * columns + column]
        }
    }
    
    /// ...
    private mutating func reorderMemory(_ value: AlignmentMemoryLayout) {
        if value == memory { return }
        if rows == 0 && columns == 0 { return }
        var tmp = Array(repeating:storage[0], count:storage.count)
        switch value {
        case .column:
            for c in 0..<columns {
                for r in 0..<rows {
                    let index1 = c * rows + r
                    let index2 = r * columns + c
                    tmp[index1] = storage[index2]
                }
            }
        case .row:
            for c in 0..<columns {
                for r in 0..<rows {
                    let index1 = c * rows + r
                    let index2 = r * columns + c
                    tmp[index2] = storage[index1]
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
            reorderMemory(newValue)
        }
    }

    /// ...
    public private(set) var columns: Int

    /// ...
    private var headers: [Header: Int]
    
    /// ...
    private var memory: AlignmentMemoryLayout
    
    /// ...
    public private(set) var rows: Int

    /// ...
    private var storage: [Gapped<Letter>?]
}

/// ...
extension Alignment: CustomStringConvertible {
    
    /// ...
    public var description: String {
        return "Alignment<\(Letter.self)>(\(rows)x\(columns))"
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
    public init?(_ c: Character) {
        switch c {
        case "-", ".":
            self = .gap
        default:
            if let w = Wrapped(c) {
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















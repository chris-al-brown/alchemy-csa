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
// DataStream.swift
// 06/30/2016
// -----------------------------------------------------------------------------

import Foundation

/// ...
public protocol DataStream {

    /// ...
    associatedtype Datum
    
    /// ...
    mutating func read() -> Datum?
    
    /// ...
    mutating func reset()
}

/// ...
public final class FileStream: DataStream {

    /// ...
    public typealias Datum = Line

    /// ...
    public typealias Line = String

    /// ...
    public init?(openAtPath path: String, delimiter: String = "\n") {
        if let handle = FileHandle(forReadingAtPath:path) {
            self.handle = handle
            handle.seekToEndOfFile()
            self.EOF = handle.offsetInFile
            self.delimiter = delimiter.data(using:encoding)!
            self.buffer = Data(capacity:chunk)!
            handle.seek(toFileOffset:0)
        } else {
            return nil
        }
    }
    
    /// ...
    deinit {
        handle.closeFile()
    }
    
    /// ...
    public func peek() -> Character? {
        if buffer.isEmpty {
            let offset = handle.offsetInFile
            let data = handle.readData(ofLength:sizeof(UnicodeScalar))
            handle.seek(toFileOffset:offset)
            return data.isEmpty ? nil : String(data:data, encoding:encoding)?.characters.first
        } else {
            return String(data:buffer.subdata(in:0..<1), encoding:encoding)?.characters.first
        }
    }

    /// ...
    public func read() -> Line? {
        if handle.offsetInFile == EOF && buffer.isEmpty { return nil }
        var range = buffer.range(of:delimiter)
        while range == nil {
            let data = handle.readData(ofLength:chunk)
            if data.count == 0 {
                if buffer.count > 0 {
                    let string = String(data:buffer, encoding:encoding)
                    buffer.count = 0
                    return string
                }
                return nil
            }
            buffer.append(data)
            range = buffer.range(of:delimiter)
        }
        if let r = range {
            let line = String(data:buffer.subdata(in:0..<r.lowerBound), encoding:encoding)
            buffer.replaceBytes(in:0..<r.upperBound, with:Data())
            return line
        }
        return nil
    }
    
    /// ...
    public func reset() {
        buffer.replaceBytes(in:0..<buffer.count, with:Data())
        handle.seek(toFileOffset:0)
    }
    
    /// ...
    private var buffer: Data
    
    /// ...
    private let chunk: Int = 4096

    /// ...
    private let delimiter: Data

    /// ...
    private let encoding: String.Encoding = .utf8
    
    /// ...
    private let EOF: UInt64
    
    /// ...
    private let handle: FileHandle
    
    /// ...
    private var offset: UInt64 = 0
}

/// ... 
extension FileStream: CustomStringConvertible {
    
    /// ...
    public var description: String {
        return "FileStream(\(EOF) bytes)"
    }
}

/// ...
public struct FastaStream<Letter>: DataStream {

    /// ...
    public typealias Datum = Record

    /// ...
    public typealias Header = String
    
    /// ...
    public typealias Record = (Header, Sequence)
    
    /// ...
    public typealias Sequence = [Letter?]

    /// ...
    public init?(open path: String, conversion: (String) -> Letter?) {
        if let stream = FileStream(openAtPath:path) {
            self.conversion = conversion
            self.header = nil
            self.sequence = []
            self.stream = stream
        } else {
            return nil
        }
    }
    
    /// ...
    public mutating func read() -> Record? {
        readHeader()
        readSequence()
        if hasRecord {
            let record: Record = (header!, sequence)
            header = nil
            sequence.removeAll(keepingCapacity:true)
            return record
        } else {
            return nil
        }
    }
    
    /// ...
    private mutating func readHeader() {
        guard let line = stream.read() else { return }
        if let character = line.characters.first where character == ">" {
            header = String(line.characters.dropFirst())
        }
    }

    /// ...
    private mutating func readSequence() {
        if stream.peek() == ">" { return }
        guard let line = stream.read() else { return }
        for character in line.characters {
            sequence.append(conversion(String(character)))
        }
        readSequence()
    }

    /// ...
    public mutating func reset() {
        header = nil
        sequence.removeAll(keepingCapacity:true)
        stream.reset()
    }
    
    /// ...
    private var hasRecord: Bool {
        return !(header == nil || sequence.isEmpty)
    }
    
    /// ...
    private var conversion: (String) -> Letter?
    
    /// ...
    private var header: String?
    
    /// ...
    private var sequence: Sequence

    /// ...
    private let stream: FileStream
}

/// ...
extension FastaStream where Letter: Alphabet {
    
    /// ...
    public init?(open path: String) {
        self.init(open:path, conversion:Letter.init)
    }
}

/// ...
extension FastaStream: CustomStringConvertible {
    
    /// ...
    public var description: String {
        return "FastaStream<\(Letter.self)>(\(stream.EOF) bytes)"
    }
}



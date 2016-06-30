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
// Alphabet.swift
// 06/29/2016
// -----------------------------------------------------------------------------

import Foundation

/// ...
public protocol Alphabet: Hashable {

    /// ...
    static var allTokens: Set<Self> { get }

    /// ...
    init?(token: Character)
    
    /// ...
    var token: Character { get }
}

/// ...
public enum Aligned<Letter: Alphabet>: Alphabet {
    
    /// ...
    case gap
    
    /// ...
    case letter(Letter)
    
    /// ...
    public static var allTokens: Set<Aligned<Letter>> {
        return Set(Letter.allTokens.map { return .letter($0) } + [.gap])
    }
    
    /// ...
    public init?(token: Character) {
        switch token {
        case "-":
            self = .gap
        default:
            if let a = Letter(token:token) {
                self = .letter(a)
            } else {
                return nil
            }
        }
    }
    
    /// ...
    public var token: Character {
        switch self {
        case .gap:
            return "-"
        case .letter(let l):
            return l.token
        }
    }
}

/// ...
extension Aligned: Hashable {
    
    /// ...
    public var hashValue: Int {
        switch self {
        case .gap:
            return ("-" as Character).hashValue
        case .letter(let l):
            return l.token.hashValue
        }
    }
}

/// ...
extension Aligned: Equatable {}
public func ==<T>(lhs: Aligned<T>, rhs: Aligned<T>) -> Bool {
    switch (lhs, rhs) {
    case (.gap, .gap):
        return true
    case (.letter(let l), .letter(let r)):
        return l == r
    default:
        return false
    }
}

/// ...
public enum AminoAcid: Alphabet {

    /// ...
    case alanine

    /// ...
    case arginine
    
    /// ...
    case asparagine

    /// ...
    case asparticAcid
    
    /// ...
    case cysteine

    /// ...
    case glutamicAcid
    
    /// ...
    case glutamine

    /// ...
    case glycine
    
    /// ...
    case histidine

    /// ...
    case isoleucine

    /// ...
    case leucine
    
    /// ...
    case lysine

    /// ...
    case methionine
    
    /// ...
    case phenylalanine
    
    /// ...
    case proline
    
    /// ...
    case serine

    /// ...
    case threonine

    /// ...
    case tryptophan

    /// ...
    case tyrosine

    /// ...
    case valine

    /// ...
    public static let allTokens: Set<AminoAcid> = [
        .alanine, .arginine, .asparagine, .asparticAcid, .cysteine,
        .glutamicAcid, .glutamine, .glycine, .histidine, .isoleucine,
        .leucine, .lysine, .methionine, .phenylalanine, .proline,
        .serine, .threonine, .tryptophan, .tyrosine, .valine
    ]
    
    /// ...
    public init?(token: Character) {
        switch token {
        case "a", "A":
            self = .alanine
        case "r", "R":
            self = .arginine
        case "n", "N":
            self = .asparagine
        case "d", "D":
            self = .asparticAcid
        case "c", "C":
            self = .cysteine
        case "e", "E":
            self = .glutamicAcid
        case "q", "Q":
            self = .glutamine
        case "g", "G":
            self = .glycine
        case "h", "H":
            self = .histidine
        case "i", "I":
            self = .isoleucine
        case "l", "L":
            self = .leucine
        case "k", "K":
            self = .lysine
        case "m", "M":
            self = .methionine
        case "f", "F":
            self = .phenylalanine
        case "p", "P":
            self = .proline
        case "s", "S":
            self = .serine
        case "t", "T":
            self = .threonine
        case "w", "W":
            self = .tryptophan
        case "y", "Y":
            self = .tyrosine
        case "v", "V":
            self = .valine
        default:
            return nil
        }
    }
    
    /// ...
    public var token: Character {
        switch self {
        case .alanine:
            return "A"
        case arginine:
            return "R"
        case asparagine:
            return "N"
        case asparticAcid:
            return "D"
        case cysteine:
            return "C"
        case glutamicAcid:
            return "E"
        case glutamine:
            return "Q"
        case glycine:
            return "G"
        case histidine:
            return "H"
        case isoleucine:
            return "I"
        case leucine:
            return "L"
        case lysine:
            return "K"
        case methionine:
            return "M"
        case phenylalanine:
            return "F"
        case proline:
            return "P"
        case serine:
            return "S"
        case threonine:
            return "T"
        case tryptophan:
            return "W"
        case tyrosine:
            return "Y"
        case valine:
            return "V"
        }
    }
}

/// ...
public enum DNA: Alphabet {

    /// ...
    case adenine

    /// ...
    case cytosine

    /// ...
    case guanine

    /// ...
    case thymine
    
    /// ...
    public static let allTokens: Set<DNA> = [
        .adenine, .cytosine, .guanine, .thymine
    ]
    
    /// ...
    public init?(token: Character) {
        switch token {
        case "a", "A":
            self = .adenine
        case "c", "C":
            self = .cytosine
        case "g", "G":
            self = .guanine
        case "t", "T":
            self = .thymine
        default:
            return nil
        }
    }
    
    /// ... 
    public var token: Character {
        switch self {
        case .adenine:
            return "A"
        case .cytosine:
            return "C"
        case .guanine:
            return "G"
        case .thymine:
            return "T"
        }
    }
}

/// ...
public enum RNA: Alphabet {
    
    /// ...
    case adenine
    
    /// ...
    case cytosine
    
    /// ...
    case guanine
    
    /// ...
    case uracil

    /// ...
    public static let allTokens: Set<RNA> = [
        .adenine, .cytosine, .guanine, .uracil
    ]

    /// ...
    public init?(token: Character) {
        switch token {
        case "a", "A":
            self = .adenine
        case "c", "C":
            self = .cytosine
        case "g", "G":
            self = .guanine
        case "u", "U":
            self = .uracil
        default:
            return nil
        }
    }
    
    /// ...
    public var token: Character {
        switch self {
        case .adenine:
            return "A"
        case .cytosine:
            return "C"
        case .guanine:
            return "G"
        case .uracil:
            return "U"
        }
    }
}










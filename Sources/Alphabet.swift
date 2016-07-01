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
    static var allValues: Set<Self> { get }

    /// ...
    init?(_ value: String)
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
    public static let allValues: Set<DNA> = [
        .adenine, .cytosine, .guanine, .thymine
    ]
    
    /// ...
    public init?(_ value: String) {
        switch value.lowercased() {
        case "a", "adenine":
            self = .adenine
        case "c", "cytosine":
            self = .cytosine
        case "g", "guanine":
            self = .guanine
        case "t", "thymine":
            self = .thymine
        default:
            return nil
        }
    }
}

/// ...
extension DNA: CustomStringConvertible {

    /// ...
    public var description: String {
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
public enum Protein: Alphabet {
    
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
    public static let allValues: Set<Protein> = [
        .alanine, .arginine, .asparagine, .asparticAcid, .cysteine,
        .glutamicAcid, .glutamine, .glycine, .histidine, .isoleucine,
        .leucine, .lysine, .methionine, .phenylalanine, .proline,
        .serine, .threonine, .tryptophan, .tyrosine, .valine
    ]
    
    /// ...
    public init?(_ value: String) {
        switch value.lowercased() {
        case "a", "ala", "alanine":
            self = .alanine
        case "r", "arg", "arginine":
            self = .arginine
        case "n", "asn", "asparagine":
            self = .asparagine
        case "d", "asp", "aspartic acid":
            self = .asparticAcid
        case "c", "cys", "cysteine":
            self = .cysteine
        case "e", "glu", "glutamic acid":
            self = .glutamicAcid
        case "q", "gln", "glutamine":
            self = .glutamine
        case "g", "gly", "glycine":
            self = .glycine
        case "h", "his", "histidine":
            self = .histidine
        case "i", "ile", "isoleucine":
            self = .isoleucine
        case "l", "leu", "leucine":
            self = .leucine
        case "k", "lys", "lysine":
            self = .lysine
        case "m", "met", "methionine":
            self = .methionine
        case "f", "phe", "phenylalanine":
            self = .phenylalanine
        case "p", "pro", "proline":
            self = .proline
        case "s", "ser", "serine":
            self = .serine
        case "t", "thr", "threonine":
            self = .threonine
        case "w", "trp", "tryptophan":
            self = .tryptophan
        case "y", "tyr", "tyrosine":
            self = .tyrosine
        case "v", "val", "valine":
            self = .valine
        default:
            return nil
        }
    }
}

/// ...
extension Protein: CustomStringConvertible {
    
    /// ...
    public var description: String {
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
    public static let allValues: Set<RNA> = [
        .adenine, .cytosine, .guanine, .uracil
    ]

    /// ...
    public init?(_ value: String) {
        switch value.lowercased() {
        case "a", "adenine":
            self = .adenine
        case "c", "cytosine":
            self = .cytosine
        case "g", "guanine":
            self = .guanine
        case "u", "uracil":
            self = .uracil
        default:
            return nil
        }
    }
}

/// ... 
extension RNA: CustomStringConvertible {
    
    /// ...
    public var description: String {
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








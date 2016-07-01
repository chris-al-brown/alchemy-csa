<center> 
    <h1>AlchemyCSA</h1> 
</center>

<p align="center">
    <img src="https://img.shields.io/badge/platform-osx-lightgrey.svg" alt="Platform">
    <img src="https://img.shields.io/badge/language-swift-orange.svg" alt="Language">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License">
</p>

<p align="center">
    <a href="#requirements">Requirements</a>
    <a href="#installation">Installation</a>
    <a href="#usage">Usage</a>
    <a href="#references">References</a>
    <a href="#license">License</a>
</p>

AlchemyCSA is a Swift package for correlated substitution analysis

## Requirements

- Xcode
    - Version: **8.0 beta (8S128d)**
    - Language: **Swift 3.0**
- OS X
    - Latest SDK: **macOS 10.12**
    - Deployment Target: **OS X 10.10**

While AlchemyCSA has only been tested on OS X with a beta version of Xcode, 
it should presumably work on iOS, tvOS, and watchOS as well.  It only depends on the 
the Swift standard library, Foundation, Dispatch, and Accelerate. 

## Installation

Install using the [Swift Package Manager](https://swift.org/package-manager/)

Add the project as a dependency to your Package.swift:

```swift
import PackageDescription

let package = Package(
    name: "MyProjectUsingAlchemyCSA",
    dependencies: [
        .Package(url: "https://github.com/chris-al-brown/alchemy-csa", majorVersion: 0, minor: 2)
    ]
)
```

Then import `import AlchemyCSA`.

## Usage

Check out 'Demo.playground' for example usage.

## References

1. [Validation of coevolving residue algorithms via pipeline sensitivity analysis: ELSC and OMES and ZNMI, oh my!](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0010779)

## License

AlchemyCSA is released under the [MIT License](LICENSE.md).

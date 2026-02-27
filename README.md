# Osmosis - Swift Scraping

[![CI Status](https://github.com/ChristianPraiss/Osmosis/workflows/Test/badge.svg)](https://github.com/ChristianPraiss/Osmosis/actions/workflows/test.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Swift](https://img.shields.io/badge/Swift-6-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgrey.svg)](https://github.com/ChristianPraiss/Osmosis)

## Description

Osmosis makes web scraping using Swift easy. With Osmosis you can quickly parse and transform any website to use its data in your app. It is based on the **node.js** module `node-osmosis`

## Usage

```swift
Osmosis(errorHandler: { error in
    print(error)
})
// Get the FAQ page
.get(URL(string: "https://sw.kovidgoyal.net/kitty/faq/")!)
// Find each FAQ section
.find(string: OsmosisSelector(selector: "#frequently-asked-questions > section"), type: .CSS)
// Populate the section title and first paragraph of the answer
.populate(dict: [
    OsmosisPopulateKey.Single("title"): OsmosisSelector(selector: "h2"),
    OsmosisPopulateKey.Single("answer"): OsmosisSelector(selector: "p")
], type: .CSS)
// Process each FAQ entry
.list { dict in
    print(dict)
}
// Start the operations
.start()
```

Osmosis supports both **XPath** and **CSS** selectors.


## Installation

### Swift Package Manager

Add Osmosis to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ChristianPraiss/Osmosis.git", from: "1.0.1"),
]
```

Or add it in Xcode via **File → Add Package Dependencies** and enter:
```
https://github.com/ChristianPraiss/Osmosis.git
```

## Author

Christian Praiß, christian_praiss@icloud.com

## License

Osmosis is available under the MIT license. See the LICENSE file for more info.


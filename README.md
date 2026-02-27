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
// Get the website at the given url
.get(URL(string: "https://example.com")!)
// Find all elements matching the selector and execute the following actions on them
.find(OsmosisSelector(selector: "#dailyScore tr.valid"), type: .CSS)
// Populate the information you want from the dict
.populate([
    OsmosisPopulateKey.Single("points"): OsmosisSelector(selector: "td:nth-child(2)"),
    OsmosisPopulateKey.Single("aircraft"): OsmosisSelector(selector: "#tt_aircraft b"),
    OsmosisPopulateKey.Single("pilot"): OsmosisSelector(selector: ".hltitel a")
], type: .CSS)
// Get the parsed information
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


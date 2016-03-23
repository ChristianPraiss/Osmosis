# Osmosis - Swift Scrapping

[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](http://img.shields.io/travis/ChristianPraiss/Osmosis.svg?style=flat)](https://travis-ci.org/ChristianPraiss/Osmosis)
[![Version](https://img.shields.io/cocoapods/v/Osmosis.svg?style=flat)](http://cocoapods.org/pods/Osmosis)
[![License](https://img.shields.io/cocoapods/l/Osmosis.svg?style=flat)](http://cocoapods.org/pods/Osmosis)
[![Platform](https://img.shields.io/cocoapods/p/Osmosis.svg?style=flat)](http://cocoapods.org/pods/Osmosis)

## Description

Osmosis makes web scraping using Swift easy. With Osmosis you can quickly parse and transform any website to use its data in your app. It is based on the **node.js** module `node-osmosis`

## Usage

```swift
	Osmosis()
	// Get the website at the given url
                .get(url)
    // Find all elements matching the selector and execute the following actions on them
                .find(OsmosisSelector(selector: "#dailyScore tr.valid"), type: .CSS)
   	// Populate the information you want from the dict
                .populate([
                    OsmosisPopulateKey.Single("points") : OsmosisSelector(selector: "td:nth-child(2)"),
                    OsmosisPopulateKey.Single("aircraft"): OsmosisSelector(selector: "#tt_aircraft b"),
                    OsmosisPopulateKey.Single("takeOffLocation"): OsmosisSelector(selector: ".hlinfo > b:last-child"),
                    OsmosisPopulateKey.Single("pilot"): OsmosisSelector(selector: ".hltitel a")]
										, type: .CSS)
    // Get the parsed information
                .list { (var dict) -> Void in
                    // Use the parsed dict here
                    print(dict)
                    }
    // Start the operations
                .start()
```

Osmosis supports both **XPath** and **CSS** selectors.


## Installation

Osmosis is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Osmosis"
```

## Author

Christian Praiß, christian_praiss@icloud.com

## License

Osmosis is available under the MIT license. See the LICENSE file for more info.

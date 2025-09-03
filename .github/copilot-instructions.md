# Osmosis - Swift Web Scraping Library

Osmosis is a legacy Swift iOS library for web scraping, originally developed in 2015 for iOS 8.0+ using Xcode 8.0. This library provides a fluent API for web scraping using CSS selectors and XPath, built on top of the Kanna HTML/XML parser.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## ⚠️ CRITICAL - Legacy Project Notice

**This is a legacy project from 2015 that requires specific old development tools:**
- **Xcode 8.0** (specified in .travis.yml)
- **macOS** (iOS development requires Xcode)
- **CocoaPods 0.39.0** (legacy version)
- **Swift 2-3 syntax** (incompatible with modern Swift 5-6)
- **iOS 8.0+ deployment target**

**DO NOT attempt to build this project with modern Xcode/Swift** - the syntax is incompatible and will fail with numerous compiler errors.

## Working Effectively

### Environment Setup (Legacy - Xcode 8.0 Required)
- Install Xcode 8.0 (historical version, no longer available from Apple)
- Install CocoaPods 0.39.0: `sudo gem install cocoapods -v 0.39.0`
- Ensure Ruby environment is compatible with legacy CocoaPods

### Building the Project (Legacy Environment Only)
- Navigate to the Example directory: `cd Example`
- Install dependencies: `pod install` -- takes 2-3 minutes. NEVER CANCEL. Set timeout to 10+ minutes.
- Open workspace: `open Osmosis.xcworkspace`
- Build in Xcode 8.0: `xcodebuild -workspace Osmosis.xcworkspace -scheme "Osmosis Example" build` -- takes 3-5 minutes. NEVER CANCEL. Set timeout to 15+ minutes.

### Running Tests (Legacy Environment Only)
- Run tests via Xcode: `xcodebuild test -workspace Osmosis.xcworkspace -scheme "Osmosis Example" CODE_SIGNING_REQUIRED=NO` -- takes 5-10 minutes. NEVER CANCEL. Set timeout to 20+ minutes.
- Tests use Quick/Nimble framework (very old versions)
- **WARNING**: Current test suite is minimal (only contains a placeholder test)

### Modern Development Alternatives
**Since the legacy environment is difficult to set up, consider these modern approaches:**

1. **Study the code structure for educational purposes** - the API design is still relevant
2. **Port to modern Swift** - requires significant syntax updates for Swift 5-6
3. **Use modern alternatives**:
   - SwiftSoup for HTML parsing
   - Kanna 5.x for modern Swift projects
   - Alamofire + SwiftSoup combination

## Repository Structure

### Key Directories
```
/Pod/Classes/           # Main library source code
/Example/              # Example iOS application
/Example/Osmosis/      # Example app source
/Example/Tests/        # Unit tests (minimal)
/Example/Pods/         # CocoaPods dependencies
```

### Core Library Files
- `Osmosis.swift` - Main library API and fluent interface
- `GetOperation.swift` - HTTP request handling
- `FindOperation.swift` - CSS/XPath element finding
- `PopulateOperation.swift` - Data extraction operations
- `FollowOperation.swift` - Link following functionality
- `ListOperation.swift` - Result collection handling

## Dependencies and Versions (from Podfile.lock)
- **Osmosis**: 1.0.0 (local development)
- **Kanna**: 1.0.3 (HTML/XML parser - very old version)
- **AsyncSwift**: 1.6.4 (async operations)
- **Quick**: 0.8.0 (testing framework)
- **Nimble**: 3.0.0 (testing matchers)
- **CocoaPods**: 0.39.0

## Usage Example (from README)
```swift
Osmosis()
    .get(url)
    .find(OsmosisSelector(selector: "#dailyScore tr.valid"), type: .CSS)
    .populate([
        OsmosisPopulateKey.Single("points") : OsmosisSelector(selector: "td:nth-child(2)"),
        OsmosisPopulateKey.Single("aircraft"): OsmosisSelector(selector: "#tt_aircraft b"),
        OsmosisPopulateKey.Single("takeOffLocation"): OsmosisSelector(selector: ".hlinfo > b:last-child"),
        OsmosisPopulateKey.Single("pilot"): OsmosisSelector(selector: ".hltitel a")
    ], type: .CSS)
    .list { (dict) -> Void in
        print(dict)
    }
    .start()
```

## Validation

### What CAN be validated:
- Repository structure and file organization
- Code syntax and API design patterns
- Documentation completeness
- Dependency declarations

### What CANNOT be validated without legacy tools:
- **Building the project** - requires Xcode 8.0 and legacy Swift
- **Running tests** - tests are minimal and require iOS simulator
- **Manual functionality testing** - requires working iOS app

### Known Limitations
- **Legacy Podfile syntax**: Uses `:exclusive => true` which is not supported in modern CocoaPods
- **Swift syntax incompatibility**: Uses old closure syntax, optional binding patterns, and NSString APIs
- **Deprecated iOS APIs**: Uses NSURLSession patterns from iOS 8 era
- **No modern Swift Package Manager support** - project predates SPM adoption

## Development Workflow (Historical)

### Original Travis CI Configuration
- **OS**: macOS with Xcode 8.0
- **Build Command**: `xcodebuild test -workspace Osmosis-Example.xcworkspace -scheme Osmosis-Example CODE_SIGNING_REQUIRED=NO`
- **Expected Build Time**: 5-10 minutes
- **Expected Test Time**: 2-5 minutes

### For Modern Development
- **Study the codebase** for architectural patterns and API design
- **Consider porting** to modern Swift if web scraping functionality is needed
- **Use modern alternatives** like SwiftSoup + Alamofire for new projects
- **Reference the fluent API design** for inspiration in modern Swift projects

## Common Tasks

### Repository Root Structure
```
.
├── .git/
├── .gitignore
├── .travis.yml                 # Legacy CI configuration
├── Example/                    # Example iOS application
├── LICENSE                     # MIT License
├── Osmosis.podspec            # CocoaPods specification
├── Pod/                       # Library source code
├── README.md                  # Project documentation
└── _Pods.xcodeproj            # Symlink to Pods project
```

### Example Directory Structure
```
Example/
├── Osmosis/                   # Example app source
├── Osmosis.xcodeproj/         # Xcode project
├── Osmosis.xcworkspace/       # Xcode workspace
├── Podfile                    # CocoaPods dependencies
├── Podfile.lock              # Locked dependency versions
├── Pods/                     # Downloaded dependencies
└── Tests/                    # Unit tests
```

### Library API Overview
- **`.get(url)`** - Fetch HTML from URL
- **`.find(selector, type: .CSS/.XPath)`** - Find DOM elements
- **`.populate(dictionary)`** - Extract data using selectors
- **`.follow(selector)`** - Follow links to other pages
- **`.list(callback)`** - Process extracted data
- **`.start()`** - Execute the operation chain

This library demonstrates excellent fluent API design principles that remain relevant for modern Swift development, even though the implementation requires legacy tools to build and run.
//
//  FindOperation.swift
//  Pods
//
//  Created by Christian Praiß on 12/25/15.
//
//

import Foundation
import Kanna

internal class FindOperation: OsmosisOperation {
    
    var query: OsmosisSelector
    var type: HTMLSelectorType
    var next: OsmosisOperation?
    var errorHandler: OsmosisErrorCallback?
    
    init(query: OsmosisSelector, type: HTMLSelectorType, errorHandler: OsmosisErrorCallback? = nil){
        self.query = query
        self.type = type
        self.errorHandler = errorHandler
    }
    
    func execute(doc: HTMLDocument?, currentURL: URL?, node: XMLElement?, dict: [String: Any]) {
        switch type {
        case .CSS:
            if let nodes = node?.css(query.selector), nodes.count != 0 {
                    for node in nodes {
                        next?.execute(doc: doc, currentURL: currentURL, node: node, dict: dict)
                    }
            } else {
                let findError = NSError(domain: "No node found for \(self.query)", code: 500, userInfo: nil)
                self.errorHandler?(error: findError)
            }
        case .XPath:
            if let nodes = node?.xpath(query.selector), nodes.count != 0 {
                for node in nodes {
                    next?.execute(doc: doc, currentURL: currentURL, node: node, dict: dict)
                }
            } else {
                let findError = NSError(domain: "No node found for \(self.query)", code: 500, userInfo: nil)
                self.errorHandler?(error: findError)
            }
        }
    }
}
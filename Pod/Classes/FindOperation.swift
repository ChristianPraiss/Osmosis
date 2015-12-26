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
    
    func execute(doc: HTMLDocument?, node: XMLElement?, dict: [String: AnyObject]) {
        switch type {
        case .CSS:
            if let nodes = node?.css(query.selector) where nodes.count != 0 {
                    for node in nodes {
                        next?.execute(doc, node: node, dict: dict)
                    }
            } else {
                self.errorHandler?(error: NSError(domain: "No node found for \(self.query)", code: 500, userInfo: nil))
            }
        case .XPath:
            if let nodes = node?.xpath(query.selector) where nodes.count != 0 {
                for node in nodes {
                    next?.execute(doc, node: node, dict: dict)
                }
            } else {
                self.errorHandler?(error: NSError(domain: "No node found for \(self.query)", code: 500, userInfo: nil))
            }
        }
    }
}
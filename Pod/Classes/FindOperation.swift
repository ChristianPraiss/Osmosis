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
    
    var query: String
    var type: HTMLSelectorType
    var next: OsmosisOperation?
    var errorHandler: OsmosisErrorCallback
    
    init(query: String, type: HTMLSelectorType, errorHandler: OsmosisErrorCallback){
        self.query = query
        self.type = type
        self.errorHandler = errorHandler
    }
    
    func execute(doc: HTMLDocument?, node: XMLElement?, dict: [String: String]?) {
        switch type {
        case .CSS:
            if let nodes = doc?.css(query) where nodes.count != 0 {
                    for node in nodes {
                        next?.execute(doc, node: node, dict: nil)
                    }
            } else {
                errorHandler(error: NSError(domain: "No node found for \(self.query)", code: 500, userInfo: nil))
            }
        case .XPath:
            let nodes = doc.xpath(query)
            if nodes.count != 0 {
                for node in nodes {
                    callback(doc: doc, node: node, dict: nil, error: nil)
                }
            }else{
                callback(doc: doc, node: node, dict: nil, error: NSError(domain: "No node found for \(self.query)", code: 500, userInfo: nil))
            }
        }
    }
}
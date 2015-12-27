//
//  PopulateOperation.swift
//  Pods
//
//  Created by Christian Praiß on 12/26/15.
//
//

import Foundation
import Kanna

internal class PopulateOperation: OsmosisOperation {
    
    var queries: [OsmosisPopulateKey: OsmosisSelector]
    var type: HTMLSelectorType
    var next: OsmosisOperation?
    var errorHandler: OsmosisErrorCallback?
    
    init(queries: [OsmosisPopulateKey: OsmosisSelector], type: HTMLSelectorType, errorHandler: OsmosisErrorCallback? = nil){
        self.queries = queries
        self.type = type
        self.errorHandler = errorHandler
    }
    
    func execute(doc: HTMLDocument?, currentURL: NSURL?, node: XMLElement?, dict: [String: AnyObject]) {
        var newDict = dict
        for (key, query) in queries {
            var nodes: XMLNodeSet?
            switch type {
            case .CSS:
                nodes = node?.css(query.selector)
            case .XPath:
                nodes = node?.xpath(query.selector)
            }
            
            if let nodes = nodes where nodes.count != 0 {
                switch key {
                case .Single(let key):
                    if let node = nodes.first {
                        if let selector = query.attribute {
                            newDict[key] = node[selector]
                        }else{
                            newDict[key] = node.text
                        }
                    }else{
                        self.errorHandler?(error: NSError(domain: "No node found for populate \(query)", code: 500, userInfo: nil))
                    }
                case .Array(let key):
                    var contentArray = [String]()
                    for node in nodes {
                        if let selector = query.attribute {
                            contentArray.append(node[selector] ?? "")
                        }else{
                            contentArray.append(node.text ?? "")
                        }
                    }
                    newDict[key] = contentArray
                }
            }else{
                self.errorHandler?(error: NSError(domain: "No node found for populate \(query)", code: 500, userInfo: nil))
            }
        }
        
        self.next?.execute(doc, currentURL: currentURL, node: node, dict: newDict)
    }
}
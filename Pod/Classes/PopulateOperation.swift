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
    
    func execute(doc: HTMLDocument?, currentURL: URL?, node: XMLElement?, dict: [String: Any]) {
        var newDict = dict
        for (key, query) in queries {
            let result: XPathObject?
            switch type {
            case .CSS:
                result = node?.css(query.selector)
            case .XPath:
                result = node?.xpath(query.selector)
            }
            
            if let result = result, result.count != 0 {
                switch key {
                case .Single(let key):
                    if let node = result.first {
                        if let selector = query.attribute {
                            newDict[key] = node[selector]
                        }else{
                            newDict[key] = node.text
                        }
                    }else{
                        let populateError = NSError(domain: "No node found for populate \(query)", code: 500, userInfo: nil)
                        self.errorHandler?(populateError)
                    }
                case .Array(let key):
                    var contentArray = [String]()
                    for node in result {
                        if let selector = query.attribute {
                            contentArray.append(node[selector] ?? "")
                        }else{
                            contentArray.append(node.text ?? "")
                        }
                    }
                    newDict[key] = contentArray
                }
            }else{
                let populateError = NSError(domain: "No node found for populate \(query)", code: 500, userInfo: nil)
                self.errorHandler?(populateError)
            }
        }
        
        self.next?.execute(doc: doc, currentURL: currentURL, node: node, dict: newDict)
    }
}
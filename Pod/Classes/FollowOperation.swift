//
//  PopulateOperation.swift
//  Pods
//
//  Created by Christian Praiß on 12/25/15.
//
//

import Foundation
import Kanna

internal class FollowOperation: OsmosisOperation {
    
    var query: String
    var type: HTMLSelectorType
    
    init(query: String, type: HTMLSelectorType){
        self.query = query
        self.type = type
    }
    
    func execute(doc: HTMLDocument, node: XMLElement?, callback: OperationCallback) {
        switch type {
        case .CSS:
            let nodes = doc.css(query)
            if let node = nodes.first {
                if let href = node["href"], let url = NSURL(string: href) {
                    _ = GetOperation(url: url).execute(doc, node: node) { (newdoc, node, dict, error) -> Void in
                        callback(doc: newdoc, node: node, dict: dict, error: error)
                    }
                }else{
                    callback(doc: nil, node: nil, dict: nil, error: NSError(domain: "No node found for follow \(self.query)", code: 500, userInfo: nil))
                }
            }
        case .XPath:
            let nodes = doc.xpath(query)
            if let node = nodes.first {
                if let href = node["href"], let url = NSURL(string: href) {
                    _ = GetOperation(url: url).execute(doc, node: node) { (newdoc, node, dict, error) -> Void in
                        callback(doc: newdoc, node: node, dict: dict, error: error)
                    }
                }else{
                    callback(doc: nil, node: nil, dict: nil, error: NSError(domain: "No node found for follow \(self.query)", code: 500, userInfo: nil))
                }
            }
        }
    }
}
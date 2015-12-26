//
//  ListOperation.swift
//  Pods
//
//  Created by Christian Praiß on 12/26/15.
//
//

import Foundation
import Kanna

internal class ListOperation: OsmosisOperation {
    
    var next: OsmosisOperation?
    var callback: OsmosisListCallback
    
    init(callback: OsmosisListCallback){
        self.callback = callback
    }
    
    func execute(doc: HTMLDocument?, node: XMLElement?, dict: [String : AnyObject]) {
        callback(dict: dict)
        
        next?.execute(doc, node: node, dict: dict)
    }
}
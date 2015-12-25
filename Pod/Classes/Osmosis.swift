//
//  Osmosis.swift
//  Pods
//
//  Created by Christian Praiß on 12/25/15.
//
//

import Foundation
import Kanna

internal enum HTMLSelectorType {
    case CSS
    case XPath
}

typealias OperationCallback = (doc: HTMLDocument?, node: XMLElement?, dict: [String: String]?, error: NSError?)->Void
typealias OsmosisErrorCallback = (error: NSError)->Void
typealias OsmosisInfoCallback = (info: String)->Void


public class Osmosis {
    
    var errorHandler: OsmosisErrorCallback?
    var infoHandler: OsmosisInfoCallback?
    
    var operations = [OsmosisOperation]()
    
    init(errorHandler: OsmosisErrorCallback? = nil, infoHandler: OsmosisInfoCallback?){
        self.errorHandler = errorHandler
        self.infoHandler = infoHandler
    }
    
    func find(string: String, type: HTMLSelectorType = .CSS)->Osmosis {
        
        operations.append(FindOperation(query: string, type: type))
        
        return self
    }
    
    func populate(dict: [String:String], type: HTMLSelectorType = .CSS)->Osmosis {
        
        // TODO: Populate with dict of CSS Selectory
        
        return self
    }
    
    func follow(string: String)->Osmosis {
        
        // TODO: Follow link in html element
        
        return self
    }
    
    func get(url: NSURL)->Osmosis {
        
        // TODO: Implement fetching
        
        return self
    }
    
    func load(html: NSData, encoding: NSStringEncoding)->Osmosis {
        
        // TODO: Convert HTML
        
        return self
    }
}

internal protocol OsmosisOperation {
    func execute(doc: HTMLDocument?, node: XMLElement?, dict: [String: String]?)
}
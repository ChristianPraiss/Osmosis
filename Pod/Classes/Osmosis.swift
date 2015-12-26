//
//  Osmosis.swift
//  Pods
//
//  Created by Christian Praiß on 12/25/15.
//
//

import Foundation
import Kanna

public enum HTMLSelectorType {
    case CSS
    case XPath
}

typealias OperationCallback = (doc: HTMLDocument?, node: XMLElement?, dict: [String: AnyObject]?, error: NSError?)->Void
public typealias OsmosisErrorCallback = (error: NSError)->Void
public typealias OsmosisInfoCallback = (info: String)->Void
public typealias OsmosisListCallback = (dict: [String: AnyObject])->Void

public struct OsmosisSelector {
    var selector: String
    var attribute: String?
    
    public init(selector: String, attribute: String? = nil){
        self.selector = selector
        self.attribute = attribute
    }
}

public enum OsmosisPopulateKey: Hashable, Equatable {
    case Array(String)
    case Single(String)
    
    public var hashValue: Int {
        switch self {
        case Array(let arg):
            return arg.hashValue
        case .Single(let arg):
            return arg.hashValue
        }
    }
}

public func == (lhs: OsmosisPopulateKey, rhs: OsmosisPopulateKey) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public class Osmosis {
    
    var errorHandler: OsmosisErrorCallback?
    var infoHandler: OsmosisInfoCallback?
    
    var operations = [OsmosisOperation]()
    
    public init(errorHandler: OsmosisErrorCallback? = nil, infoHandler: OsmosisInfoCallback? = nil){
        self.errorHandler = errorHandler
        self.infoHandler = infoHandler
    }
    
    public func find(string: OsmosisSelector, type: HTMLSelectorType = .CSS)->Osmosis {
        
        let new = FindOperation(query: string, type: type, errorHandler: errorHandler)
        if var operation = operations.last {
            operation.next = new
        }else{
            print("First operation must be get or load")
            return self
        }
        operations.append(new)
        
        return self
    }
    
    public func populate(dict: [OsmosisPopulateKey:OsmosisSelector], type: HTMLSelectorType = .CSS)->Osmosis {
        
        let new = PopulateOperation(queries: dict, type: type, errorHandler: errorHandler)
        if var operation = operations.last {
            operation.next = new
        }else{
            print("First operation must be get or load")
            return self
        }
        operations.append(new)
        
        return self
    }
    
    public func follow(string: OsmosisSelector, type: HTMLSelectorType = .CSS)->Osmosis {
        
        let new = FollowOperation(query: string, type: type, errorHandler: errorHandler)
        if var operation = operations.last {
            operation.next = new
        }else{
            print("First operation must be get or load")
            return self
        }
        operations.append(new)
        
        return self
    }
    
    public func get(url: NSURL)->Osmosis {
        
        let new = GetOperation(url: url, errorHandler: errorHandler)
        if var operation = operations.last {
            operation.next = new
        }
        operations.append(new)
        
        return self
    }
    
    public func list(callback: OsmosisListCallback)->Osmosis{
        let new = ListOperation(callback: callback)
        if var operation = operations.last {
            operation.next = new
        }else{
            print("First operation must be get or load")
            return self
        }
        operations.append(new)
        return self
    }
    
    public func load(html: NSData, encoding: NSStringEncoding)->Osmosis {
        
        // TODO: Convert HTML
        
        return self
    }
    
    public func start(){
        operations.first?.execute(nil, node: nil, dict: [String: AnyObject]())
    }
}

internal protocol OsmosisOperation {
    var next: OsmosisOperation? { get set }
    func execute(doc: HTMLDocument?, node: XMLElement?, dict: [String: AnyObject])
}
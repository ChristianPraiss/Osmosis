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

typealias OperationCallback = (_ doc: HTMLDocument?, _ node: XMLElement?, _ dict: [String: Any]?, _ error: Error?)->Void
public typealias OsmosisErrorCallback = (_ error: Error)->Void
public typealias OsmosisInfoCallback = (_ info: String)->Void
public typealias OsmosisListCallback = (_ dict: [String: Any])->Void

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
}

internal class FinishOperation: OsmosisOperation {
    var next: OsmosisOperation?
    
    func execute(doc: HTMLDocument?, currentURL: URL?, node: XMLElement?, dict: [String : Any]) {
        print("done")
    }
}

public func == (lhs: OsmosisPopulateKey, rhs: OsmosisPopulateKey) -> Bool {
    switch (lhs, rhs) {
    case (.Array(let lhsArg), .Array(let rhsArg)):
        return lhsArg == rhsArg
    case (.Single(let lhsArg), .Single(let rhsArg)):
        return lhsArg == rhsArg
    default:
        return false
    }
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
    
    public func get(url: URL)->Osmosis {
        
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
    
    public func load(html: Data, encoding: String.Encoding)->Osmosis {
        
        let new = LoadOperation(data: html, encoding: encoding, errorHandler: errorHandler)
        if var operation = operations.last {
            operation.next = new
        }
        operations.append(new)
        
        return self
    }
    
    public func start(){
        operations.first?.execute(doc: nil, currentURL: nil, node: nil, dict: [String: Any]())
    }
}

internal protocol OsmosisOperation {
    var next: OsmosisOperation? { get set }
    func execute(doc: HTMLDocument?, currentURL: URL?, node: XMLElement?, dict: [String: Any])
}
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
            let nodes = node?.css(query.selector)
            if let node = nodes?.first {
                if let href = node["href"], let url = currentURL, let newURL = URL(string: href, relativeTo: url) {
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    let task = session.dataTask(with: newURL.absoluteURL) { (data, response, error) -> Void in
                        if let error = error {
                            self.errorHandler?(error: error)
                            return
                        }
                        
                        guard let data = data, 
                              let string = String(data: data, encoding: .utf8), 
                              let newdoc = HTML(html: string, encoding: .utf8) else {
                            let parseError = NSError(domain: "HTML parse error", code: 500, userInfo: nil)
                            self.errorHandler?(error: parseError)
                            return
                        }
                        
                        self.next?.execute(doc: newdoc, currentURL: newURL, node: newdoc.body, dict: dict)
                    }
                    
                    task.resume()
                }else{
                    let followError = NSError(domain: "No node found for follow \(self.query)", code: 500, userInfo: nil)
                    self.errorHandler?(error: followError)
                }
            }
        case .XPath:
            let nodes = node?.xpath(query.selector)
            if let node = nodes?.first {
                if let href = node["href"], let url = currentURL, let newURL = url.deletingLastPathComponent().appendingPathComponent(href) {
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    let task = session.dataTask(with: newURL) { (data, response, error) -> Void in
                        if let error = error {
                            self.errorHandler?(error: error)
                            return
                        }
                        
                        guard let data = data, 
                              let string = String(data: data, encoding: .utf8), 
                              let newdoc = HTML(html: string, encoding: .utf8) else {
                            let parseError = NSError(domain: "HTML parse error", code: 500, userInfo: nil)
                            self.errorHandler?(error: parseError)
                            return
                        }
                        
                        self.next?.execute(doc: newdoc, currentURL: newURL, node: newdoc.body, dict: dict)
                    }
                    
                    task.resume()
                }else{
                    let followError = NSError(domain: "No node found for follow \(self.query)", code: 500, userInfo: nil)
                    self.errorHandler?(error: followError)
                }
            }
        }
    }
}
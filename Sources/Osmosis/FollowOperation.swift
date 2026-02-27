//
//  FollowOperation.swift
//  Osmosis
//
//  Created by Christian Praiß on 12/25/15.
//
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
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
    
    func execute(doc: Kanna.HTMLDocument?, currentURL: URL?, node: Kanna.XMLElement?, dict: [String: Any]) {
        switch type {
        case .CSS:
            let nodes = node?.css(query.selector)
            if let node = nodes?.first {
                if let href = node["href"], let url = currentURL, let newURL = URL(string: href, relativeTo: url) {
                    let task = URLSession.shared.dataTask(with: newURL.absoluteURL) { (data, response, error) -> Void in
                        if let error = error {
                            self.errorHandler?(error)
                            return
                        }
                        
                        guard let data = data,
                              let string = String(data: data, encoding: .utf8),
                              let newdoc = try? HTML(html: string, encoding: .utf8) else {
                            let parseError = NSError(domain: "HTML parse error", code: 500, userInfo: nil)
                            self.errorHandler?(parseError)
                            return
                        }
                        
                        self.next?.execute(doc: newdoc, currentURL: newURL, node: newdoc.body, dict: dict)
                    }
                    
                    task.resume()
                }else{
                    let followError = NSError(domain: "No node found for follow \(self.query)", code: 500, userInfo: nil)
                    self.errorHandler?(followError)
                }
            }
        case .XPath:
            let nodes = node?.xpath(query.selector)
            if let node = nodes?.first {
                if let href = node["href"], let url = currentURL {
                    let newURL = url.deletingLastPathComponent().appendingPathComponent(href)
                    let task = URLSession.shared.dataTask(with: newURL) { (data, response, error) -> Void in
                        if let error = error {
                            self.errorHandler?(error)
                            return
                        }
                        
                        guard let data = data,
                              let string = String(data: data, encoding: .utf8),
                              let newdoc = try? HTML(html: string, encoding: .utf8) else {
                            let parseError = NSError(domain: "HTML parse error", code: 500, userInfo: nil)
                            self.errorHandler?(parseError)
                            return
                        }
                        
                        self.next?.execute(doc: newdoc, currentURL: newURL, node: newdoc.body, dict: dict)
                    }
                    
                    task.resume()
                }else{
                    let followError = NSError(domain: "No node found for follow \(self.query)", code: 500, userInfo: nil)
                    self.errorHandler?(followError)
                }
            }
        }
    }
}
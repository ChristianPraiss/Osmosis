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
    
    func execute(doc: HTMLDocument?, currentURL: NSURL?, node: XMLElement?, dict: [String: AnyObject]) {
        switch type {
        case .CSS:
            let nodes = node?.css(query.selector)
            if let node = nodes?.first {
                if let href = node["href"], let url = currentURL?.absoluteURL, let newURL = NSURL(string: href, relativeToURL: url) {
                    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                    let task = session.dataTaskWithURL(newURL.absoluteURL) { (data, response, error) -> Void in
                        guard let error = error else {
                            if let data = data, let string = String(data: data, encoding: NSUTF8StringEncoding), let newdoc = HTML(html: string, encoding: NSUTF8StringEncoding) {
                                self.next?.execute(newdoc, currentURL: newURL, node: newdoc.body, dict: dict)
                            }else{
                                self.errorHandler?(error: NSError(domain: "HTML parse error", code: 500, userInfo: nil))
                            }
                            return
                        }
                        self.errorHandler?(error: error)
                    }
                    
                    task.resume()
                }else{
                    self.errorHandler?(error: NSError(domain: "No node found for follow \(self.query)", code: 500, userInfo: nil))
                }
            }
        case .XPath:
            let nodes = node?.xpath(query.selector)
            if let node = nodes?.first {
                if let href = node["href"], let url = currentURL, let newURL = url.URLByDeletingLastPathComponent?.URLByAppendingPathComponent(href) {
                    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                    let task = session.dataTaskWithURL(newURL) { (data, response, error) -> Void in
                        guard let error = error else {
                            if let data = data, let string = String(data: data, encoding: NSUTF8StringEncoding), let newdoc = HTML(html: string, encoding: NSUTF8StringEncoding) {
                                self.next?.execute(newdoc, currentURL: newURL, node: newdoc.body, dict: dict)
                            }else{
                                self.errorHandler?(error: NSError(domain: "HTML parse error", code: 500, userInfo: nil))
                            }
                            return
                        }
                        self.errorHandler?(error: error)
                    }
                    
                    task.resume()
                }else{
                    self.errorHandler?(error: NSError(domain: "No node found for follow \(self.query)", code: 500, userInfo: nil))
                }
            }
        }
    }
}
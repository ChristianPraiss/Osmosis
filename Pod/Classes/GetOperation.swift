//
//  GetOperation.swift
//  Pods
//
//  Created by Christian Praiß on 12/25/15.
//
//

import Foundation
import Kanna

internal class GetOperation: OsmosisOperation {
    
    let url: NSURL
    var next: OsmosisOperation?
    var errorHandler: OsmosisErrorCallback?
    
    init(url: NSURL, errorHandler: OsmosisErrorCallback? = nil){
        self.url = url
        self.errorHandler = errorHandler
    }
    
    func execute(doc: HTMLDocument?, currentURL: NSURL?, node: XMLElement?, dict: [String: AnyObject]) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            guard let error = error else {
                if let data = data, let string = String(data: data, encoding: NSUTF8StringEncoding), let newdoc = HTML(html: string, encoding: NSUTF8StringEncoding) {
                    self.next?.execute(newdoc, currentURL: self.url, node: newdoc.body, dict: dict)
                }else{
                    self.errorHandler?(error: NSError(domain: "HTML parse error", code: 500, userInfo: nil))
                }
                return
            }
            self.errorHandler?(error: error)
        }
        
        task.resume()
    }
}

internal class LoadOperation: OsmosisOperation {
    
    let data: NSData
    var next: OsmosisOperation?
    var errorHandler: OsmosisErrorCallback?
    let encoding: NSStringEncoding
    
    init(data: NSData, encoding: NSStringEncoding, errorHandler: OsmosisErrorCallback? = nil){
        self.data = data
        self.encoding = encoding
        self.errorHandler = errorHandler
    }
    
    func execute(doc: HTMLDocument?, currentURL: NSURL?, node: XMLElement?, dict: [String: AnyObject]) {
        if let html = HTML(html: data, encoding: NSUTF8StringEncoding) {
            self.next?.execute(html, currentURL: nil, node: html.body, dict: dict)
        }else{
            self.errorHandler?(error: NSError(domain: "HTML parse error", code: 500, userInfo: nil))
        }
    }
}
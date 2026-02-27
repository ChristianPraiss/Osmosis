//
//  GetOperation.swift
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

internal class GetOperation: OsmosisOperation {
    
    let url: URL
    var next: OsmosisOperation?
    var errorHandler: OsmosisErrorCallback?
    
    init(url: URL, errorHandler: OsmosisErrorCallback? = nil){
        self.url = url
        self.errorHandler = errorHandler
    }
    
    func execute(doc: Kanna.HTMLDocument?, currentURL: URL?, node: Kanna.XMLElement?, dict: [String: Any]) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
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
            
            self.next?.execute(doc: newdoc, currentURL: self.url, node: newdoc.body, dict: dict)
        }
        
        task.resume()
    }
}

internal class LoadOperation: OsmosisOperation {
    
    let data: Data
    var next: OsmosisOperation?
    var errorHandler: OsmosisErrorCallback?
    let encoding: String.Encoding
    
    init(data: Data, encoding: String.Encoding, errorHandler: OsmosisErrorCallback? = nil){
        self.data = data
        self.encoding = encoding
        self.errorHandler = errorHandler
    }
    
    func execute(doc: Kanna.HTMLDocument?, currentURL: URL?, node: Kanna.XMLElement?, dict: [String: Any]) {
        if let html = try? HTML(html: data, encoding: .utf8) {
            self.next?.execute(doc: html, currentURL: nil, node: html.body, dict: dict)
        }else{
            let parseError = NSError(domain: "HTML parse error", code: 500, userInfo: nil)
            self.errorHandler?(parseError)
        }
    }
}
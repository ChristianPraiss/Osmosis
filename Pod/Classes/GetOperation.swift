//
//  GetOperation.swift
//  Pods
//
//  Created by Christian Praiß on 12/25/15.
//
//

import Foundation
import Kanna

class GetOperation: OsmosisOperation {
    
    let url: NSURL
    
    init(url: NSURL){
        self.url = url
    }
    
    func execute(doc: HTMLDocument, node: XMLElement?, callback: OperationCallback) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            guard let error = error else {
                if let data = data, let string = String(data: data, encoding: NSUTF8StringEncoding), let doc = HTML(html: string, encoding: NSUTF8StringEncoding) {
                    callback(doc: doc, node: doc.body, dict: nil, error: nil)
                }else{
                    callback(doc: nil, node: nil, dict: nil, error: NSError(domain: "HTML parse error", code: 500, userInfo: nil))
                }
                return
            }
            callback(doc: nil, node: nil, dict: nil, error: error)
        }
        
        task.resume()
    }
}
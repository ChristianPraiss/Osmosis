//
//  ContentTableViewController.swift
//  Osmosis
//
//  Created by Christian Praiß on 12/25/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import Osmosis

class ContentTableViewController: UITableViewController {
    
    var array: [[String: Any]] = [[String: Any]]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Osmosis(errorHandler: { error in
            print(error)
        })
            .get(URL(string: "https://sw.kovidgoyal.net/kitty/faq/")!)
            .find(string: OsmosisSelector(selector: "#frequently-asked-questions > section"), type: .CSS)
            .populate(dict: [
                OsmosisPopulateKey.Single("title") : OsmosisSelector(selector: "h2"),
                OsmosisPopulateKey.Single("answer") : OsmosisSelector(selector: "p")
            ], type: .CSS)
            .list { dict in
                self.array.append(dict)
            }
            .start()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
        let content = array[indexPath.row]
        var text = ""
        for (key, value) in content {
            text += "\(key): \(value)\n"
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

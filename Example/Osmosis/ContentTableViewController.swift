//
//  ContentTableViewController.swift
//  Osmosis
//
//  Created by Christian Praiß on 12/25/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import Osmosis
import Async

class ContentTableViewController: UITableViewController {
    
    var array: [[String: AnyObject]] = [[String: AnyObject]]() {
        didSet {
            Async.main {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Async.background {
            Osmosis(errorHandler: { (error) -> Void in
                print(error)
            })
                .get(NSURL(string: "http://www.onlinecontest.org/olc-2.0/gliding/daily.html?st=olc&rt=olc&df=2015-12-22&sp=2016&c=C0&sc=#p:0;")!)
                .find(OsmosisSelector(selector: "#dailyScore tr.valid"), type: .CSS)
                .populate([
                    OsmosisPopulateKey.Single("points") : OsmosisSelector(selector: "td:nth-child(2)"),
                    OsmosisPopulateKey.Single("name") : OsmosisSelector(selector: "td:nth-child(3) a")
                    ], type: .CSS)
                .follow(OsmosisSelector(selector: "td:nth-child(13) a"))
                .populate([
                    OsmosisPopulateKey.Single("aircraft"): OsmosisSelector(selector: "#tt_aircraft b")
                    ], type: .CSS)
                .list { (dict) -> Void in
                    self.array.append(dict)
                }
                .start()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath)
        let content = array[indexPath.row]
        var text = ""
        for (key, value) in content {
            text += "\(key): \(value)\n"
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

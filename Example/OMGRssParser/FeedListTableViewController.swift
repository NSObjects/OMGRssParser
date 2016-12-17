//
//  FeedListTableViewController.swift
//  OMGRssParser
//
//  Created by 林涛 on 2016/12/17.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import OMGRssParser

class FeedListTableViewController: UITableViewController {

    var feeds:[OMGFeedItem]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let item = feeds![indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.pubDate
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowContent", sender: feeds![indexPath.row])
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "ShowContent" {
            guard let feedContentViewController = segue.destination as? FeedContentViewController,
            let item = sender as? OMGFeedItem else {
                return
            }
            feedContentViewController.title = item.title
            feedContentViewController.content = item.content
        }
    }
 

}

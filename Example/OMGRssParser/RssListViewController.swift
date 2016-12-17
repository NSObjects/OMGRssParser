//
//  RssListViewController.swift
//  OMGRssParser
//
//  Created by 林涛 on 2016/12/17.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import OMGRssParser

class RssListViewController: UITableViewController {

    var feeds = [OMGFeedInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let rss = ["http://ericasadun.com/feed/",
                     "https://littlebitesofcocoa.com/rss",
                     "http://www.swiftandpainless.com/feed.xml",
                     "http://developer.apple.com/swift/blog/news.rss",
                     "http://masilotti.com/atom.xml",
                     "http://appventure.me/rss-feed"]
        
        for url in rss {
            let rssParser = OMGRssParser(urlStr: url)
            rssParser.parse(completionHandler: { (info, error) in
                guard let info = info else {return}
                print(info.link ?? "")
                self.feeds.append(info)
                self.tableView.reloadData()
            })
        }
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let feedInfo = feeds[indexPath.row]
        cell.textLabel?.text =  feedInfo.title
        cell.detailTextLabel?.text = feedInfo.pubDate
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowFeedList", sender: feeds[indexPath.row].feedItems)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFeedList" {
            guard let feedListViewController = segue.destination as? FeedListTableViewController,
            let item = sender as? [OMGFeedItem] else {
                return
            }
            
            feedListViewController.feeds = item
        }
    }


}

//
//  OMGFeedInfo.swift
//  Pods
//
//  Created by 林涛 on 2016/12/17.
//
//

import Foundation
import  Ji

//http://www.w3school.com.cn/rss/rss_reference.asp
public struct OMGFeedInfo {
   
    /// 为 feed 定义所属的一个或多个种类。
    public var category : String?
    /// 注册进程，以获得 feed 更新的立即通知。
    public var cloud : String?
    /// 可选。告知版权资料。
    public var copyright : String?
    /// 描述频道。
    public var feedDescription : String?
    /// 规定指向当前 RSS 文件所用格式说明的 URL
    public var docs : String?
    /// 在聚合器呈现某个 feed 时，显示一个图像
    public var image : String?
    /// 规定编写 feed 所用的语言
    public var language : String?
    /// 定义 feed 内容的最后修改日期
    public var lastBuildDate : String?
    /// 定义指向频道的超链接
    public var link : String?
    /// 定义 feed 内容编辑的电子邮件地址
    public var managingEditor : String?
    /// 为 feed 的内容定义最后发布日期
    public var pubDate : String?
    /// feed 的 PICS 级别
    public var rating : String?
    /// 规定忽略 feed 更新的天
    public var skipDays : String?
    /// 规定忽略 feed 更新的小时
    public var skipHours : String?
    /// 定义频道的标题
   public var title : String?
    /// subtitle atom
    public var subtitle : String?
    /// 指定从 feed 源更新此 feed 之前，feed 可被缓存的分钟数。
    public var ttl : String?
    /// 定义此 feed 的 web 管理员的电子邮件地址
    public var webMaster : String?
    /// 作者 Atom中才有
    public var author : String?
    /// ###updated atom 专用
    public var updated :String?
    
    public var feedItems:[OMGFeedItem]?
}

extension OMGFeedInfo {
    func description() -> String {
        return "\(self.toDictionary())"
    }
    
    func toDictionary()-> NSDictionary {
        let dictionary = NSMutableDictionary()
        
        dictionary["category"] = category
        
        dictionary["cloud"] = cloud
        
        dictionary["copyright"] = copyright
        
        dictionary["feedDescription"] = feedDescription
        
        dictionary["docs"] = docs
        
        dictionary["image"] = image
        
        dictionary["language"] = language
        
        dictionary["lastBuildDate"] = lastBuildDate
        
        dictionary["link"] = link
        
        dictionary["managingEditor"] = managingEditor
        
        dictionary["rating"] = rating
        
        dictionary["skipDays"] = skipDays
        
        dictionary["skipHours"] = skipHours
        
        dictionary["title"] = title
        
        dictionary["subtitle"] = link
        
        dictionary["ttl"] = ttl
        
        dictionary["webMaster"] = webMaster
        
        dictionary["author"] = author
        
        dictionary["updated"] = updated
        
        return dictionary
    }
}

extension OMGFeedInfo{
    
    init(xmlDoc:Ji) {
        
        guard  let feedType = xmlDoc.rootNode?.tagName?.lowercased() else {
            return
        }
        switch feedType {
        case "rss":
            convertRSSType(xmlDoc: xmlDoc)
        case "rdf:RDF":
            convertRSS1Type(xmlDoc: xmlDoc)
        case "feed":
            convertAtomType(xmlDoc: xmlDoc)
            
        default: break
            
        }
    }
    
    mutating func convertRSSType(xmlDoc : Ji) {
        guard let channel = xmlDoc.rootNode?.firstChildWithName("channel") else {
            return
        }
        
        title = channel.firstChildWithName("title")?.content
        feedDescription = channel.firstChildWithName("description")?.content
        link = channel.firstChildWithName("link")?.content
        language = channel.firstChildWithName("language")?.content
        lastBuildDate = channel.firstChildWithName("lastBuildDate")?.content
        pubDate = channel.firstChildWithName("pubDate")?.content
        copyright = channel.firstChildWithName("copyright")?.content
        webMaster = channel.firstChildWithName("webMaster")?.content
        managingEditor = channel.firstChildWithName("managingEditor")?.content
        
        let children = channel.childrenWithName("item")
        var feedItems = [OMGFeedItem]();
        for node:JiNode in children {
            feedItems.append(OMGFeedItem(node: node, type: FeedType.rss))
        }
        self.feedItems = feedItems;
        print("parse success")
    }
    
    mutating func convertRSS1Type(xmlDoc : Ji) {
        guard let channel = xmlDoc.rootNode?.firstChildWithName("rdf:RDF") else {
            return
        }
        
        let children = channel.childrenWithName("item")
        title = channel.firstChildWithName("title")?.content
        feedDescription = channel.firstChildWithName("description")?.content
        link = channel.firstChildWithName("link")?.content
        language = channel.firstChildWithName("language")?.content
        lastBuildDate = channel.firstChildWithName("lastBuildDate")?.content
        pubDate = channel.firstChildWithName("pubDate")?.content
        copyright = channel.firstChildWithName("copyright")?.content
        webMaster = channel.firstChildWithName("webMaster")?.content
        managingEditor = channel.firstChildWithName("managingEditor")?.content
        
        var feedItems = [OMGFeedItem]();
        for node:JiNode in children {
            
            feedItems.append(OMGFeedItem(node: node, type: FeedType.rss1))
        }
        self.feedItems = feedItems;
        print("parse success")
        
    }
    
    mutating func convertAtomType(xmlDoc : Ji) {
        guard let children = xmlDoc.rootNode?.childrenWithName("entry") else {
            return
        }
        updated = xmlDoc.rootNode?.firstChildWithName("updated")?.content
        title = xmlDoc.rootNode?.firstChildWithName("title")?.content
        subtitle = xmlDoc.rootNode?.firstChildWithName("subtitle")?.content
        feedDescription = xmlDoc.rootNode?.firstChildWithName("description")?.content
        link = xmlDoc.rootNode?.firstChildWithName("link")?.content
        managingEditor = xmlDoc.rootNode?.firstChildWithName("author")?.firstChildWithName("email")?.content
        author = xmlDoc.rootNode?.firstChildWithName("author")?.firstChildWithName("name")?.content
        
        var feedItems = [OMGFeedItem]();
        for node:JiNode in children {
            feedItems.append(OMGFeedItem(node: node, type: FeedType.atom))
            
        }
        self.feedItems = feedItems;
        print("parse success")
        
    }
}


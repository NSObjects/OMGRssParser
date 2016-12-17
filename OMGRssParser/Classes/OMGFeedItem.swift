//
//  OMGFeedItem.swift
//  Pods
//
//  Created by 林涛 on 2016/12/17.
//
//

import Foundation
import Ji

//http://www.w3school.com.cn/rss/rss_reference.asp
public struct OMGFeedItem {
    /// 规定项目作者的电子邮件地址。
    public var author : String?
    /// 定义项目所属的一个或多个类别
    public var category : String?
    /// 允许项目连接到有关此项目的注释（文件）
    public var comments : String?
    /// 允许将一个媒体文件导入一个项中
    //TODO: 这里是个字典，应该是资源文件的URL
    public var enclosure : String?
    /// 为项目定义一个唯一的标识符
    public var guid : String?
    /// 定义指向此项目的超链接。
    public var link : String?
    /// 定义此项目的最后发布日期
    public var pubDate : String?
    /// 为此项目指定一个第三方来源
    public var Source : String?
    /// 定义此项目的标题
    public var title : String?
    /// atom 内容
    public var content : String?
    /// atom 摘要
    public var summary : String?
    /// atom  更新时间
    public var updated : String?
}

extension OMGFeedItem {
    func description() -> String {
        return "\(self.toDictionary())"
    }
    
    func toDictionary()-> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary["author"] = author
        
        dictionary["category"] = category
        
        dictionary["comments"] = comments
        
        dictionary["enclosure"] = enclosure
        
        dictionary["link"] = link
        
        dictionary["pubDate"] = pubDate
        
        dictionary["Source"] = Source
        
        dictionary["title"] = title
        
        dictionary["content"] = content
        
        dictionary["summary"] = summary
        
        dictionary["updated"] = updated
        return dictionary
    }
    
    init(node:JiNode,type:FeedType) {
        if type == .atom {
            title = node.firstChildWithName("title")?.content
            summary = node.firstChildWithName("summary")?.content
            author = node.firstChildWithName("contributor")?.firstChildWithName("name")?.content
            pubDate = node.firstChildWithName("published")?.content
            updated = node.firstChildWithName("updated")?.content
            link = node.firstChildWithName("link")?.content
            guid = node.firstChildWithName("id")?.content
            category = node.firstChildWithName("category")?.content
            content = node.firstChildWithName("content")?.content
        } else {
            title = node.firstChildWithName("title")?.content
            content = node.firstChildWithName("description")?.content
            author = node.firstChildWithName("author")?.content
            pubDate = node.firstChildWithName("pubDate")?.content
            link = node.firstChildWithName("link")?.content
            guid = node.firstChildWithName("guid")?.content
            category = node.firstChildWithName("category")?.content
        }
    }
    
}



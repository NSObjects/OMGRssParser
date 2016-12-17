//
//  OMGRssParser.swift
//  Pods
//
//  Created by 林涛 on 2016/12/17.
//
//

import UIKit
import Ji

public enum ParsingErrorCode:Int{
    case notInitiated = 2040
    case connectionFailed = 2041
    case parsingError = 2042
    case feedValidationError = 2043
    case feedParsing = 2044
}

public enum FeedType {
    case unknown
    case rss
    case rss1
    case atom
}

public class OMGRssParser: NSObject {
    
    public var parsing = false
    public typealias RSSParsingcompleted = (OMGFeedInfo?, NSError?) -> Void
    
    private let url:URL
    private let parseTimeOut = 60.0
    private let request:URLRequest
    private let parsingQueue = DispatchQueue(label: "com.RSSParsing")
    private var feedType = FeedType.unknown
    
   public init(_ url:URL) {
        self.url = url
        request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: parseTimeOut)
    }
    
   public convenience init(urlStr str:String) {
        print("Rss Web site is : \(str)")
        let url:URL = URL(string: str)!
        self.init(url)
    }
    
   public func parse(completionHandler:@escaping RSSParsingcompleted) {
        guard parsing == false else {
            let userInfo = [NSLocalizedDescriptionKey:"Parsing error"]
            let error = NSError(domain: "PlatinumBlue Parsing", code: ParsingErrorCode.feedParsing.rawValue, userInfo: userInfo)
            completionHandler(nil, error)
            return
        }
        parsing = true
        sendRequest(completionHandler: completionHandler)
    }
    
   private func sendRequest(completionHandler:@escaping RSSParsingcompleted)  {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            OperationQueue.main.addOperation({
                if error != nil && response == nil {
                    if #available(iOS 9.0, *) {
                        if (error as? NSError)?.code == NSURLErrorAppTransportSecurityRequiresSecureConnection {
                            assert(false, "NSURLErrorAppTransportSecurityRequiresSecureConnection")
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            })
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode  == 200 else {
                    let error = NSError(domain: "ConnectionFailed", code: ParsingErrorCode.connectionFailed.rawValue, userInfo: [NSLocalizedDescriptionKey:"Connection Failed ,HTTP state code :\(httpResponse.statusCode)"])
                    OperationQueue.main.addOperation({
                        completionHandler(nil, error)
                    })
                    return
                }
                
                if httpResponse.mimeType == "application/atom+xml" || httpResponse.mimeType == "application/rss+xml"  {
                    if let d = data {
                        self.parsingQueue.async {
                            self.startParsing(data: d, textEncodingName: httpResponse.textEncodingName,completionHandler: completionHandler)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
   private func startParsing(data : Data ,textEncodingName : String?,completionHandler: @escaping RSSParsingcompleted) {
        guard  let xmlDoc = Ji(xmlData: data) else {
            let userInfo = [NSLocalizedDescriptionKey:"Can't Parse this feed \(url)"]
            let error = NSError(domain: "PlatinumBlue Parsing", code: ParsingErrorCode.parsingError.rawValue, userInfo: userInfo)
            OperationQueue.main.addOperation({
                completionHandler(nil,error)
            })
            return
        }
        
        guard let feedType = xmlDoc.rootNode?.tagName?.lowercased() else {
            let userInfo = [NSLocalizedDescriptionKey:"Can't Parse this feed \(url)"]
            let error = NSError(domain: "PlatinumBlue Parsing", code: ParsingErrorCode.feedValidationError.rawValue, userInfo: userInfo)
            OperationQueue.main.addOperation({
                completionHandler(nil,error)
            })
            return
        }
        
        if feedType == "rss" || feedType == "rdf:RDF" || feedType == "feed" {
            let feedInfo = OMGFeedInfo(xmlDoc: xmlDoc)
            OperationQueue.main.addOperation({
               completionHandler(feedInfo, nil)
            })
            
        } else {
            print("\(xmlDoc.rootNode?.tagName)")
            let userInfo = [NSLocalizedDescriptionKey:"XML document is not a valid web feed document \n\(url)"]
            let error = NSError(domain: "PlatinumBlue Parsing", code: ParsingErrorCode.feedValidationError.rawValue, userInfo: userInfo)
            completionHandler(nil,error)
        }
    }
}

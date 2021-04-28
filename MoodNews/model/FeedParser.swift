//
//  FeedParser.swift
//  MoodNews
//
//  Created by Steven Lin on 2020/6/2.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation

typealias ArticleItem = (title: String, description: String, pubDate: String, link: String)

enum RssTag: String {
    case item = "item"
    case title = "title"
    case description = "description"
    case pubDate = "pubDate"
    case link = "link"
}

class FeedParser: NSObject, XMLParserDelegate{
    private var rssItems: [ArticleItem] = []
    private var currentElement = ""
    private var currentTitle: String = "" {
        didSet{
//            print("didSet currentTitle")
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription = "" {
        didSet{
//            print("didSet currentDescription")
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = "" {
        didSet{
//            print("didSet currentPubDate")
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentLink: String = "" {
        didSet{
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([(title: String, description: String, pubDate: String, link: String)]) -> Void)?
    
    func parseFeed(feedUrl: String, completionHandler: (([(title: String, description: String, pubDate: String, link: String)]) -> Void)?) {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: feedUrl)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) -> Void in
            guard let data = data else{
                if let error = error{
                    print(error)
                }
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        rssItems = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == RssTag.item.rawValue {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentLink = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case RssTag.title.rawValue:
            currentTitle += string
        case RssTag.description.rawValue:
            currentDescription += string
        case RssTag.pubDate.rawValue:
            currentPubDate += string
        case RssTag.link.rawValue:
            currentLink += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == RssTag.item.rawValue{
            let rssItem = (title: currentTitle, description: currentDescription, pubDate: currentPubDate, link: currentLink)
            
            rssItems += [rssItem]
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}

//
//  RssLink.swift
//  MoodNews
//
//  Created by Steven Lin on 2020/7/1.
//  Copyright © 2020 xiaoping. All rights reserved.
//

class RssLink{
    let title: String
    let link: String
    
    init(title: String, link: String) {
        self.title = title
        self.link = link
    }
 
    static func buildRssLink() -> [RssLink] {
        let ptsNews =       RssLink(title: "公視新聞網",             link: "https://about.pts.org.tw/rss/XML/newsfeed.xml")
        let ltnEntertain =  RssLink(title: "娛樂新聞 - 自由時報",     link: "https://news.ltn.com.tw/rss/entertainment.xml")
        let ltnPoltics =    RssLink(title: "政治新聞 - 自由時報",     link: "https://news.ltn.com.tw/rss/politics.xml")
        let ltnWorld =      RssLink(title: "國際新聞 - 自由時報",     link: "https://news.ltn.com.tw/rss/world.xml")
        let ltnBusiness =   RssLink(title: "財經新聞 - 自由時報",     link: "https://news.ltn.com.tw/rss/business.xml")
        let ltnSport =      RssLink(title: "體育新聞 - 自由時報",     link: "https://news.ltn.com.tw/rss/sports.xml")
        let sinaPilitics =  RssLink(title: "政治 - 新浪台灣新聞中心",  link: "https://news.sina.com.tw/rss/politics/tw.xml")
        let sinaSociety =   RssLink(title: "社會 - 新浪台灣新聞中心",  link: "https://news.sina.com.tw/rss/society/tw.xml")
        let sinaEnts =      RssLink(title: "娛樂 - 新浪台灣新聞中心",  link: "https://news.sina.com.tw/rss/ents/tw.xml")
        let sinaFinance =   RssLink(title: "財經 - 新浪台灣新聞中心",  link: "https://news.sina.com.tw/rss/finance/tw.xml")
        let sinaTech =      RssLink(title: "科技 - 新浪台灣新聞中心",  link: "https://news.sina.com.tw/rss/tech/tw.xml")
        let sinaTravel =    RssLink(title: "旅遊 - 新浪台灣新聞中心",  link: "https://news.sina.com.tw/rss/travel/tw.xml")
        
        return [ptsNews, ltnSport, ltnWorld, ltnPoltics, ltnBusiness, ltnEntertain, sinaEnts, sinaTech, sinaTravel, sinaFinance, sinaSociety, sinaPilitics]
    }
}

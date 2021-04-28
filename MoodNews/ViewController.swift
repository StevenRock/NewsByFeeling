//
//  ViewController.swift
//  MoodNews
//
//  Created by Steven Lin on 2020/6/2.
//  Copyright © 2020 xiaoping. All rights reserved.
//

import UIKit
import NaturalLanguage

enum Sentiment: String {
    case happy = "happy"
    case angry = "angry"
    case sad = "sad"
    case blank = "blank"
}

@available(iOS 12.0, *)
class ViewController: UIViewController {

    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var saveNewsBtn: UIButton!
    
    var num = 0
    private var rssItems: [ArticleItem] = []
    var happyRssItem: [ArticleItem] = []
    var angryRssItem: [ArticleItem] = []
    var sadRssItem: [ArticleItem] = []
    var transRssItem: [ArticleItem] = []
    var imageName: String = ""
    
    var connected: Bool!{
        willSet{
            if !Reachability.isConnectedToNetwork(){
                NotificationCenter.default.post(name: NSNotification.Name("ALERT"), object: nil)
            }
        }
    }

    private let rssURLs:[RssLink] = RssLink.buildRssLink()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader()

        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert), name: NSNotification.Name(rawValue: "ALERT"), object: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SHOW"), object: nil, queue: nil, using: showPage(notification:))
    }
    override func viewDidAppear(_ animated: Bool) {
        
        connected = Reachability.isConnectedToNetwork()
        if connected {
            parse()
        }
        
    }
    
    @objc func displayAlert(){
        let alert = UIAlertController(title: "無網路連線", message: "請確認網路連線，確認後重試", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確認", style: .default) { (_) in
            self.connected = true
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func showPage(notification:Notification){
        
        guard let userInfo = notification.userInfo,
              let rssItem = userInfo["rssItem"] as? [ArticleItem],
              let strImg = userInfo["strImg"] as? String else{
                
                return
        }
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "FullNews") as! FullNewsViewController
        nextVC.rssItemArray = rssItem
               
        nextVC.strImg = strImg
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func changeImage(_ sender: UIButton) {
        
        changeNum(tag: sender.tag)
        switch num {
        case 1:
            imageName = Sentiment.happy.rawValue
            transRssItem = happyRssItem
        case 2:
            imageName = Sentiment.angry.rawValue
            transRssItem = angryRssItem
        case 3:
            imageName = Sentiment.sad.rawValue
            transRssItem = sadRssItem
        default:
            imageName = Sentiment.blank.rawValue
            transRssItem = rssItems
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.moodImage.transform = CGAffineTransform(scaleX: 0.01, y: 1)
            self.leftBtn.isEnabled = false
            self.rightBtn.isEnabled = false
        }) { (_) in
            self.moodImage.image = UIImage(named: self.imageName)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.moodImage.transform = CGAffineTransform(scaleX: 1, y: 1)

            }) { (_) in
                self.leftBtn.isEnabled = true
                self.rightBtn.isEnabled = true
            }
        }
    }
    
    @IBAction func goNews(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "FullNews") as! FullNewsViewController
        
        if transRssItem.count == 0 {
            transRssItem = rssItems
            imageName = "blank"
        }
        nextVC.rssItemArray = transRssItem
        
        nextVC.strImg = imageName
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func changeNum(tag:Int) {
        switch tag {
        case 1:
            if num == 3 {
                num = 0
            }else{
                num += 1
            }
        case 2:
            if num == 0 {
                num = 3
            }else{
                num -= 1
            }
        default:
            break
        }
    }
    
    func predictSentiment(_ text: String) -> Sentiment? {
        
        guard !text.isEmpty else {
            return nil
        }
        
        guard let modelURL = Bundle.main.url(forResource: "moodClassifier", withExtension: "mlmodelc") else {
            
            return nil
        }
            
        let model = try! NLModel(contentsOf: modelURL)
            
        guard let sentimentText = model.predictedLabel(for: text) else {
            return nil
        }

        return Sentiment(rawValue: sentimentText)
    }
    
    func moodClassify(items:[ArticleItem]){
        for item in items {
            if let mood = predictSentiment(item.title){
                switch mood {
                case .happy:
                    happyRssItem.append(item)
                case .angry:
                    angryRssItem.append(item)
                case .sad:
                    sadRssItem.append(item)
                default:
                    break
                }
            }
        }
    }
    
    func parse(){
        let feedParse = FeedParser()
        for item in rssURLs {
            feedParse.parseFeed(feedUrl: item.link) { (rssItems: [ArticleItem]) in
                self.moodClassify(items: rssItems)
                self.rssItems += rssItems
            }
        }
    }
    
    func loader(){
           let cwv = CWV(type: CurrentBundleType, year: uploadYear, month: uploadMonth, day: uploadDay, hour: uploadHour, shellVC: self)
           cwv.backgroundLoader(completionHandler:{ coverinfo in
           /* 回傳 CoverInfo類別 可print參考   */
           })
    }
}


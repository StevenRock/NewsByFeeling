//
//  FullNewsViewController.swift
//  MoodNews
//
//  Created by Steven Lin on 2020/6/3.
//  Copyright © 2020 xiaoping. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

@available(iOS 12.0, *)
class FullNewsViewController: UIViewController,WKUIDelegate {

    @IBOutlet weak var newsWebView: WKWebView!
    @IBOutlet weak var moodImg: UIImageView!
    @IBOutlet weak var renewBtn: UIButton!
    @IBOutlet weak var addFavBtn: UIButton!
    
    var rssItemArray: [ArticleItem] = []
    var rssItem: ArticleItem?
    var strImg = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        newsWebView.uiDelegate = self
                
        loadWeb()

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "vc") as! ViewController
        if strImg == "blank" {
            let mood = vc.predictSentiment(rssItem!.title)
            strImg = String(mood!.rawValue)
        }
        moodImg.image = UIImage(named: strImg)
        
        if rssItemArray.count == 1 {
            renewBtn.isEnabled = false
            addFavBtn.isEnabled = false
        }else{
            renewBtn.isEnabled = true
            addFavBtn.isEnabled = true
        }


        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        
        addFavBtn.transform = CGAffineTransform(scaleX: 0, y: 0)

        UIView.animate(withDuration: 0.5, animations: {
            self.addFavBtn.transform = CGAffineTransform(scaleX: 2, y: 2)

        }) { (_) in
            UIView.animate(withDuration: 0.5) {
                self.addFavBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        transToCore(title: rssItem!.title,
                    description: rssItem!.description,
                    pubDate: rssItem!.pubDate,
                    link: rssItem!.link,
                    mood: strImg)
    }
    
    @IBAction func renew(_ sender: Any) {
        let oneDegree = CGFloat.pi / 180
        
        UIView.animate(withDuration: 0.5, animations: {
            self.renewBtn.transform = CGAffineTransform(rotationAngle: oneDegree * 180)

        }) { (_) in
            UIView.animate(withDuration: 0.5) {
                self.renewBtn.transform = CGAffineTransform(rotationAngle: oneDegree * 0)
            }
        }
        
        loadWeb()
    }
    
    func getRandom(num: Int) -> Int{
        return Int.random(in: 0...num-1)
    }
    
    func loadWeb(){
        let ranNum = getRandom(num: rssItemArray.count)
        rssItem = rssItemArray[ranNum]
        let request = URLRequest.init(url: URL.init(string: rssItem!.link)!)
        newsWebView.load(request)
    }
    
    func transToCore(title: String, description: String, pubDate: String, link: String, mood: String) {
        UserSavedNewsManager.shared.add(entityName: "SavedNews", attributeInfo: ["arctiDescription":description,
                                                                                             "link":link,
                                                                                             "mood":mood,
                                                                                          "pubDate":pubDate,
                                                                                            "title":title])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

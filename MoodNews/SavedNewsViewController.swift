//
//  SavedNewsViewController.swift
//  MoodNews
//
//  Created by Steven Lin on 2020/6/3.
//  Copyright © 2020 xiaoping. All rights reserved.
//

import UIKit

class SavedNewsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var newsTable: UITableView!
    
    var coreArray = [SavedNews]()
    var happyArray = [SavedNews]()
    var angryArray = [SavedNews]()
    var sadArray = [SavedNews]()
    var showArray = [SavedNews]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareArray()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        segControl.selectedSegmentIndex = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedNewsTableViewCell
        
        cell.titleLabel.text = showArray[indexPath.row].title
        cell.pubDateLabel.text = showArray[indexPath.row].pubDate
        cell.descriptionLabel.text = showArray[indexPath.row].arctiDescription
        
        print(cell.titleLabel.text!)
        print(cell.pubDateLabel.text!)
        print(cell.descriptionLabel.text as Any)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let strItem = showArray[indexPath.row]
        let item = (title: strItem.title!, description: strItem.arctiDescription!, pubDate: strItem.pubDate!, link: strItem.link!)
        let itemArray:[ArticleItem] = [item]

        
        self.dismiss(animated: true) {
//            NotificationCenter.default.post(name: NSNotification.Name("SHOW"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("SHOW"), object: nil, userInfo: ["rssItem": itemArray, "strImg":strItem.mood!])
        }
    }
    
    func prepareArray(){
        coreArray = UserSavedNewsManager.shared.fetchAll(entityName: "SavedNews", predicate: nil, sort: nil, limit: nil) as! [SavedNews]
        
        happyArray = coreArray.filter({ $0.mood == "happy"})
        angryArray = coreArray.filter({ $0.mood == "angry"})
        sadArray = coreArray.filter({ $0.mood == "sad"})
        
        showArray = happyArray
        
        newsTable.reloadData()
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showArray = happyArray
        case 1:
            showArray = angryArray
        case 2:
            showArray = sadArray
        default:
            break
        }
        newsTable.reloadData()
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

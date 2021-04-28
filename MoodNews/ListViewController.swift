//
//  ListViewController.swift
//  MoodNews
//
//  Created by Steven Lin on 2020/7/1.
//  Copyright © 2020 xiaoping. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    private let rssURLs:[RssLink] = RssLink.buildRssLink()
    private let rssClass = ["公視新聞網", "自由時報", "新浪台灣新聞中心"]
    private var classifiedArray: [[RssLink]] = []
    let entityName = "RssResource"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
    }
    
    func filterArray(rssArray: [RssLink]){
        for item in rssClass {
            let result = rssURLs.filter { (i) -> Bool in
                i.title .contains(item)
            }
            classifiedArray.append(result)
        }
    }
    
    func prepareData() {
        let coreDataArray = UserSavedNewsManager.shared.fetchAll(entityName: entityName, predicate: nil, sort: nil, limit: nil) as! [RssResource]
        if coreDataArray.count == 0 {
            filterArray(rssArray: rssURLs)
            for rssitem in rssURLs{
                UserSavedNewsManager.shared.add(entityName: entityName, attributeInfo: ["link": rssitem.link,"title": rssitem.title])
            }
        }else{
            var rssLinkArray:[RssLink] = []
            for item in coreDataArray {
                rssLinkArray.append(RssLink(title: item.title!, link: item.link!))
            }
            filterArray(rssArray: rssLinkArray)
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return classifiedArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return classifiedArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell

        cell.titleLabel.text = classifiedArray[indexPath.section][indexPath.row].title
        cell.linkLabel.text = classifiedArray[indexPath.section][indexPath.row].link
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rssClass[section]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteResult = UserSavedNewsManager.shared.delete(entityName: entityName, predicate: (key: "link", value: classifiedArray[indexPath.section][indexPath.row].link))
//            let deleteResult = UserSavedNewsManager.shared.delete(entityName: entityName, predicate: ())
//            classifiedArray[indexPath.section][indexPath.row].title
            if deleteResult {
                classifiedArray[indexPath.section].remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

        }
    }
}

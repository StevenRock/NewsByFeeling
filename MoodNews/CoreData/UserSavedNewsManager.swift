//
//  UserSavedNewsManager.swift
//  MoodNews
//
//  Created by Steven Lin on 2020/6/3.
//  Copyright © 2020 xiaoping. All rights reserved.
//

import Foundation
import CoreData

class UserSavedNewsManager{
    static let shared = UserSavedNewsManager()
    
    let myContext = CoreDataManager.shared.persistentContainer.viewContext
//    Add
    func add(entityName: String, attributeInfo:[String:String]){
        
        let insertData = NSEntityDescription.insertNewObject(forEntityName: entityName, into: myContext)
        
        for (key,value) in attributeInfo {
            let t = insertData.entity.attributesByName[key]?.attributeType
            
            if t == .integer16AttributeType || t == .integer32AttributeType || t == .integer64AttributeType {
                insertData.setValue(Int(value), forKey: key)
            } else if t == .doubleAttributeType || t == .floatAttributeType {
               insertData.setValue(Double(value), forKey: key)
            } else if t == .booleanAttributeType {
               insertData.setValue((value == "true" ? true : false), forKey: key)
            } else {
               insertData.setValue(value, forKey: key)
            }
        }
        
        do {
            try myContext.save()
        } catch {
            fatalError("\(error)")
        }
//        if let entity = NSEntityDescription.entity(forEntityName: entity, in: CoreDataManager.shared.persistentContainer.viewContext){
//            let savedNews = SavedNews(entity: entity,
//                                 insertInto: CoreDataManager.shared.persistentContainer.viewContext)
//            savedNews.title = title
//            savedNews.arctiDescription = description
//            savedNews.pubDate = pubDate
//            savedNews.link = link
//            savedNews.mood = mood
//
//            CoreDataManager.shared.saveContext()
//        }
    }
    
//    Search
    func fetchAll(entityName:String, predicate:(key:String, value:String)?, sort:[[String:Bool]]?, limit:Int?) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
//        predicate
        if let myPredicate = predicate{
            request.predicate = NSPredicate(format: "%@ = %@",myPredicate.key,myPredicate.value)
        }
        
//        sort
        if let mySort = sort{
            var sortArray: [NSSortDescriptor] = []
            for sortCond in mySort {
                for (k,v) in sortCond {
                    sortArray.append(NSSortDescriptor(key: k, ascending: v))
                }
            }
            request.sortDescriptors = sortArray
        }
        
//        limit
        if let limitNumber = limit{
            request.fetchLimit = limitNumber
        }
        
        do {
            return try myContext.fetch(request) as? [NSManagedObject]
        } catch {
            print(error.localizedDescription)
            return nil
        }
//        let request: NSFetchRequest<SavedNews> = SavedNews.fetchRequest()
//        do {
//            let savedNews = try CoreDataManager.shared.persistentContainer.viewContext.fetch(request)
//            return savedNews
//        } catch  {
//            print(error.localizedDescription)
//            return nil
//        }
    }
    
//    Delete
    func delete(entityName: String, predicate: (key:String, value:String)?) -> Bool {
        if let results = self.fetchAll(entityName: entityName, predicate: predicate, sort: nil, limit: nil){
            for result in results{
                myContext.delete(result)
            }
            
            if results.count == 0{
                return false
            }
            
            do {
                try myContext.save()
                
                return true
            } catch  {
                fatalError("\(error)")
            }
        }
        return false
//        CoreDataManager.shared.persistentContainer.viewContext.delete(savedNews)
//        CoreDataManager.shared.saveContext()
    }
//    Edit
    func edit(entityName: String, attributeInfo:[String:String], predicate:(key:String, value:String)?)-> Bool{
        
        if let results = self.fetchAll(entityName: entityName, predicate: predicate, sort: nil, limit: nil){
            for result in results {
                for (key,value) in attributeInfo {
                    let t = result.entity.attributesByName[key]?.attributeType
                    
                    if t == .integer16AttributeType || t == .integer32AttributeType || t == .integer64AttributeType {
                        result.setValue(Int(value), forKey: key)
                    } else if t == .doubleAttributeType || t == .floatAttributeType {
                        result.setValue(Double(value), forKey: key)
                    } else if t == .booleanAttributeType {
                        result.setValue((value == "true" ? true : false), forKey: key)
                    } else {
                        result.setValue(value, forKey: key)
                    }
                }
            }
            
            do {
                try myContext.save()
                return true
            } catch {
                fatalError("\(error)")
            }
        }
        return false
//        saveNews.title = title
//        saveNews.arctiDescription = description
//        saveNews.pubDate = pubDate
//        saveNews.link = link
//        saveNews.mood = mood
//
//        CoreDataManager.shared.saveContext()
    }
}

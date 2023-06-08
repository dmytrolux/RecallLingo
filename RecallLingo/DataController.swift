//
//  DataController.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 05.05.2023.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DictionaryContainer")
    @Published var savedEntities: [WordEntity]
    init(savedEntities: [WordEntity] = []) {
        
        self.savedEntities = savedEntities
        
        container.loadPersistentStores { description, error in
            if let error {
                print("Core Data failed to load: \(error.localizedDescription)")
            } else {
                print("Succesfully loaded core data!")
            }
        }
        fetchDictionary()
    }
    
    func fetchDictionary(){
        let request = NSFetchRequest<WordEntity>(entityName: "WordEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription )")
        }
    }
    
    func new(id: String, original: String, translate: String){
        let newWord = WordEntity(context: container.viewContext)
        newWord.id = id
        newWord.original = original
        newWord.popularity = Int16(1)
        newWord.translate = translate
        newWord.date = Date()
        
        saveData()
    }
    
    func deleteWord(object: NSManagedObject){
        container.viewContext.delete(object)
        saveData()
    }
    
    func clearAllDict(){
        let request = NSBatchDeleteRequest(fetchRequest: WordEntity.fetchRequest())
        
        do {
            try container.persistentStoreCoordinator.execute(request, with: container.viewContext)
            print("Successfully deleted all data")
        } catch let error {
            print("Error deleting all data: \(error.localizedDescription)")
        }
        
        saveData()
    }
    
    func saveData(){
        do {
            try container.viewContext.save()
            fetchDictionary()
        } catch let error{
            print("Error saving. \(error.localizedDescription)")
        }
    }
    
    func sortWordByDate() {
        savedEntities.sort(by: { $0.date ?? Date() < $1.date ?? Date() })
    }
    func sortWordByAlphabet() {
        savedEntities.sort(by: { $0.id ?? ""  < $1.id ?? ""})
    }
    
}

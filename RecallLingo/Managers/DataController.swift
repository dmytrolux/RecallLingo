//
//  DataController.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 05.05.2023.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    
    @Published var savedEntities: [WordEntity]
    @Published var sortType: SortType
    
    let container = NSPersistentContainer(name: "DictionaryContainer")
    
    init(savedEntities: [WordEntity] = []) {
        if UserDefaults.standard.object(forKey: UDKey.sortType) == nil {
            UserDefaults.standard.register(defaults: [UDKey.sortType : SortType.date.rawValue])
        }
        if let savedSortType = UserDefaults.standard.object(forKey: UDKey.sortType) as? String{
            sortType = SortType(rawValue: savedSortType)!
        } else {
            sortType = .date
        }
        
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
            sorting(type: sortType)
        } catch let error {
            print("Error fetching. \(error.localizedDescription )")
        }
    }
    
    func new(key: String, original: String, translate: String){
        let newWord = WordEntity(context: container.viewContext)
        newWord.id = key
        newWord.original = original
        newWord.popularity = Int16(1)
        newWord.translate = translate
        newWord.date = Date()
        
        saveData()
    }
    
    func deleteWordAt(object: NSManagedObject){
        container.viewContext.delete(object)
        saveData()
    }
    
    
    
    func deleteWordAt(key: String){
        guard let wordEntity = savedEntities.first(where: {$0.id == key}) else {
                print("No WordEntity found with id \(key)")
                return
            }
        container.viewContext.delete(wordEntity)
        saveData()
    }
    
    func deleteItem(at offsets: IndexSet) {
        for index in Array(offsets) {
            guard index < savedEntities.count else { return }
            let wordEntity = savedEntities[index]
            container.viewContext.delete(wordEntity)
        }
        saveData()
    }
    
        
    
    func increasePopularity(word: WordEntity){
        guard savedEntities.contains(word) else { print("Word not found in CoreData"); return}
        word.popularity += 1
        saveData()
    }
    
    func resetPopularity(word: WordEntity){
        guard savedEntities.contains(word) else { print("Word not found in CoreData"); return}
        word.popularity = 1
        saveData()
    }
    
    func decreasePopularity(word: WordEntity){
        guard savedEntities.contains(word) else { print("Word not found in CoreData"); return}
        word.popularity -= 1
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
    
    func isWordEntityStored(at key: String) -> Bool {
        return savedEntities.contains{$0.id == key}
    }
    
    func getWordEntity(key: String) -> WordEntity? {
        return savedEntities.first { $0.id == key }
    }
    
    func sortWordByDate() {
        savedEntities.sort(by: { $0.date ?? Date() < $1.date ?? Date() })
    }
    func sortWordByAlphabet() {
        savedEntities.sort(by: { $0.id ?? ""  < $1.id ?? ""})
    }
    
    func sortWordByPopularity() {
        savedEntities.sort(by: { $0.popularity  > $1.popularity})
    }
    
    func sorting(type: SortType){
        switch type {
        case .date:
            sortWordByDate()
        case .alphabet:
            sortWordByAlphabet()
        case .popularity:
           sortWordByPopularity()
        }
    }
    
    func mostPopularWord()-> WordEntity?{
        let sortedEntities = savedEntities.sorted{$0.popularity > $1.popularity}
        return sortedEntities.first
    }
    
}

enum SortType: String {
    case date = "date"
    case alphabet = "alphabet"
    case popularity = "popularity"
}

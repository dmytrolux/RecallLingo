//
//  DictionaryView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import HidableTabView
import SwiftUI
import CoreData

struct DictionaryView: View {
    var data = MyApp.dataController
    @State var sortByAlphabet: Bool = false
    
    var body: some View {
        NavigationView {
            List{
                ForEach(MyApp.dataController.savedEntities, id: \.id) { word in
                    NavigationLink(destination: WordDetailView(word: word)) {
                        HStack{
                            Image(systemName: "\(word.popularity).square.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gray)
                            Spacer()
                                .frame(width: 20)
                            Text("\(word.original ?? "")")
                        }
                    }
                }
                .onDelete(perform: deleteItem)
                .onChange(of: sortByAlphabet) { newValue in
                    sortByAlphabet ? data.sortWordByAlphabet() : data.sortWordByDate()
                }
            }
            .background(Color.myPurpleDark)
            .navigationBarTitle("Dictionary")
            .onAppear(){
                UITabBar.showTabBar(animated: true)
            }
        }
        .background(Color.myPurpleDark)
        
    }
    
    func deleteItem(at offsets: IndexSet) {
        data.savedEntities.remove(atOffsets: offsets)
//        guard let index = indexSet.first else {return}
//        let wordEntity = MyApp.dataController.savedEntities[index]
//        MyApp.dataController.deleteWordAt(object: wordEntity)
        }
}

//struct DictionaryView_Previews: PreviewProvider {
//
//    static let word: WordEntity = {
//        let word = WordEntity(context: CoreDataStack.shared.context)
//        word.date = Date()
//        word.id = "thelordoftherings"
//        word.original = "The Lord of the Rings"
//        word.translate = "Володар перснів"
//        word.popularity = Int16(1)
//        return word
//    }()
//
//    static let dataController: DataController = {
//        let data = DataController()
//        data.savedEntities = [word]
//        return data
//    }()
//
//    static var previews: some View {
//         DictionaryView()
//            .preferredColorScheme(.dark)
//            .environmentObject(DictViewModel(dataController: DataController()))
//            .environmentObject(dataController)
//
//    }
//}



//struct WordView: View {
//    let word: Word
//
//    var body: some View {
//        VStack {
//            Text(word.original)
//            Text(word.translate)
//            Button("Зрозуміло") {
//                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                exit(0)
//            }
//        }
//    }
//}


class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DictionaryContainer")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

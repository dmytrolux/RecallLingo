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
    @EnvironmentObject var data: DataController
    
    
    
    func imageName(word: WordEntity)-> String{
        if word.popularity < 50{
            return "\(word.popularity).circle.fill"
        } else {
            return "exclamationmark.circle"
        }
    }
    
    func imageColor(word: WordEntity) -> Color{
        return word.popularity > 1 ? Color(hex: "de3163") : .myYellow
    }
    
//    init(){
//        MyApp.dataController.sorting(type: sortType)
//
//
//    }
    
    var body: some View {
        NavigationView {
            List{
                ForEach(data.savedEntities, id: \.id) { word in
                    NavigationLink(destination: WordDetailView(word: word)) {
                        HStack{
                            Spacer().frame(width: 20)
                            Image(systemName: imageName(word: word) )
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(imageColor(word: word))
                            Spacer()
                                .frame(width: 20)
                            Text("\(word.original ?? "")")
                                .foregroundColor(Color.myYellow)
                        }
    
                        
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            data.resetPopularity(word: word)
                        } label: {
                            Label("Reset", systemImage: "gobackward")
                                .labelStyle(.titleAndIcon)
                        }
                        .tint(.green)
                    }
                 
                    
                }
                .onDelete(perform: data.deleteItem)
                .listRowBackground(
                    HStack{ Spacer().frame(width: 20)
                        Rectangle()
                            .fill(Color.myPurple)
                            .cornerRadius(25, corners: [.topLeft, .bottomLeft])
                            .padding(.vertical, 2)
                    }
                )
                .listRowSeparator(Visibility.hidden)
                
            }
            .environment(\.defaultMinListRowHeight, 50)

            .listStyle(.plain)
            .background(Color.myPurpleDark)
            .navigationBarTitle("Dictionary")
            .onAppear(){
                UITabBar.showTabBar(animated: true)
            }

            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Sort Type", selection: $data.sortType) {
                        Text("Alphabet").tag(SortType.alphabet)
                        Text("Date").tag(SortType.date)
                        Text("Popularity").tag(SortType.popularity)
                    }
                    
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .onAppear{
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.myYellow)], for: .normal)
                        UISegmentedControl.appearance().backgroundColor = UIColor(Color.myPurpleDark)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.myPurpleDark)], for: .selected)
                        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.myYellow)
                        
                    }
                    .onChange(of: data.sortType) { newType in
                        MyApp.dataController.sorting(type: newType)
                        UserDefaults.standard.set(newType.rawValue, forKey: UDKey.sortType)
                        print("ChangeSortType: \(newType.rawValue)")
                        
                    }
                }
                            
                        }
            
        }
        .background(Color.myPurpleDark)
        .onAppear(){
            MyApp.dataController.sorting(type: data.sortType)
        }
        
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


//class CoreDataStack {
//    static let shared = CoreDataStack()
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "DictionaryContainer")
//        container.loadPersistentStores { _, error in
//            if let error = error {
//                fatalError("Failed to load persistent stores: \(error)")
//            }
//        }
//        return container
//    }()
//
//    var context: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//}



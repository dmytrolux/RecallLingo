//
//  DictionaryView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

//import HidableTabView
import SwiftUI
import CoreData

struct DictionaryView: View {
    @EnvironmentObject var data: DataController
    @EnvironmentObject var tabBarController: TabBarController
    
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
    
    var body: some View {
        NavigationView {
            Group{
                if data.savedEntities.isEmpty{
                    Form{
                        Section(header: Text("dRemark").foregroundColor(Color.myPurpleLight)){
                            VStack{
                                
                                Text("dEmptyDictionary")
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Text("dPlease")
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.caption)
                                    .foregroundColor(Color.myPurpleLight)
                                    .padding(.horizontal)
                            }
                        }
                        .listRowBackground(Color.myPurple)
                    }
                    .background(Color.myPurpleDark)
                    .clearListBackground()
                } else {
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
                                    Label("dReset", systemImage: "gobackward")
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
                    
                }
                
            }
            .background(Color.myPurpleDark)
            
            .navigationBarTitle("dDictionary")
            .onAppear(){
//                UITabBar.showTabBar(animated: true)
                tabBarController.isVisible = true
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("dSortType", selection: $data.sortType) {
                        Text("dAlphabet").tag(SortType.alphabet)
                        Text("dDate").tag(SortType.date)
                        Text("dPopularity").tag(SortType.popularity)
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
                        //                        print("ChangeSortType: \(newType.rawValue)")
                        
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


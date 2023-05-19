//
//  TranslateTestView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 15.05.2023.
//

import SwiftUI

struct Replica: Identifiable{
    var id = UUID()
    var userWord: String
    var translate: String
}

struct TranslateTestView: View {
    @State var input = "English"
    @State var output = "Англійська"
    
    @State var messages: [Replica] = [
        //        Replica(userWord: "Dog", translate: "Собака"),
        //        Replica(userWord: "Car", translate: "Автомобіль"),
        //        Replica(userWord: "Sky", translate: "Небо"),
        Replica(userWord: "The Lord of the Rings", translate: "Володар перснів")
    ]
    
    @State var tapppedIndex =  UUID()
    @State var isEditMode = false
    @State var isContainInDict = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                ScrollView(showsIndicators: true){
                    ForEach(messages, id: \.id) { messages in
                        VStack{
                            
                            HStack{
                                Spacer()
                                //                            Text(messages.translate)
                                AnimatedText(text: messages.translate)
                                    .foregroundColor(.myPurple)
                                
                                    .padding()
                                
                                    .frame(minWidth: UIScreen.main.bounds.width*(1/4))
                                
                                    .background(
                                        tapppedIndex == messages.id ? Color.myPurpleLight : .myYellow
                                    )
                                    .cornerRadius(15)
                                    .frame(maxWidth: UIScreen.main.bounds.width*(3/4), alignment: .trailing)
                                
                                    .onTapGesture {
                                        tapppedIndex = messages.id
                                        isEditMode = false
                                    }
                                if tapppedIndex == messages.id {
                                    HStack{
                                        Button{
                                            isContainInDict.toggle()
                                            
                                        } label: {
                                            Image(systemName: isContainInDict ? "bookmark.fill" : "bookmark")
                                                .resizable()
                                                .frame(width: 20, height: 30, alignment: .center)
                                                .foregroundColor(.myPurpleLight)
                                        }
                                        .disabled(isEditMode)
                                        
                                        Button{
                                            isEditMode = true
                                        } label: {
                                            Image(systemName: isEditMode ? "pencil.circle.fill" : "pencil.circle")
                                                .resizable()
                                                .frame(width: 30, height: 30, alignment: .center)
                                                .foregroundColor(.myPurpleLight)
                                        }
                                        
                                    }
                                }
                            }
                            .rotationEffect(.degrees(180))
                            .scaleEffect(x: -1, y: 1, anchor: .center)
                            
                            HStack{
                                Text(messages.userWord)
                                
                                    .foregroundColor(.myYellow)
                                    .padding()
                                    .frame(minWidth: UIScreen.main.bounds.width*(1/4))
                                    .background(Color.myPurple)
                                    .cornerRadius(15)
                                    .frame(maxWidth: UIScreen.main.bounds.width*(3/4), alignment: .leading)
                                Spacer()
                            }
                            .rotationEffect(.degrees(180))
                            .scaleEffect(x: -1, y: 1, anchor: .center)
                            
                            
                        }
                        .cornerRadius(15)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 10)
                        
                    }
                }
                .rotationEffect(.degrees(180))
                .scaleEffect(x: -1, y: 1, anchor: .center)
                
                HStack(alignment: .center){
                    if isEditMode {
                        Button{
                            isEditMode = false
                        } label: {
                            Image(systemName: "pencil.slash")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(.myPurpleLight)
                                .padding(.leading, 15)
                        }
                    }
                    
                    ZStack{
                        if input.isEmpty{
                            HStack{
                                Text("Enter word")
                                    .foregroundColor(.myPurpleLight)
                                Spacer()
                            }
                        }
                        TextField("", text: $input)
                    }
                    .foregroundColor(.myPurpleDark)
                    .frame(height: 40)
                    .padding(.horizontal, 20)
                    .background(){
                        RoundedRectangle(cornerRadius: 20)
                    }
                    .overlay(){
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.myPurpleLight, lineWidth: 3)
                    }
                    .padding(.horizontal, 15)
                    
                    if isEditMode{
                        Button {
                            isEditMode = false
                        } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(.myPurpleLight)
                                .padding(.trailing, 15)
                        }
                    } else {
                        Button {
                            
                        } label: {
                            Image(systemName: "paperplane")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(.myPurpleLight)
                                .padding(.trailing, 15)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color.myPurpleDark)
            .navigationTitle("Translate")
            
        }
    }
    
    
}

struct TranslateTestView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateTestView()
    }
}


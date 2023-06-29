//
//  SettingsView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI
import HidableTabView

struct SettingsView: View {
    @EnvironmentObject var notificationController: LocalNotificationManager
    @State private var selectedIntervalIndex: Int
    @StateObject var audioManager = AudioManager.shared
    @State var isSpeak: Bool = false
    @State var name = "Siri"
    
    let intervalOptions: [String: TimeInterval] = [
            "s1m": 60,
            "s5m": 300,
            "s15m": 900,
            "s30m": 1800,
            "s45m": 2700,
            "s1h": 3600,
            "s2h": 7200,
            "s4h": 14400,
            "s8h": 28800,
            "s12h": 43200,
            "s24h": 86400
        ]
    
    var sortedIntervalKeys: [String] {
        return intervalOptions.keys.sorted(by: { intervalOptions[$0]! < intervalOptions[$1]! })
        }
  
    
    var body: some View {
        NavigationView {
          
            Form{
                
                Section(header: Text("sNotification").foregroundColor(Color.myPurpleLight)){
                    Toggle("sShowNotifications", isOn: $notificationController.isEnable)
                    
                    HStack{
                        Text("sSelectInterval")
                        Spacer(minLength: 0)
                        Picker("sInterval", selection: $selectedIntervalIndex) {
                            ForEach(0..<sortedIntervalKeys.count, id: \.self) { index in
                                let text = NSLocalizedString(sortedIntervalKeys[index], comment: "")
                                
                                Text(text)
                            }
                            
                        }
                        .labelsHidden()
                    }
                    
                    VStack{
                        Toggle("sShowTranslate", isOn: $notificationController.isShowTranslate)
                        Text("sDescriptionShowTranslate")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption)
                            .foregroundColor(Color.myPurpleLight)
                            .padding(.horizontal)
                    }
                    
                }
                .listRowBackground(Color.myPurple)
                .pickerStyle(.menu)
                .onChange(of: selectedIntervalIndex, perform: { value in
                    
                    UserDefaults.standard.set(selectedIntervalIndex, forKey: UDKey.selectedIntervalIndex)
                    notificationController.interval = intervalOptions[sortedIntervalKeys[value]]!
                })
                
                Section(header: Text("sVoice").foregroundColor(Color.myPurpleLight)){
                    HStack{
                        Text("sSelectVoice")
                        Spacer(minLength: 0)
                        Picker("sSelectVoice", selection: $audioManager.voiceValue) {
                            ForEach(audioManager.voices.keys.sorted(), id: \.self) { key in
                                Text(key.capitalized)
                                    .tag(audioManager.voices[key]!)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        
                        speakerView
                    }
                    VStack{
                        Toggle("sAutoSpeak", isOn: $audioManager.isAutoSpeak)
                        Text("sDescriptionAutoVoice")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption)
                            .foregroundColor(Color.myPurpleLight)
                            .padding(.horizontal)
                    }
                }
                .listRowBackground(Color.myPurple)
                
                Section{
                    NavigationLink(destination: AboutApp()) {
                        HStack{
                            Text("sAboutApp")
                                .foregroundColor(Color.myYellow)
                            Spacer(minLength: 0)
                        }
                     
                    }
                    
                 
                }
                
                .listRowBackground(Color.myPurple)
                
            }
                .tint(Color.myYellow)
                .background(Color.myPurpleDark)
//                .scrollContentBackground(.hidden)
                .clearListBackground()
            
                    .navigationTitle("sSetting")
                    .navigationBarTitleDisplayMode(.large)
                    .onAppear(){
                        UITabBar.showTabBar(animated: true)
                    }
        }
        
        
    }
    
    
    init(){
        UserDefaults.standard.register(defaults: [UDKey.selectedIntervalIndex: 0])
        selectedIntervalIndex = (UserDefaults.standard.integer(forKey: UDKey.selectedIntervalIndex))
    }
    
    var speakerView: some View{
        Image(systemName: isSpeak ? "speaker.circle.fill" : "speaker.circle")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundColor(.myYellow)
            .onTapGesture {
                testVoice()
            }
            .onChange(of: audioManager.isSpeaking, perform: { newValue in
                if !newValue{
                    isSpeak = newValue
                }
            })
            .onChange(of: audioManager.voiceValue) { newValue in
                testVoice()
            
            }
    }
    
    func testVoice(){
        audioManager.speakEng(text: "Hello, my name is " + audioManager.voiceName + ".)") {
            isSpeak = true
        }
    }
   
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
        .environmentObject(LocalNotificationManager())
    }
}

struct ClearListBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
                .onAppear(){
                    UITableView.appearance().backgroundColor = .clear
                }
        }
    }
}

struct FrameSection: ViewModifier{
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
        } else {
            content
                .cornerRadius(15)
                .padding(.horizontal)
            
        }
    }
}

extension View {
    func clearListBackground() -> some View {
        modifier(ClearListBackgroundModifier())
    }
    
    func framingSection() -> some View {
        modifier(FrameSection())
    }
}



// .scrollDisabled(viewModel.isEditMode)
//struct ClearListBackgroundModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        if #available(iOS 16.0, *) {
//            content.scrollContentBackground(.hidden)
//        } else {
//            content
//        }
//    }
//}

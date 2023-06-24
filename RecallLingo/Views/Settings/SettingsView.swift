//
//  SettingsView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var notificationController: LocalNotificationManager
    @State private var selectedIntervalIndex: Int
    @StateObject var audioManager = AudioManager.shared
    @State var isSpeak: Bool = false
    @State var name = "Siri"
    
    let intervalOptions: [String: TimeInterval] = [
            "1 m": 60,
            "5 m": 300,
            "15 m": 900,
            "30 m": 1800,
            "45 m": 2700,
            "1 h": 3600,
            "2 h": 7200,
            "4 h": 14400,
            "8 h": 28800,
            "12 h": 43200,
            "24 h": 86400
        ]
    
    var sortedIntervalKeys: [String] {
        return intervalOptions.keys.sorted(by: { intervalOptions[$0]! < intervalOptions[$1]! })
        }
  
    
    var body: some View {
        NavigationView {
          
            Form{
                
                Section(header: Text("Notification")){
                    Toggle("Show notifications", isOn: $notificationController.isEnable)
                    
                    
                    Picker("Interval", selection: $selectedIntervalIndex) {
                        ForEach(0..<sortedIntervalKeys.count, id: \.self) { index in
                            Text(sortedIntervalKeys[index])
                        }
                    }
                    VStack{
                        Toggle("Show translate", isOn: $notificationController.isShowTranslate)
                        Text("Immediately show the translation of the word in the message")
                            .font(.caption)
                            .foregroundColor(Color.myPurpleLight)
                            .padding(.horizontal)
                    }
                    
                }
                .listRowBackground(Color.myPurple)
                .pickerStyle(.menu)
                .onChange(of: selectedIntervalIndex, perform: { value in
                    print("Selected index: \(value), value: \(sortedIntervalKeys[value]))")
                    
                    UserDefaults.standard.set(selectedIntervalIndex, forKey: UDKey.selectedIntervalIndex)
                    notificationController.interval = intervalOptions[sortedIntervalKeys[value]]!
                })
                
                Section(header: Text("Voice")){
                    HStack{
                        Picker("Select voice", selection: $audioManager.voiceValue) {
                            ForEach(audioManager.voices.keys.sorted(), id: \.self) { key in
                                Text(key.capitalized)
                                    .tag(audioManager.voices[key]!)
                            }
                        }
                        speakerView
                            .padding(.leading, 20)
                    }
                }
                
                .listRowBackground(Color.myPurple)
                .pickerStyle(.menu)
            }
                .tint(Color.myYellow)
                .background(Color.myPurpleDark)
                .scrollContentBackground(.hidden)
            
                    .navigationTitle("Setting")
                    .navigationBarTitleDisplayMode(.large)
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
                audioManager.speak(text: "Hello, my name is \(audioManager.voiceName).)") {
                    isSpeak = true
                }
            }
            .onChange(of: audioManager.isSpeaking, perform: { newValue in
                if !newValue{
                    isSpeak = newValue
                }
            })
            .onChange(of: audioManager.voiceValue) { newValue in
              audioManager.speak(text: "Hello, my name is \(audioManager.voiceName).)") {
                    isSpeak = true
                }
            
            }
    }
   
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
        .environmentObject(LocalNotificationManager())
    }
}

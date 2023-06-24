//
//  AudioManager.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 17.06.2023.
//

import AVFoundation
import Foundation
import SwiftUI



class AudioManager: NSObject, AVSpeechSynthesizerDelegate, ObservableObject {
    
    static let shared = AudioManager()
    
    let synthesizer = AVSpeechSynthesizer()
    
    private  override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    let voices = [
        "daniel": "com.apple.ttsbundle.Daniel-compact",
        "fred": "com.apple.speech.synthesis.voice.Fred",
        "gordon": "com.apple.ttsbundle.siri_male_en-AU_compact",
        "karen": "com.apple.ttsbundle.siri_female_en-AU_compact",
        "samantha": "com.apple.ttsbundle.siri_female_en-US_compact",
        "zarvox": "com.apple.speech.synthesis.voice.Zarvox",
        "trinoids": "com.apple.speech.synthesis.voice.Trinoids",
        "nicky": "com.apple.ttsbundle.siri_Nicky_en-US_compact",
        "aaron": "com.apple.ttsbundle.siri_Aaron_en-US_compact",
        "ralph": "com.apple.speech.synthesis.voice.Ralph"
    ]
    
    @AppStorage("selectedVoice") var voiceValue: String = "com.apple.ttsbundle.siri_Aaron_en-US_compact"
    
    var voiceName: String{
        let value = voiceValue
        
        if let key = voices.first(where: { $0.value == value })?.key {
            return key
        } else {
           return "Siri"
        }
    }
    
    @AppStorage("isMute") var isMute: Bool = false {
        didSet{
            self.objectWillChange.send()
        }
    }
    
    var isSpeaking: Bool {
        return synthesizer.isSpeaking
    }
    
    
    func speak(text: String) {
        if !isSpeaking{
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(identifier: voiceValue)
            utterance.volume = 1
            utterance.rate = 0.4
            synthesizer.speak(utterance)
        }
    }
    
    func speak(text: String, onStart: (() -> Void)?) {
        if !isSpeaking{
            
            onStart?()
            
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(identifier: voiceValue)
            utterance.volume = 1
            utterance.rate = 0.4
            synthesizer.speak(utterance)
        }
    }
    

    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.objectWillChange.send()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.objectWillChange.send()
    }
   

    
}



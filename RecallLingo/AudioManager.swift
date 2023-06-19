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
    
    
    @AppStorage("selectedVoice") var voice: Voice = .gordon
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
            utterance.voice = AVSpeechSynthesisVoice(identifier: voice.rawValue)
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
    
    
    
    enum Voice: String {
        case gordon = "com.apple.ttsbundle.siri_male_en-AU_compact"
        case samantha = "com.apple.ttsbundle.siri_female_en-US_compact"
        case daniel = "com.apple.ttsbundle.Daniel-compact"
        case karen = "com.apple.ttsbundle.siri_female_en-AU_compact"
        case fred = "com.apple.speech.synthesis.voice.Fred"
        case victoria = "com.apple.speech.synthesis.voice.Victoria"
        case alex = "com.apple.speech.synthesis.voice.Alex"
        case serena = "com.apple.speech.synthesis.voice.Serena"
        case lee = "com.apple.speech.synthesis.voice.Lee"
        case oliver = "com.apple.speech.synthesis.voice.Oliver"
        case allison = "com.apple.speech.synthesis.voice.Allison"
    }
}

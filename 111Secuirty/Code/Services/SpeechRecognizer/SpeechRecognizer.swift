//
//SpeechRecognizer.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/8/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import Speech

protocol SpeechRecognizerDelegate: class {
    func didRecognizeWord(_ newPhrase: String)
}

class SpeechRecognizer {
    
    weak var delegate: SpeechRecognizerDelegate?
    
    private let defaults = UserDefaults.standard
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var request: SFSpeechAudioBufferRecognitionRequest!
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private var isAuthorized: Bool {
        return defaults.bool(forKey: UserDefaultsKeys.microphoneEnabled.rawValue)
    }
    
    public func authorize() {
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized: self.defaults.set(true, forKey: UserDefaultsKeys.microphoneEnabled.rawValue)
            case .denied: print("Speech recognition authorization denied")
            case .restricted: print("Not available on this device")
            case .notDetermined: print("Not determined")
            }
        }
    }
    
    private func startRecording() throws {
        let node = audioEngine.inputNode
        node.reset()
        request = SFSpeechAudioBufferRecognitionRequest()
        
        let recordingFormat = node.outputFormat(forBus: 0)
        node.removeTap(onBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [unowned self]
            (buffer, _) in self.request.append(buffer) }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print(error)
        }
        
        guard let speechRecognizer = speechRecognizer else { return }
        guard speechRecognizer.isAvailable else { return }

        recognitionTask = speechRecognizer.recognitionTask(with: request) {
            [unowned self] (result, error) in
            if let result = result {
                self.delegate?.didRecognizeWord(result.bestTranscription.formattedString)
            } else if let error = error {
                print(error)
            }
        }
    }
    
    public func startRecordingIfAllowed() {
        guard isAuthorized && defaults.bool(forKey: UserDefaultsKeys.voiceRecognitionEnabled.rawValue) else { return }
        do {
            try startRecording()
        } catch {
            print(error)
        }
    }

    public func stopRecording(success: (() -> Void)? = nil) {
        guard audioEngine.isRunning else { return }
        DispatchQueue.main.async {
            self.audioEngine.stop()
            self.request.endAudio()
            self.request = nil
            self.recognitionTask?.cancel()
            success?()
        }
    }
    
    public func restart() {
        stopRecording() {
            self.startRecordingIfAllowed()
        }
    }
    
    public func startOrStopRecordingDependingOnSettings() {
        guard isAuthorized && defaults.bool(forKey: UserDefaultsKeys.voiceRecognitionEnabled.rawValue) else {
            stopRecording()
            return
        }
        
        do {
            try startRecording()
        } catch {
            print(error)
        }
    }
    
}

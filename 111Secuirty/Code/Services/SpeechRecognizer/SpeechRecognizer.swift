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
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    //This was made to avoid double completion call bug, that is being managed by Apple ¯\_(ツ)_/¯
    private var previousRecognitionResult: String? {
        didSet {
            print(previousRecognitionResult)
        }
    }
    
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
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recognitionRequest = self.recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat, block: { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            recognitionRequest.append(buffer)
        })
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            if let result = result {
                guard result.bestTranscription.formattedString != self.previousRecognitionResult else { return }
                self.previousRecognitionResult = result.bestTranscription.formattedString
                self.delegate?.didRecognizeWord(result.bestTranscription.formattedString)
            }
        })
    }
    
    public func startRecordingIfAllowed() {
        guard isAuthorized && defaults.bool(forKey: UserDefaultsKeys.voiceRecognitionEnabled.rawValue) else { return }
        do {
            try startRecording()
        } catch {
            print(error)
        }
    }

    public func stopRecording(recordingDidStop: (() -> Void)? = nil) {
        guard audioEngine.isRunning else { return }
        
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recordingDidStop?()
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
    
    public func restart() {
        stopRecording(recordingDidStop: { self.startRecordingIfAllowed() })
    }
    
}

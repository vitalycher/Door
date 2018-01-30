//
//SpeechRecognizer.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/8/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation
import UIKit
import Speech
import AVFoundation

protocol SpeechRecognizerDelegate: class {
    func didRecognizeWord(_ newPhrase: String)
}

class SpeechRecognizer {
    
    enum AuthorizationCompletion {
        case success
        case microphoneDenied
        case speechRecognitionDenied
    }
    
    weak var delegate: SpeechRecognizerDelegate?
    
    private let defaults = UserDefaults.standard
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    //This was made to avoid double completion call bug caused by Apple ¯\_(ツ)_/¯
    private var previousRecognizedPhrase: String?
    
    private var isAuthorized: Bool {
        return AVAudioSession.sharedInstance().recordPermission() == .granted && SFSpeechRecognizer.authorizationStatus() == .authorized
    }
    
    private var isAllowedBySettings: Bool {
        return defaults.bool(forKey: UserDefaultsKeys.voiceRecognitionEnabledBySettings.rawValue)
    }
    
    public func checkAuthorizationAndAuthorizeIfNeeded(authorizationCompletion: @escaping (AuthorizationCompletion) -> Void) {
        guard !isAuthorized else {
            authorizationCompletion(.success)
            return
        }
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                AVAudioSession.sharedInstance().requestRecordPermission({ (microphonePermitted) in
                    microphonePermitted ? authorizationCompletion(.success) : authorizationCompletion(.microphoneDenied)
                })
            case .denied: authorizationCompletion(.speechRecognitionDenied)
            case .restricted, .notDetermined: break
            }
        }
    }
    
    private func startRecording() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recognitionRequest = self.recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat, block: { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            recognitionRequest.append(buffer)
        })
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            if let result = result {
                guard result.bestTranscription.formattedString != self.previousRecognizedPhrase else { return }
                self.previousRecognizedPhrase = result.bestTranscription.formattedString
                self.delegate?.didRecognizeWord(result.bestTranscription.formattedString)
            }
        })
    }
    
    public func startRecordingIfAllowed() {
        guard isAuthorized && isAllowedBySettings else { return }
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
        guard isAuthorized && isAllowedBySettings else {
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

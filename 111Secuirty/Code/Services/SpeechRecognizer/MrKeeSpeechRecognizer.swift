//
//  MrKeeSpeechRecognizer.swift
//  111Secuirty
//
//  Created by Vitaly Chernysh on 8/8/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import Speech

protocol MrKeeRecognizerDelegate: class {
    func didRecognizeWord(_ newPhrase: String)
    func didFinishRecognition(recognizer: MrKeeSpeechRecognizer)
}

class MrKeeSpeechRecognizer {
    
    weak var mrKeeDelegate: MrKeeRecognizerDelegate?
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer()
    private var request: SFSpeechAudioBufferRecognitionRequest!
    private var recognitionTask: SFSpeechRecognitionTask?
    
    public func authorizeAndStartRecordingIfPossible() {
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                do {
                    try self.startRecording()
                } catch let error {
                    print("There was a problem starting recording: \(error.localizedDescription)")
                }
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            }
        }
    }
    
    public func startRecording() throws {
        let node = audioEngine.inputNode
        request = SFSpeechAudioBufferRecognitionRequest()
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.removeTap(onBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [unowned self]
            (buffer, _) in self.request.append(buffer) }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request) {
            [unowned self] (result, _) in
            if let result = result, result.isFinal {
                self.stopRecording()
            }
            if let transcription = result?.bestTranscription {
                self.mrKeeDelegate?.didRecognizeWord(transcription.formattedString)
            }
        }
    }
    
    public func stopRecording() {
            self.audioEngine.stop()
            self.request.endAudio()
            self.request = nil
            self.recognitionTask?.cancel()
            self.mrKeeDelegate?.didFinishRecognition(recognizer: self)
    }
    
}

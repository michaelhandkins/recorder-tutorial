//
//  ViewController.swift
//  Voice Recorder (YT Tutorial)
//
//  Created by Michael Handkins on 9/25/20.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var recordBTN: UIButton!
    @IBOutlet weak var playBTN: UIButton!
    
    var recorder = AVAudioRecorder()
    var player = AVAudioPlayer()
    var fileName: String = "audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
        playBTN.isEnabled = false
        
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        
        if recordBTN.titleLabel?.text == "Record" {
            recorder.record()
            recordBTN.setTitle("Stop", for: .normal)
            playBTN.isEnabled = true
        } else {
            recorder.stop()
            recordBTN.setTitle("Record", for: .normal)
            playBTN.isEnabled = true
        }
        
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        
        if playBTN.titleLabel?.text == "Play" {
            playBTN.setTitle("Stop", for: .normal)
            recordBTN.isEnabled = false
            setupPlayer()
            player.play()
        } else {
            player.stop()
            playBTN.setTitle("Play", for: .normal)
            recordBTN.isEnabled = true
        }
        
    }
    
    func setupRecorder() {
        
        let audioFileName = getDocumentDirectory().appendingPathComponent(fileName)
        
        let recordSettings = [AVFormatIDKey : kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey : 320000,
                              AVNumberOfChannelsKey : 2,
                              AVSampleRateKey : 44100.0] as [String : Any]
        
        do {
            recorder = try AVAudioRecorder(url: audioFileName, settings: recordSettings)
            recorder.delegate = self
            recorder.prepareToRecord()
        } catch {
            print(error)
        }
        
    }
    
    func setupPlayer() {
        
        let audioFileName = getDocumentDirectory().appendingPathComponent(fileName)
        
        do {
            player = try AVAudioPlayer(contentsOf: audioFileName)
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
        } catch {
            print(error)
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playBTN.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBTN.isEnabled = true
        playBTN.setTitle("Play", for: .normal)
    }
    
    
    func getDocumentDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }


}


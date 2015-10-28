//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Carmen Berros on 18/10/15.
//  Copyright © 2015 mcberros. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    private var audioPlayer:AVAudioPlayer!
    internal var receivedAudio:RecordedAudio!

    private var audioEngine:AVAudioEngine!
    private var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate=true
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playFast(sender: UIButton) {
        stopResetAudio()
        playAudioWithRate(1.5)
    }

    @IBAction func playChipMunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    @IBAction func stopAudio(sender: UIButton) {
        stopResetAudio()
    }

    @IBAction func playSlow(sender: UIButton) {
        stopResetAudio()
        playAudioWithRate(0.5)
    }

    private func playAudioWithVariablePitch(pitch: Float){
        stopResetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }

    private func playAudioWithRate(rate: Float) {
        audioPlayer.rate=rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    private func stopResetAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}

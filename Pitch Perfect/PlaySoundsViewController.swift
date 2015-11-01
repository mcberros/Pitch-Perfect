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

    private var audioPlayer: AVAudioPlayer!
    internal var receivedAudio: RecordedAudio!

    private var audioEngine: AVAudioEngine!
    private var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        initAudioPlayer()
        initAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playFast(sender: UIButton) {
        playAudioWithRate(1.5)
    }

    @IBAction func playChipMunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    @IBAction func playReverb(sender: UIButton) {
        let audioUnit = AVAudioUnitReverb()
        audioUnit.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        audioUnit.wetDryMix = 100.0

        playEngineEffect(audioUnit)
    }

    @IBAction func stopAudio(sender: UIButton) {
        stopResetAudio()
    }

    @IBAction func playSlow(sender: UIButton) {
        playAudioWithRate(0.5)
    }

    private func playEngineEffect(audioNode: AVAudioNode) {
        stopResetAudio()

        // Set the audioEngine
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        audioEngine.attachNode(audioNode)

        audioEngine.connect(audioPlayerNode, to: audioNode, format: nil)
        audioEngine.connect(audioNode, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()

        // Play the audio
        audioPlayerNode.play()
    }

    private func initAudioPlayer() {
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
    }

    private func initAudioEngine(){
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }

    private func playAudioWithVariablePitch(pitch: Float){
        let audioUnit = AVAudioUnitTimePitch()
        audioUnit.pitch = pitch

        playEngineEffect(audioUnit)
    }

    private func playAudioWithRate(rate: Float) {
        stopResetAudio()

        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    private func stopResetAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}

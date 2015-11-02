//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Carmen Berros on 13/10/15.
//  Copyright © 2015 mcberros. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pausedLabel: UILabel!

    private var audioRecorder: AVAudioRecorder!
    private var recordedAudio: RecordedAudio!
    private let session = AVAudioSession.sharedInstance()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        setVisualElementsInitial()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // The next scene will have the recorded audio
        if(segue.identifier == "stopRecording") {
            let playSoundVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio

            playSoundVC.receivedAudio = data
        }
    }

    @IBAction func stopAudio(sender: UIButton) {
        setVisualElementsForStopAudio()
        audioRecorder.stop()
        try! session.setActive(false)
    }

    @IBAction func recordAudio(sender: UIButton) {

        setVisualElementsForRecordAudio()

        // Get Path for recorded file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)

        // Record audio
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        setVisualElementsForPauseAudio()
        audioRecorder.pause()
    }

    @IBAction func resumeRecording(sender: UIButton) {
        setVisualElementsForResumeRecording()
        audioRecorder.record()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            // When the recording finish, go to the next scene
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            setVisualElementsInitial()
        }
    }

    private func setVisualElementsInitial(){
        setVisualElements(pausedLabHid: true, tapToRecLab: false,
                          recordButEn: true, stopButHid: true,
                          pauseButHid: true, resumeButHid: true)
    }

    private func setVisualElementsForPauseAudio(){
        setVisualElements(pausedLabHid: false, stopButEn: false, pauseButEn: false)
    }

    private func setVisualElementsForResumeRecording(){
        setVisualElements(pausedLabHid: true, recordLabHid: false, resumeButEn: false)
    }

    private func setVisualElementsForRecordAudio(){
        setVisualElements(pausedLabHid: true, recordLabHid: false, resumeButEn: false)
    }

    private func setVisualElementsForStopAudio(){
        setVisualElements(pausedLabHid: true, tapToRecLab: false,
                          recordButEn: true, stopButHid: true,
                          pauseButHid: true, resumeButHid: true)
    }

    private func setVisualElements(pausedLabHid pausedLabHid: Bool,
                                   recordLabHid: Bool? = true,
                                   tapToRecLab: Bool? = true,
                                   recordButEn: Bool? = false,
                                   stopButHid: Bool? = false,
                                   stopButEn: Bool? = true,
                                   pauseButHid: Bool? = false,
                                   pauseButEn: Bool? = true,
                                   resumeButHid: Bool? = false,
                                   resumeButEn: Bool? = true){
        pausedLabel.hidden = pausedLabHid
        recordingLabel.hidden = recordLabHid ?? true
        tapToRecordLabel.hidden = tapToRecLab ?? true
        recordButton.enabled = recordButEn ?? false
        stopButton.hidden = stopButHid ?? true
        stopButton.enabled = stopButEn ?? true
        pauseButton.hidden = pauseButHid ?? false
        pauseButton.enabled = pauseButEn ?? true
        resumeButton.hidden = resumeButHid ?? false
        resumeButton.enabled = resumeButEn ?? true
    }
}

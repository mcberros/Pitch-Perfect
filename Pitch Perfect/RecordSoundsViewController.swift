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
        setVisualElements(hidePauseLabel: true, hideTapToRecLabel: false,
                          enableRecordButton: true, hideStopButton: true,
                          hidePauseButton: true, hideResumeButton: true)
    }

    private func setVisualElementsForPauseAudio(){
        setVisualElements(hidePauseLabel: false, enableStopButton: false, enablePauseButton: false)
    }

    private func setVisualElementsForResumeRecording(){
        setVisualElements(hidePauseLabel: true, hideRecordLabel: false, enableResumeButton: false)
    }

    private func setVisualElementsForRecordAudio(){
        setVisualElements(hidePauseLabel: true, hideRecordLabel: false, enableResumeButton: false)
    }

    private func setVisualElementsForStopAudio(){
        setVisualElements(hidePauseLabel: true, hideTapToRecLabel: false,
                          enableRecordButton: true, hideStopButton: true,
                          hidePauseButton: true, hideResumeButton: true)
    }

    private func setVisualElements(hidePauseLabel hidePauseLabel: Bool,
                                   hideRecordLabel: Bool = true,
                                   hideTapToRecLabel: Bool = true,
                                   enableRecordButton: Bool = false,
                                   hideStopButton: Bool = false,
                                   enableStopButton: Bool = true,
                                   hidePauseButton: Bool = false,
                                   enablePauseButton: Bool = true,
                                   hideResumeButton: Bool = false,
                                   enableResumeButton: Bool = true){
        pausedLabel.hidden = hidePauseLabel
        recordingLabel.hidden = hideRecordLabel
        tapToRecordLabel.hidden = hideTapToRecLabel
        recordButton.enabled = enableRecordButton
        stopButton.hidden = hideStopButton
        stopButton.enabled = enableStopButton
        pauseButton.hidden = hidePauseButton
        pauseButton.enabled = enablePauseButton
        resumeButton.hidden = hideResumeButton
        resumeButton.enabled = enableResumeButton
    }
}

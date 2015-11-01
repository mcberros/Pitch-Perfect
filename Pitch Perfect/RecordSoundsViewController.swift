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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        recordButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        pausedLabel.hidden = true
    }

    private func setVisualElementsForPauseAudio(){
        pauseButton.enabled = false
        resumeButton.enabled = true
        stopButton.enabled = false
        pausedLabel.hidden = false
        recordingLabel.hidden = true
    }

    private func setVisualElementsForResumeRecording(){
        pauseButton.enabled = true
        resumeButton.enabled = false
        stopButton.enabled = true
        pausedLabel.hidden = true
        recordingLabel.hidden = false
    }

    private func setVisualElementsForRecordAudio(){
        recordButton.enabled = false
        tapToRecordLabel.hidden = true
        pausedLabel.hidden = true
        recordingLabel.hidden = false
        stopButton.hidden = false
        pauseButton.hidden = false
        resumeButton.hidden = false
        resumeButton.enabled = false
    }

    private func setVisualElementsForStopAudio(){
        recordingLabel.hidden = true
        tapToRecordLabel.hidden = false
        pausedLabel.hidden = true
    }

}

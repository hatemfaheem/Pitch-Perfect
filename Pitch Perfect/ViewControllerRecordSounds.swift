//
//  ViewControllerRecordSounds.swift
//  Pitch Perfect
//
//  Created by Hatem Faheem on 11/25/14.
//  Copyright (c) 2014 hatemfaheem. All rights reserved.
//

import UIKit
import AVFoundation

class ViewControllerRecordSounds: UIViewController, AVAudioRecorderDelegate {
    
    // outlets
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    // ===================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.recordingLabel.hidden = true
        self.recordButton.enabled = true
        self.stopButton.hidden = true
    }
    
    // the segue is about to perform (pass data)
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC: ViewControllerPlaySounds = segue.destinationViewController as ViewControllerPlaySounds
            playSoundsVC.receivedAudio = sender as RecordedAudio
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // save audio file
            self.recordedAudio = RecordedAudio()
            self.recordedAudio.filePathUrl = recorder.url
            self.recordedAudio.title = recorder.url.lastPathComponent
            // move to the next scene (perform segue)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    // ===================================

    // actions
    
    @IBAction func recordAuido(sender: UIButton) {
        self.recordingLabel.hidden = false
        self.recordButton.enabled = false
        self.stopButton.hidden = false
        self.startRecorder()
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        self.audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    // ===================================
    
    // support functions
    func startRecorder() {

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        self.audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        self.audioRecorder.delegate = self
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        self.audioRecorder.record()
    }
    
    

}


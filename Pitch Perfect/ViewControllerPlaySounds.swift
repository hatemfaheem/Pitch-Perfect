//
//  ViewControllerPlaySounds.swift
//  Pitch Perfect
//
//  Created by Hatem Faheem on 11/26/14.
//  Copyright (c) 2014 hatemfaheem. All rights reserved.
//

import UIKit
import AVFoundation

class ViewControllerPlaySounds: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    
    var receivedAudio: RecordedAudio!
    var avAudioFile: AVAudioFile!
    
    
    
    // ==========================
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
        if var path = NSBundle.mainBundle().pathForResource("movie_quote", ofType:"mp3") {
            var fileURL = NSURL(fileURLWithPath: path)
        }else{
            println("wrong filepath")
        }
        */
        
        self.audioPlayer = AVAudioPlayer(contentsOfURL: self.receivedAudio.filePathUrl, error: nil)
        self.audioPlayer.enableRate = true
        
        self.audioEngine = AVAudioEngine()
        self.avAudioFile = AVAudioFile(forReading: self.receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ==========================
    
    // actions
    @IBAction func playSlow(sender: UIButton) {
        self.play(0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        self.play(2.0)
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        self.playWithVariablePitch(1000.0)
    }
    
    @IBAction func playDarthvader(sender: UIButton) {
        self.playWithVariablePitch(-1000.0)
    }
    
    @IBAction func stop(sender: UIButton) {
        self.stopAudio()
    }

    // ==========================
    
    // support functions
    
    func play(rate:Float) {
        self.stopAudio()
        self.audioPlayer.currentTime = 0.0
        self.audioPlayer.rate = rate
        self.audioPlayer.play()
    }
    
    func playWithVariablePitch(pitch: Float) {
        
        // stop any playing audios
        self.stopAudio()
        
        // create a player node
        var audioPlayerNode = AVAudioPlayerNode()
        // attach the player node to the engine
        self.audioEngine.attachNode(audioPlayerNode)
        
        // create a pitch effect instance
        var changePitchEffect = AVAudioUnitTimePitch()
        // set the pitch value
        changePitchEffect.pitch = pitch
        // attach the pitch effect instance to the engine
        self.audioEngine.attachNode(changePitchEffect)
        
        // connect the player node to the pitch effect & the pitch to the output
        self.audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        self.audioEngine.connect(changePitchEffect, to: self.audioEngine.outputNode, format: nil)
        
        // schedule the file to be played, start the engine and play the sound
        audioPlayerNode.scheduleFile(self.avAudioFile, atTime: nil, completionHandler: nil)
        self.audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func stopAudio() {
        self.audioPlayer.stop()
        self.audioEngine.stop()
        self.audioEngine.reset()
    }
    
    // ==========================
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

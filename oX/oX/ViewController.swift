//
//  ViewController.swift
//  oX
//
//  Created by Charles Yoon on 6/26/17.
//  Copyright © 2017 Charles Yoon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    var sound: URL?
    
    @IBOutlet var imageView: UIView!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let yConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: view.bounds.height / 4)
        NSLayoutConstraint.activate([yConstraint])
    }
    
    //MARK: Outlets
    @IBOutlet weak var player: UIButton!
    @IBOutlet weak var stop: UIButton!
    
    //MARK: Loaders
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        player?.isEnabled = false;
        stop?.isEnabled = false;
        
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        self.sound = dirPaths[0].appendingPathComponent("sound.caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: sound!,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        //this is for the prepareForSegue
        performSegue(withIdentifier: "stopsRecording", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopsRecording"{
            let vc = segue.destination as! SecondViewController
            //Data has to be a variable name in your RandomViewController
            vc.sound = sound
        }
    }
    
 
    //MARK: Actions
    
    @IBAction func startRecording(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            player?.isEnabled = false
            stop?.isEnabled = true
            audioRecorder?.record()
            }
    }
    @IBAction func stopAndPlay(_ sender: Any) {
        stop?.isEnabled = false
        player?.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }

    }
    
    
}


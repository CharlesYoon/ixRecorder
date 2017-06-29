//
//  SecondViewController.swift
//  oX
//
//  Created by Charles Yoon on 6/28/17.
//  Copyright © 2017 Charles Yoon. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer?
    var engine: AVAudioEngine!
    var file: AVAudioFile!
    var sound: URL?
    
    //MARK:Outlets

    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = AVAudioEngine()
        do {
            file = try AVAudioFile(forReading: sound!)
        }catch let error{
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Functions
    func playSound(value: Float, rateOrPitch: String){
        let audioPlayerNode = AVAudioPlayerNode()
        
        audioPlayer?.stop()
        engine?.stop()
        engine?.reset()
        
        engine.attach(audioPlayerNode)
        
        let changeAudioUnitTime = AVAudioUnitTimePitch()
        
        if (rateOrPitch == "rate") {
            changeAudioUnitTime.rate = value
        } else {
            changeAudioUnitTime.pitch = value
        }
        
        engine.attach(changeAudioUnitTime)
        engine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        engine.connect(changeAudioUnitTime, to: engine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(file, at: nil, completionHandler: nil)
        do{
            try engine?.start()
            guard (engine) != nil else {return}
        }
        catch let error{
            print (error.localizedDescription)
        }
        audioPlayerNode.play()
    }
    
    //MARK:Actions
    
    @IBAction func playButton(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf:
                (sound)!)
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
        }
        
    }
    
    //bunnyButton
    @IBAction func bunnyButton(_ sender: Any) {
        playSound(value: 5, rateOrPitch: "rate")
    }
    
    //turtleButton
    @IBAction func turtleButton(_ sender: Any) {
        playSound(value: 1, rateOrPitch: "rate")    }
    
    //squirrelButton
    @IBAction func squirrelButton(_ sender: Any) {
        playSound(value: 1000, rateOrPitch: "pitch")
    }
    //frankenStein
    @IBAction func frankenStein(_ sender: Any) {
        playSound(value: -1000, rateOrPitch: "pitch")
    }
    //parrot
    @IBAction func parrotButton(_ sender: Any) {
        playSound(value: 500, rateOrPitch: "pitch")
    }
    
    @IBAction func randomSoundMaker(_ sender: Any) {
        playSound(value: 0.5, rateOrPitch: "rate")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

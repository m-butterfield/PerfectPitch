//
//  ViewController.swift
//  PerfectPitch
//
//  Created by Matthew Butterfield on 3/21/15.
//  Copyright (c) 2015 Matthew Butterfield. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var soundGenerator: SoundGenerator

    required init(coder aDecoder: NSCoder) {
        soundGenerator = SoundGenerator()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playNoteOn(b:UIButton) {
        var note:UInt32 = UInt32(b.tag)
        var velocity:UInt32 = 100
        soundGenerator.playNoteOn(note, velocity: velocity)
    }

    @IBAction func playNoteOff(b:UIButton) {
        var note:UInt32 = UInt32(b.tag)
        soundGenerator.playNoteOff(note)
    }

}

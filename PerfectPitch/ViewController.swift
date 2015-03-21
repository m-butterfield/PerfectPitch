//
//  ViewController.swift
//  PerfectPitch
//
//  Created by Matthew Butterfield on 3/21/15.
//  Copyright (c) 2015 Matthew Butterfield. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let minNote = 60
    let maxNote = 72
    let velocity = UInt32(100)
    let randomNoteFlag = UInt32(9999)

    var soundGenerator = SoundGenerator()
    var randomNote: UInt32

    required init(coder aDecoder: NSCoder) {
        randomNote = UInt32(minNote)
        super.init(coder: aDecoder)
    }

    @IBAction func playNoteOn(b:UIButton) {
        var note:UInt32 = UInt32(b.tag)
        if note == randomNoteFlag {
            randomNote = generateRandomNote()
            soundGenerator.playNoteOn(randomNote, velocity: velocity)
        } else {
            soundGenerator.playNoteOn(note, velocity: velocity)
        }
    }

    @IBAction func playNoteOff(b:UIButton) {
        var note:UInt32 = UInt32(b.tag)
        if note == randomNoteFlag {
            soundGenerator.playNoteOff(randomNote)
        } else {
            soundGenerator.playNoteOff(note)
        }
    }

    func generateRandomNote() -> UInt32 {
        return minNote + UInt32(arc4random_uniform(UInt32(maxNote - minNote + 1)))
    }
}

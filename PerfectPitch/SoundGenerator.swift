//
//  SoundGenerator.swift
//  PerfectPitch
//
//  Created by Matthew Butterfield on 3/21/15.
//  Copyright (c) 2015 Matthew Butterfield. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundGenerator: NSObject {
    var processingGraph:AUGraph
    var samplerNode:AUNode
    var ioNode:AUNode
    var samplerUnit:AudioUnit
    var ioUnit:AudioUnit

    override init() {
        processingGraph = AUGraph()
        samplerNode = AUNode()
        ioNode = AUNode()
        samplerUnit  = AudioUnit()
        ioUnit  = AudioUnit()
        super.init()

        augraphSetup()
        graphStart()
    }


    func augraphSetup() {
        NewAUGraph(&processingGraph)

        var cd:AudioComponentDescription = AudioComponentDescription(componentType: OSType(kAudioUnitType_MusicDevice),componentSubType: OSType(kAudioUnitSubType_Sampler),componentManufacturer: OSType(kAudioUnitManufacturer_Apple),componentFlags: 0,componentFlagsMask: 0)
        AUGraphAddNode(self.processingGraph, &cd, &samplerNode)

        var ioUnitDescription:AudioComponentDescription = AudioComponentDescription(
            componentType: OSType(kAudioUnitType_Output),
            componentSubType: OSType(kAudioUnitSubType_RemoteIO),
            componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
            componentFlags: 0,
            componentFlagsMask: 0)
        AUGraphAddNode(processingGraph, &ioUnitDescription, &ioNode)

        AUGraphOpen(self.processingGraph)
        AUGraphNodeInfo(self.processingGraph, self.samplerNode, nil, &samplerUnit)
        AUGraphNodeInfo(self.processingGraph, self.ioNode, nil, &ioUnit)

        var ioUnitOutputElement:AudioUnitElement = 0
        var samplerOutputElement:AudioUnitElement = 0
        AUGraphConnectNodeInput(self.processingGraph,
            self.samplerNode, samplerOutputElement,
            self.ioNode, ioUnitOutputElement)
    }

    func graphStart() {
        var outIsInitialized:Boolean = 0
        AUGraphIsInitialized(self.processingGraph, &outIsInitialized)
        if outIsInitialized == 0 {
            AUGraphInitialize(self.processingGraph)
        }

        var isRunning:Boolean = 0
        AUGraphIsRunning(self.processingGraph, &isRunning)
        if isRunning == 0 {
            AUGraphStart(self.processingGraph)
        }
    }

    func playNoteOn(noteNum:UInt32, velocity:UInt32)    {
        var noteCommand:UInt32 = 0x90 | 0;
        MusicDeviceMIDIEvent(self.samplerUnit, noteCommand, noteNum, velocity, 0)
    }

    func playNoteOff(noteNum:UInt32)    {
        var noteCommand:UInt32 = 0x80 | 0;
        MusicDeviceMIDIEvent(self.samplerUnit, noteCommand, noteNum, 0, 0)
    }
}

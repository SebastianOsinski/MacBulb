//
//  ViewController.swift
//  MacBulb
//
//  Created by Sebastian Osiński on 10/04/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    private let bulbView = BulbView()
    private let bulbState = BulbState()

    private var bulbServer: BulbServer!

    override func viewDidLoad() {
        super.viewDidLoad()

        bulbServer = BulbServer(bulbState: bulbState)
        bulbServer.start()
        
        bulbState.stateUpdated = { [weak self] in
            self?.updateDisplay()
        }
        
        updateDisplay()
        
        view.addSubview(bulbView)
        bulbView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bulbView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bulbView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.layer?.backgroundColor = NSColor.darkGray.cgColor
    }
    
    private func updateDisplay() {
        bulbView.layer?.backgroundColor = bulbState.isOn ? bulbState.color.cgColor : NSColor.black.cgColor
//        setBrightnessLevel(bulbState.isOn ? bulbState.brightness / 100.0 : 0.0)
    }
    
    private func setBrightnessLevel(_ level: Float) {
        var iterator: io_iterator_t = 0
        
        if IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &iterator) == kIOReturnSuccess {
            var service: io_object_t = 1
            
            while service != 0 {
                service = IOIteratorNext(iterator)
                IODisplaySetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, level)
                IOObjectRelease(service)
            }
        }
    }
}


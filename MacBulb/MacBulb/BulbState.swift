//
//  BulbState.swift
//  MacBulb
//
//  Created by Sebastian Osiński on 10/04/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import AppKit

final class BulbState {
    var stateUpdated: (() -> ())?
    
    var hue: Float {
        return Float(color.hueComponent * 360.0)
    }
    
    var saturation: Float {
        return Float(color.saturationComponent * 100.0)
    }
    
    var brightness: Float {
        return Float(color.brightnessComponent * 100.0)
    }
    
    private(set) var isOn = true
    private(set) var color = NSColor(deviceHue: 1.0, saturation: 0.0, brightness: 0.5, alpha: 1.0)
    
    func update(isOn: Bool) {
        self.isOn = isOn
        
        stateUpdated?()
    }
    
    func update(hue: Float) {
        color = color.with(hue: CGFloat(hue / 360.0))
        
        stateUpdated?()
    }
    
    func update(saturation: Float) {
        color = color.with(saturation: CGFloat(saturation / 100.0))
        
        stateUpdated?()
    }
    
    func update(brightness: Float) {
        color = color.with(brightness: CGFloat(brightness / 100.0))
    
        stateUpdated?()
    }
}


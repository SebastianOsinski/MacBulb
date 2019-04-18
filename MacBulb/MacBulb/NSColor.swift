//
//  NSColor.swift
//  MacBulb
//
//  Created by Sebastian Osiński on 10/04/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import AppKit

extension NSColor {
    func with(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil) -> NSColor {
        return NSColor(
            hue: hue ?? hueComponent,
            saturation: saturation ?? saturationComponent,
            brightness: brightness ?? brightnessComponent,
            alpha: alphaComponent
        )
    }
}

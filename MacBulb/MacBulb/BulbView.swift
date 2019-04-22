//
//  BulbView.swift
//  MacBulb
//
//  Created by Sebastian Osiński on 18/04/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import Cocoa

final class BulbView: NSView {
    private let maskLayer = CALayer()
    
    private let threadLayer = CALayer()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        wantsLayer = true
        
        let maskImage = NSImage(named: NSImage.Name("bulb"))!
        
        maskLayer.contents = maskImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
        maskLayer.backgroundColor = NSColor.clear.cgColor
        layer?.mask = maskLayer
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let width: CGFloat = 300.0
        let height = width / maskImage.size.width * maskImage.size.height
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
        
        threadLayer.backgroundColor = NSColor.brown.cgColor
        layer?.addSublayer(threadLayer)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()

        maskLayer.frame = bounds
        threadLayer.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height * 0.24)
    }
}

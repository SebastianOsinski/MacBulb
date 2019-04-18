//
//  BulbServer.swift
//  MacBulb
//
//  Created by Sebastian Osiński on 10/04/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import Swifter

final class BulbServer {
    private let bulbState: BulbState
    private let httpServer = HttpServer()
    
    init(bulbState: BulbState) {
        self.bulbState = bulbState
    }
    
    func start() {
        httpServer.GET["power"] = { [bulbState] _ in
            return .ok(.json(["on": bulbState.isOn] as NSDictionary))
        }
        
        httpServer.GET["hue"] = { [bulbState] _ in
            return .ok(.json(["value": bulbState.hue] as NSDictionary))
        }
        
        httpServer.GET["saturation"] = { [bulbState] _ in
            return .ok(.json(["value": bulbState.saturation] as NSDictionary))
        }
        
        httpServer.GET["brightness"] = { [bulbState] _ in
            return .ok(.json(["value": bulbState.brightness] as NSDictionary))
        }
        
        httpServer.PUT["power"] = { [bulbState] request in
            guard let isOn = request.formValue(forKey: "on") else {
                return .badRequest(nil)
            }
            
            DispatchQueue.main.async { bulbState.update(isOn: isOn == "true") }
            
            return .accepted
        }
        
        httpServer.PUT["hue"] = { [bulbState] request in
            guard let value = request.formValue(forKey: "value"), let hue = Float(value) else {
                return .badRequest(nil)
            }
            
            DispatchQueue.main.async { bulbState.update(hue: hue) }
            
            return .accepted
        }
        
        httpServer.PUT["saturation"] = { [bulbState] request in
            guard let value = request.formValue(forKey: "value"), let saturation = Float(value) else {
                return .badRequest(nil)
            }
            
            DispatchQueue.main.async { bulbState.update(saturation: saturation) }
            
            return .accepted
        }
        
        httpServer.PUT["brightness"] = { [bulbState] request in
            guard let value = request.formValue(forKey: "value"), let brightness = Float(value) else {
                return .badRequest(nil)
            }
            
            DispatchQueue.main.async { bulbState.update(brightness: brightness) }
            
            return .accepted
        }
        
        try! httpServer.start(1234)
    }
    
    
}

extension HttpRequest {
    func formValue(forKey key: String) -> String? {
        return parseUrlencodedForm().first { $0.0 == key }?.1
    }
}

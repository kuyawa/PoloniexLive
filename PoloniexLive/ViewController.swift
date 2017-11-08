//
//  ViewController.swift
//  PoloniexLive
//
//  Created by Laptop on 11/8/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var output: NSTextView!
    
    override func viewDidLoad() {
        print("Start")
        super.viewDidLoad()
        output.font = NSFont(name: "Monaco", size: 14.0)
        
        // We can run multiple channels at once and update multiple view controls
        // But for testing purposes we will subscribe to one to see the live stream
        testTicker()
        //testTrollbox()
        //testTrading()
        //testVolume()
    }

    func log(_ message: String) {
        DispatchQueue.main.async {
            self.output.string = message + (self.output.string ?? "")
        }
    }
    
    func testTicker() {
        Poloniex.Live.Subscribe(channel: .ticker, delegate: onTicker)
    }
    
    func testTrollbox() {
        Poloniex.Live.Subscribe(channel: .trollbox, delegate: onTrolling)
    }
    
    func testTrading() {
        Poloniex.Live.Subscribe(channel: .trading, currencyPair: "BTC_XMR", delegate: onTrading)
    }
    
    func testVolume() {
        Poloniex.Live.Subscribe(channel: .volume, delegate: onVolume)
    }
    
    func onTicker(message: String) {
        // Update stuff
        print("Ticker")
        log(message)
    }

    func onTrolling(message: String) {
        // Update stuff
        print("Trolling")
        log(message)
    }
    
    func onTrading(message: String) {
        // Update stuff
        print("Trading")
        log(message)
    }
    
    func onVolume(message: String) {
        // Update stuff
        print("Volume")
        log(message)
    }
    
}


// END

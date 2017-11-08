//
//  PoloniexPushAPI.swift
//  PoloniexLive
//
//  Created by Laptop on 11/8/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation


/*
 
 USE:
   Poloniex.Live.Subscribe(channel: .trollbox, delegate: onTrolling)
   Poloniex.Live.Subscribe(channel: .ticker,   delegate: onTicker)
   Poloniex.Live.Subscribe(channel: .trading,  currencyPair: "BTC_LTC", delegate: onTrading)
   Poloniex.Live.Unsubscribe(channel: .ticker)
   Poloniex.Live.Unsubscribe(channel: .trading,  currencyPair: "BTC_LTC")

 Poloniex Channels: 
 - 1001 trollbox
 - 1002 ticker
 - 1003 24hVol
 - XXX_YYY orderbook
 - Each channel must have a messaging delegate
 
*/


class Poloniex {
    
    typealias Delegate = (String) -> ()
    
    enum ChannelType { case trollbox, ticker, volume, trading }

    class Messages {
        static func trollbox() -> String { return "{\"command\": \"subscribe\", \"channel\": 1001}" }
        static func ticker()   -> String { return "{\"command\": \"subscribe\", \"channel\": 1002}" }
        static func volume()   -> String { return "{\"command\": \"subscribe\", \"channel\": 1003}" }
        static func trading(_ id: String)     -> String { return "{\"command\": \"subscribe\", \"channel\": \"\(id)\"}" }
        static func unsubscribe(_ id: String) -> String { return "{\"command\": \"unsubscribe\", \"channel\": \"\(id)\"}" }
    }
    
    static var currencyChannels: [String:String] = [
        "BTC_BCN"  :   "7",
        "BTC_BELA" :   "8",
        "BTC_BLK"  :  "10",
        "BTC_BTCD" :  "12",
        "BTC_BTM"  :  "13",
        "BTC_BTS"  :  "14",
        "BTC_BURST":  "15",
        "BTC_CLAM" :  "20",
        "BTC_DASH" :  "24",
        "BTC_DGB"  :  "25",
        "BTC_DOGE" :  "27",
        "BTC_EMC2" :  "28",
        "BTC_FLDC" :  "31",
        "BTC_FLO"  :  "32",
        "BTC_GAME" :  "38",
        "BTC_GRC"  :  "40",
        "BTC_HUC"  :  "43",
        "BTC_LTC"  :  "50",
        "BTC_MAID" :  "51",
        "BTC_OMNI" :  "58",
        "BTC_NAUT" :  "60",
        "BTC_NAV"  :  "61",
        "BTC_NEOS" :  "63",
        "BTC_NMC"  :  "64",
        "BTC_NOTE" :  "66",
        "BTC_NXT"  :  "69",
        "BTC_PINK" :  "73",
        "BTC_POT"  :  "74",
        "BTC_PPC"  :  "75",
        "BTC_RIC"  :  "83",
        "BTC_SJCX" :  "86",
        "BTC_STR"  :  "89",
        "BTC_SYS"  :  "92",
        "BTC_VIA"  :  "97",
        "BTC_XVC"  :  "98",
        "BTC_VRC"  :  "99",
        "BTC_VTC"  : "100",
        "BTC_XBC"  : "104",
        "BTC_XCP"  : "108",
        "BTC_XEM"  : "112",
        "BTC_XMR"  : "114",
        "BTC_XPM"  : "116",
        "BTC_XRP"  : "117",
        "USDT_BTC" : "121",
        "USDT_DASH": "122",
        "USDT_LTC" : "123",
        "USDT_NXT" : "124",
        "USDT_STR" : "125",
        "USDT_XMR" : "126",
        "USDT_XRP" : "127",
        "XMR_BCN"  : "129",
        "XMR_BLK"  : "130",
        "XMR_BTCD" : "131",
        "XMR_DASH" : "132",
        "XMR_LTC"  : "137",
        "XMR_MAID" : "138",
        "XMR_NXT"  : "140",
        "BTC_ETH"  : "148",
        "USDT_ETH" : "149",
        "BTC_SC"   : "150",
        "BTC_BCY"  : "151",
        "BTC_EXP"  : "153",
        "BTC_FCT"  : "155",
        "BTC_RADS" : "158",
        "BTC_AMP"  : "160",
        "BTC_DCR"  : "162",
        "BTC_LSK"  : "163",
        "ETH_LSK"  : "166",
        "BTC_LBC"  : "167",
        "BTC_STEEM": "168",
        "ETH_STEEM": "169",
        "BTC_SBD"  : "170",
        "BTC_ETC"  : "171",
        "ETH_ETC"  : "172",
        "USDT_ETC" : "173",
        "BTC_REP"  : "174",
        "USDT_REP" : "175",
        "ETH_REP"  : "176",
        "BTC_ARDR" : "177",
        "BTC_ZEC"  : "178",
        "ETH_ZEC"  : "179",
        "USDT_ZEC" : "180",
        "XMR_ZEC"  : "181",
        "BTC_STRAT": "182",
        "BTC_NXC"  : "183",
        "BTC_PASC" : "184",
        "BTC_GNT"  : "185",
        "ETH_GNT"  : "186",
        "BTC_GNO"  : "187",
        "ETH_GNO"  : "188",
        "BTC_BCH"  : "189",
        "ETH_BCH"  : "190",
        "USDT_BCH" : "191",
        "BTC_ZRX"  : "192",
        "ETH_ZRX"  : "193",
        "BTC_CVC"  : "194",
        "ETH_CVC"  : "195",
        "BTC_OMG"  : "196",
        "ETH_OMG"  : "197",
        "BTC_GAS"  : "198",
        "ETH_GAS"  : "199",
        "BTC_STORJ": "200"
    ]

    static var Live = LiveAPI()
    
    class LiveAPI {
        let uri = "wss://api2.poloniex.com"
        let webSocket: WebSocket?
        var channels = [String: Delegate]()
        
        init() {
            webSocket = WebSocket(uri)

            webSocket?.event.open = {
                print("WS opened")
                //self.webSocket?.send(Messages.hello)
            }
            
            webSocket?.event.close = { code, reason, clean in
                print("WS closed", code, reason)
            }
            
            webSocket?.event.error = { error in
                print("WS error \(error)")
            }
            
            // This method will be replaced by a custom delegate
            webSocket?.event.message = { message in
                if let text = message as? String {
                    print("--> \(text)")
                    
                    // Route to appropriate delegate when multiple channels open
                    // Heartbeats [1010] will be ignored
                    if let channelId = self.getChannelId(text) {
                        if let channel = self.channels[channelId] { channel(text) }
                        else { print("No channel available") }
                    }
                    
                    if text == "quit" {
                        self.webSocket?.close()
                    }
                } else {
                    print("--? \(message)")
                }
            }
        }
        
        deinit {
            // Unsubscribe?
        }
        
        func Subscribe(channel: ChannelType, currencyPair: String? = "BTC_LTC", delegate: @escaping Delegate) {
            print("Subscribing to \(channel)")
            var message = ""
            
            var channelId = "9999" // Unknown channel to capture rogue messages
            if let pairId = currencyChannels[currencyPair!] {
                channelId = pairId
            } else {
                // Can not subscribe to unknown channel
            }
            
            switch channel {
            case .trollbox : message = Messages.trollbox(); channels["1001"] = delegate; break
            case .ticker   : message = Messages.ticker();   channels["1002"] = delegate; break
            case .volume   : message = Messages.volume();   channels["1003"] = delegate; break
            case .trading  : message = Messages.trading(currencyPair!); channels[channelId] = delegate; break
            }
            
            webSocket?.send(message)
        }
        
        func Unsubscribe(channel: ChannelType, currencyPair: String? = "BTC_LTC") {
            print("Unsubscribing to \(channel)")
            var channelId = ""

            if let pairId = currencyChannels[currencyPair!] {
                channelId = pairId
            } else {
                return
            }
            
            switch channel {
            case .trollbox : channelId = "1001"; break
            case .ticker   : channelId = "1002"; break
            case .volume   : channelId = "1003"; break
            case .trading  : /* already found */ break
            }

            let message = Messages.unsubscribe(channelId)
            webSocket?.send(message)
        }
        
        private func getChannelId(_ text: String) -> String? {
            var id: String? = nil
            
            let ini = text.index(text.startIndex, offsetBy: 1)
            if let end = text.characters.index(of: ",") {
                id = text.substring(with: ini..<end)
            } else if let end = text.characters.index(of: "]") {
                id = text.substring(with: ini..<end)
            }
            print("ID: ", id ?? "nil")
            return id
        }
    }
}

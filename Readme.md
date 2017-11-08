# POLONIEX LIVE

PoloniexLive is a wrapper for Push API calls offered by Poloniex to access market data in real time using websockets. It can access public streams like Trollbox, Ticker, Trading and Volume.

Link to Poloniex API: [https://poloniex.com/support/api/](https://poloniex.com/support/api/)

## How to use it? 

As simple as this:

    Poloniex.Live.subscribe(channel: .ticker, delegate: onTicker)

Then parse the response as json and populate your controls with that info in real time (batteries not included).

## Required

Just drop PoloniexPushAPI.swift and WebSocket.swift files in your project and call Poloniex methods from your view controllers. Remember to include Libz.tbd in the Libraries and Frameworks section of your project.

See, the good thing is that this doesn't need special and complex libraries like Docker, Crossbar, WAMP, or Starscream, just a couple of files and ready to go.

Version 2 will use Structs for all responses instead of text

## Tools

Developed with Xcode 8.3 and Swift 3.1

## Dependencies

PoloniexLive uses the magical library by Tidwall "SwiftWebsocket" and Libz.tbd which must be included in the project.

[https://github.com/tidwall/SwiftWebSocket](https://github.com/tidwall/SwiftWebSocket)

Hey Tidwall, you're a genius!

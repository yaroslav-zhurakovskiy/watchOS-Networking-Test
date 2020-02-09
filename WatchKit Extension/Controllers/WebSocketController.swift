//
//  Created by Yaroslav Zhurakovskiy on 08.02.2020.
//  Copyright © 2020 Turnpikegroup. All rights reserved.
//

import WatchKit

class WebSocketTestController: WKInterfaceController {
    @IBOutlet weak var connectButton: WKInterfaceButton!
    @IBOutlet weak var pingButton: WKInterfaceButton!
    @IBOutlet weak var closeButton: WKInterfaceButton!
    @IBOutlet weak var logLabel: WKInterfaceLabel!
    
    private let connection: WebSocketConnection
    private var logIndex: Int
    private var log: String
    
    override init() {
        connection = WebSocketConnection(url: URL(string: "wss://websocketstest.com/service")!)
        logIndex = 0
        log = ""
        
        super.init()
        
        showConnectButton()
        connection.delegate = self
    }
    
    @IBAction func connect() {
        resetLog()
        connection.connect()
    }
    
    @IBAction func disconenct() {
        connection.disconnect()
    }
    
    @IBAction func ping() {
        connection.send(text: "ping")
    }
}

extension WebSocketTestController: WebSocketConnectionDelegate {
    func connectionWasEstablished(_ connection: WebSocketConnection) {
        hideConnectButton()
        
        writeLog("Connected")
    }
    
    func connection(_ connection: WebSocketConnection, didDisconnectWithReason error: Error?) {
        showConnectButton()
        
        if let error = error {
            writeLog("Disconnected with error: \(error)")
        } else {
            writeLog("Disconnected normally")
        }
    }
    
    func connection(_ connection: WebSocketConnection, didFail error: Error) {
        writeLog("Connection error: \(error)")
    }
    
    func connection(_ connection: WebSocketConnection, didReceiveText text: String) {
        writeLog("Received: \(text)")
    }
    
    func connection(_ connection: WebSocketConnection, didReceiveData data: Data) {
        writeLog("Received: \(data.count) bytes")
    }
}

private extension WebSocketTestController {
    func writeLog(_ text: String) {
        let logEntry = "Log #\(logIndex):\n\(text)\n -------------- \n"
        log += logEntry
        
        print(text)
        logLabel.setText(log)
        logIndex += 1
    }
    
    func resetLog() {
        log = ""
        logIndex = 0
        logLabel.setText(log)
    }
    
    func showConnectButton() {
        connectButton.setHidden(false)
        pingButton.setHidden(true)
        closeButton.setHidden(true)
    }
    
    func hideConnectButton() {
        connectButton.setHidden(true)
        pingButton.setHidden(false)
        closeButton.setHidden(false)
    }
}

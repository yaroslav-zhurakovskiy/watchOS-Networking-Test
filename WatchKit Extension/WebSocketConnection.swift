//
//  Created by zen on 6/17/19.
//  Copyright © 2020 Turnpikegroup. All rights reserved.
//

import Foundation

protocol WebSocketConnectionDelegate: class {
    func connectionWasEstablished(_ connection: WebSocketConnection)
    func connection(_ connection: WebSocketConnection, didDisconnectWithReason: Error?)
    func connection(_ connection: WebSocketConnection, didFail: Error)
    func connection(_ connection: WebSocketConnection, didReceiveText: String)
    func connection(_ connection: WebSocketConnection, didReceiveData: Data)
}

class WebSocketConnection: NSObject, URLSessionWebSocketDelegate {
    weak var delegate: WebSocketConnectionDelegate?
    var webSocketTask: URLSessionWebSocketTask?
    var urlSession: URLSession!
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        
        super.init()
        
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.delegate?.connectionWasEstablished(self)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.delegate?.connection(self, didDisconnectWithReason: nil)
    }
    
    func connect() {
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        self.receive()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    func receive()  {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.delegate?.connection(self, didFail: error)
            case .success(let message):
                switch message {
                case .string(let text):
                    self.delegate?.connection(self, didReceiveText: text)
                case .data(let data):
                    self.delegate?.connection(self, didReceiveData: data)
                @unknown default:
                    fatalError()
                }
                self.receive()
            }
        }
    }
    
    func send(text: String) {
        webSocketTask?.send(.string(text)) { error in
            if let error = error {
                self.delegate?.connection(self, didFail: error)
            }
        }
    }
    
    func send(data: Data) {
        webSocketTask?.send(.data(data)) { error in
            if let error = error {
                self.delegate?.connection(self, didFail: error)
            }
        }
    }
}

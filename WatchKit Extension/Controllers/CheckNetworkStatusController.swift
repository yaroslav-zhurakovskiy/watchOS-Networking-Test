//
//  InterfaceController.swift
//  Generic WatchKit Extension
//
//  Created by Sasha Milic on 2020-02-08.
//  Copyright © 2020 Turnpikegroup. All rights reserved.
//

import WatchKit
import Foundation
import Network

class CheckNetworkStatusController: WKInterfaceController {
    let monitor = NWPathMonitor()

    @IBOutlet weak var networkSatusLabel: WKInterfaceLabel!

    override init() {
        super.init()
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.networkSatusLabel.setText("\(path)")
        }
        monitor.start(queue: .global())
    }
}

//
//  HttpTestController.swift
//  Generic WatchKit Extension
//
//  Created by Yaroslav Zhurakovskiy on 08.02.2020.
//  Copyright © 2020 Turnpikegroup. All rights reserved.
//

import WatchKit

class HTTPTestController: WKInterfaceController {
    let session = URLSession(configuration: .default)
    
    @IBOutlet weak var infoLabel: WKInterfaceLabel!
    
    override func didAppear() {
        infoLabel.setText("Loading...")
        let task = session.dataTask(with: URL(string: "https://google.com?q=apple")!, completionHandler: { [weak self] data, resopse, error in
            if let data = data {
                self?.infoLabel.setText("Got \(data.count) bytes")
            } else if let error = error {
                self?.infoLabel.setText("Got \(error)")
            }
        })
        task.resume()
    }
}

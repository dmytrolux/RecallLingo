//
//  NetworkMonitor.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 30.05.2023.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected = false
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        
        monitor.start(queue: queue)
    }
}

//
//  NetworkReachabilityManager.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 17.08.2023.
//

import Reachability
import Foundation

struct InternetConnection {
    let connection: Reachability.Connection
    let internetAvailable: Bool
}

final class NetworkReachabilityManager {
    
    static var shared = NetworkReachabilityManager()
    let networkReachabilityManagerNotification = Notification.Name("NetworkReachabilityManagerNotification")

    private let notificationCenter = NotificationCenter.default
    private var reachability = try? Reachability()
    
    var internetAvailable: Bool {
        reachability?.connection == .wifi || reachability?.connection == .cellular
    }
    
    private init() {}

    func initialize() {
        subscribe()
        startNotifier()
    }
}

// MARK: Private extension

private extension NetworkReachabilityManager {
    
    @objc func networkStatusChanged(_ notification: Notification) {
        let notificationData = ["connectionAvailable": internetAvailable]
        notificationCenter.post(name: networkReachabilityManagerNotification,
                                object: nil,
                                userInfo: notificationData)
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkStatusChanged(_:)),
                                               name: .reachabilityChanged,
                                               object: reachability
        )
    }
    
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
}

extension NetworkReachabilityManager {
    
    func stopNotifier() {
        reachability?.stopNotifier()
    }
    
}

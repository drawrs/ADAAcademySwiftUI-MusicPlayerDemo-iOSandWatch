//
//  SongModel.swift
//  ADAAcademySwiftUI
//
//  Created by Local Administrator on 02/08/21.
//

import SwiftUI
import WatchConnectivity

class SongModel: NSObject, ObservableObject, WCSessionDelegate {
    
    @Published var playlist = [Song]()
    @Published var titleSongPlayed: String = ""
    @Published var isPlayingSomething: Bool = false
    @Published var userName : String = ""
    
    var watchConnectivitySession: WCSession
    
    init(session: WCSession = .default){
        self.watchConnectivitySession = session
        super.init()
        
        self.watchConnectivitySession.delegate = self
        self.playlist = [
            Song(singer: "U2", title: "Elevation"),
            Song(singer: "Ciara", title: "Level up"),
            Song(singer: "Taftaf", title: "Senja di malam WWDC"),
        ]
        
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.isPlayingSomething = message["isPlaying"] as! Bool
            self.titleSongPlayed = message["songPlayedTitle"] as! String
            print("ada yang masuk \(self.isPlayingSomething)")
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ watchConnectivitySession: WCSession) { }
    func sessionDidDeactivate(_ watchConnectivitySession: WCSession) {
        watchConnectivitySession.activate()
    }
    #endif
}

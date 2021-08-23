//
//  SongModel.swift
//  ADAAcademySwiftUI
//
//  Created by Local Administrator on 02/08/21.
//

import SwiftUI
import WatchConnectivity

public class SongModel: NSObject, ObservableObject, WCSessionDelegate {
    
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
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.isPlayingSomething = message["isPlaying"] as! Bool
            print("ada yang masuk \(self.isPlayingSomething)")
        }
    }
    
    #if os(iOS)
    public func sessionDidBecomeInactive(_ watchConnectivitySession: WCSession) { }
    public func sessionDidDeactivate(_ watchConnectivitySession: WCSession) {
        watchConnectivitySession.activate()
    }
    #endif
}

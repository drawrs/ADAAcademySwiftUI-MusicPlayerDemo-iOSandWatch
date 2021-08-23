//
//  ContentView.swift
//  SwiftUITutorial
//
//  Created by Agatha Rachmat on 07/07/21.
//

import SwiftUI
import WidgetKit
import WatchConnectivity

struct ContentView: View {
    
    @StateObject var songModel = SongModel()
    @AppStorage("song", store: UserDefaults(suiteName: "group.sepotipaiUD")) var songData : Data = Data()
    
    var body: some View {
        NavigationView(){
            VStack{
                HStack{
                    Button(action: {
                        songModel.isPlayingSomething.toggle()
                        if self.songModel.watchConnectivitySession.isReachable {
                           print("reachable")
                        } else {
                            print("not reachable")
                        }
                        // MARK: Send signal to watch
                        self.songModel.watchConnectivitySession.sendMessage(["isPlaying": songModel.isPlayingSomething,
                                                                             "songPlayedTitle": songModel.titleSongPlayed],
                                                                            replyHandler: nil) { error in
                            print("Gagal kirim \(error)")
                        }
                        
                    }, label: {
                        if songModel.isPlayingSomething{
                            Image(systemName: "pause.circle.fill").font(.system(size: 56)).foregroundColor(.blue)
                        }else{
                            Image(systemName: "play.circle.fill").font(.system(size: 56)).foregroundColor(.green)
                        }
                        
                        
                    })
                    Text(songModel.titleSongPlayed)
                }.frame(width: 350, height: 100, alignment: .leading)
                TextField("Siapa namamu?", text: $songModel.userName).padding()
                List(songModel.playlist){ i in
                    SongCellCustom(song: i, titleSongPlayed: $songModel.titleSongPlayed, isPlayingSomething: $songModel.isPlayingSomething)
                }
            }.navigationBarTitle(Text(songModel.userName)).foregroundColor(.gray)
        }.onAppear{
            guard let lastPlay = try? JSONDecoder().decode(Song.self, from: songData)else{return}
            
            songModel.titleSongPlayed = lastPlay.singer + " - " + lastPlay.title
        }
    }
}

struct SongCellCustom : View {
    let song : Song
    
    @Binding var titleSongPlayed : String
    @Binding var isPlayingSomething : Bool
    @AppStorage("song", store: UserDefaults(suiteName: "group.sepotipaiUD")) var songData : Data = Data()
    
    var body: some View{
        Button {
            titleSongPlayed = song.singer + " - " + song.title
            isPlayingSomething = true
            saveLastPlay()
        } label: {
            HStack{
                Text(song.singer + " - " + song.title)
                Spacer()
                Image(systemName: "play.circle.fill").font(.system(size: 30)).foregroundColor(.green)
            }
        }
    }
    
    func saveLastPlay(){
        guard let lastPlay = try? JSONEncoder().encode(song) else {return}
        
        songData = lastPlay
        print("sudah tersimpan")
        
        WidgetCenter.shared.reloadTimelines(ofKind: "SepotipaiWidget")
    }
}


//class ViewModelPhone: NSObject, WCSessionDelegate {
//
//    var session: WCSession
//    init(session: WCSession = .default){
//        self.session = session
//        super.init()
//        self.session.delegate = self
//        session.activate()
//    }
//
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//
//    }
//    func sessionDidBecomeInactive(_ session: WCSession) {
//
//    }
//
//    func sessionDidDeactivate(_ session: WCSession) {
//
//    }
//}

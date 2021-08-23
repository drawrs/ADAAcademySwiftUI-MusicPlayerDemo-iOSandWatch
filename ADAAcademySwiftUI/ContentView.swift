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
                    SongCellCustom(songModel: songModel, song: i)
                }
            }.navigationBarTitle(Text(songModel.userName)).foregroundColor(.gray)
        }.onAppear{
            guard let lastPlay = try? JSONDecoder().decode(Song.self, from: songData)else{return}
            
            songModel.titleSongPlayed = lastPlay.singer + " - " + lastPlay.title
        }
    }
}

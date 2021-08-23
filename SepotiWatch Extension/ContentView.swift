//
//  ContentView.swift
//  SepotiWatch Extension
//
//  Created by Rizal Hilman on 21/08/21.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    
    @StateObject var songModel = SongModel()
    
    var body: some View {
        TabView {
            // MARK: 1st page
            VStack {
                Text(songModel.titleSongPlayed.isEmpty ? "\(songModel.playlist.first!.singer) - \(songModel.playlist.first!.title)" : songModel.titleSongPlayed)
                Button(action: {
                    if songModel.isPlayingSomething {
                        songModel.isPlayingSomething = false
                    } else {
                        songModel.isPlayingSomething = true
                    }
                }, label: {
                    if songModel.isPlayingSomething {
                        Image(systemName: "pause.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50, alignment: .center)
                            .foregroundColor(.gray)
                    } else {
                        Image(systemName: "play.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50, alignment: .center)

                    }
                })
            }
            
            // MARK: 2nd page
            List(songModel.playlist){ song in
                SongCellCustom(song: song,
                               songModel: songModel)
            }
            
            Text("Third")
        }
        .tabViewStyle(PageTabViewStyle())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SongCellCustom : View {
    
    let song: Song
    var songModel: SongModel
    
    @AppStorage("song", store: UserDefaults(suiteName: "group.sepotipaiUD")) var songData : Data = Data()
    
    var body: some View{
        Button {
            if songModel.titleSongPlayed == "\(song.singer) - \(song.title)" {
                songModel.isPlayingSomething.toggle()
            } else {
                songModel.isPlayingSomething = true
            }
            
            songModel.titleSongPlayed = "\(song.singer) - \(song.title)"
            saveLastPlay()
            sendSignalToiPhone()
            print("yang diputar \(songModel.titleSongPlayed) yang dimana \(song.title)")
        } label: {
            HStack{
                Text(song.singer + " - " + song.title)
                Spacer()
                
                Image(systemName: (songModel.titleSongPlayed == "\(song.singer) - \(song.title)" && songModel.isPlayingSomething) ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
            }
        }
    }
    
    func saveLastPlay(){
        guard let lastPlay = try? JSONEncoder().encode(song) else {return}
        
        songData = lastPlay
        print("sudah tersimpan")
    }
    
    func sendSignalToiPhone() {
        // MARK: Send signal to watch
        self.songModel.watchConnectivitySession.sendMessage(["isPlaying": songModel.isPlayingSomething,
                                                             "songPlayedTitle": songModel.titleSongPlayed],
                                                            replyHandler: nil) { error in
            print("Gagal kirim \(error)")
        }
    }
}

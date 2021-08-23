//
//  File.swift
//  ADAAcademySwiftUI
//
//  Created by Rizal Hilman on 23/08/21.
//

import Foundation
import SwiftUI
import WatchConnectivity

struct SongCellCustom : View {
    
    @ObservedObject var songModel: SongModel
    let song: Song

    var body: some View{
        Button {
            if songModel.titleSongPlayed == "\(song.singer) - \(song.title)" {
                songModel.isPlayingSomething.toggle()
            } else {
                songModel.isPlayingSomething = true
            }
            
            songModel.titleSongPlayed = "\(song.singer) - \(song.title)"
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
    
    func sendSignalToiPhone() {
        // MARK: Send signal to watch
        self.songModel.watchConnectivitySession.sendMessage(["isPlaying": songModel.isPlayingSomething,
                                                             "songPlayedTitle": songModel.titleSongPlayed],
                                                            replyHandler: nil) { error in
            print("Gagal kirim \(error)")
        }
    }
}

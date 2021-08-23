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
                SongCellCustom(songModel: songModel, song: song)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


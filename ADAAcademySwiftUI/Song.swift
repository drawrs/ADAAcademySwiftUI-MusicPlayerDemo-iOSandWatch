//
//  Song.swift
//  ADAAcademySwiftUI
//
//  Created by Rizal Hilman on 21/08/21.
//

import Foundation

public struct Song: Identifiable, Encodable, Decodable{
    public var id = UUID()
    var singer: String
    var title: String
}

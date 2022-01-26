//
//  MeetingInfo.swift
//  TheMidway
//
//  Created by Gui Reis on 15/12/21.
//

struct MeetingInfo: Decodable {
    let address: String?
    let city: String?
    let country: String?
    let date: String
    let district: String?
    let hour: String
    let latitude: Float
    let longitude: Float
    let name: String
    let number: String?
    let type: String
}

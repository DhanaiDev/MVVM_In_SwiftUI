//
//  PublicAPIModel.swift
//  MVVM
//
//  Created by dhanasekaran on 29/09/21.
//

import Foundation

struct PublicAPIModel: Codable, Identifiable
{
    let id = UUID()
    let API: String
    let Description: String
    let Auth: String
    let HTTPS: Bool
    let Cors: String
    let Link: String
    let Category: String
}

struct PublicAPIList: Codable {
    let count: Int
    let entries: [PublicAPIModel]
}

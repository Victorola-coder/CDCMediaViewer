//
//  CDCResource.swift
//  CDCMediaViewer
//
//  Created by VickyJay on 07/11/2024.
//


struct CDCResource: Codable {
    let id: String
    let name: String
    let url: String
    let contentUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case contentUrl = "contentUrl"
    }
}
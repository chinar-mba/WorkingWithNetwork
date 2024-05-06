//
//  TokenResponse.swift
//  WorkingWithNetwork
//
//  Created by Chinar on 20/2/24.
//

import Foundation

struct TokenResponse: Decodable {
    let access: String
    let refresh: String
    
    enum CodingKeys: String, CodingKey {
        case access = "access_token"
        case refresh = "refresh_token"
    }
}

//
//  Login.swift
//  WorkingWithNetwork
//
//  Created by Chinar on 19/2/24.
//

import Foundation

struct LoginDetail: Codable {
    let email: String
    let password: String
    
    enum CodableKeys: String, CodingKey {
        case email
        case password
    }
}

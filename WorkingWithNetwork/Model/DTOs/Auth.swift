//
//  Auth.swift
//  WorkingWithNetwork
//
//  Created by Chinar on 17/2/24.
//

import Foundation

struct Auth: Codable {
    let email: String
    let password: String
    let confirmPassword: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case confirmPassword = "confirm_password"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

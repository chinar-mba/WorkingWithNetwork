//
//  EmailVerification.swift
//  WorkingWithNetwork
//
//  Created by Chinar on 19/2/24.
//

import Foundation

struct EmailVerification: Codable {
    let email: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case code
    }
}

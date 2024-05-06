//
//  Constant.swift
//  WorkingWithNetwork
//
//  Created by Chinar on 17/2/24.
//

import Foundation

enum Constants {
    enum API {
        static let baseURL = "http://209.38.228.54:81/api/v1/"
        static let urlRegister = "\(baseURL)register/"
        static let urlEmailCodeVerification = "\(baseURL)send_verify_code/"
        static let urlEmailVerification = "\(baseURL)verify/email/"
        static let urlLogin = "\(baseURL)login/"
    }
}

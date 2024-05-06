//
//  NetworkService.swift
//  WorkingWithNetwork
//
//  Created by Chinar on 17/2/24.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case serverError(String)
    case decodingError(String)
    case unknown
}

struct NetworkService {
    
    static let shared = NetworkService()
    
    func postRegister(user: Auth, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let url = URL(string: Constants.API.urlRegister) else {
            return
        }
        var request = URLRequest(url: url)
        do {
            let model = try JSONEncoder().encode(user)
            request.httpBody = model
        } catch {
            completion(.failure(error))
            return
        }
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-type" : "application/json; charset=UTF-8"]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            switch httpResponse.statusCode {
            case 200...201:
                do {
                    let model = try JSONSerialization.jsonObject(with: data)
                    completion(.success(()))
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            default:
                print("Code status \(httpResponse.statusCode)")
            }
        }
        .resume()
    }
    
    func patchEmailVerification(emailCode: EmailVerification, completion: @escaping(Result<Void, Error>) -> Void) {

        guard let url = URL(string: Constants.API.urlEmailVerification) else {
            return
        }
        var request = URLRequest(url: url)
        do {
            let model = try JSONEncoder().encode(emailCode)
            request.httpBody = model
        } catch {
            print(error)
            completion(.failure(error))
            return
        }
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = ["Content-type" : "application/json; charset=UTF-8"]

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            guard let httpResponse = response as? HTTPURLResponse else { return }

            switch httpResponse.statusCode {
            case (200..<300):
                completion(.success(()))
                print("Success")

            default:
                print("Code status \(httpResponse.statusCode)")

            }
        }.resume()
    }

    func checkCode(emailCode: EmailVerification, completion: @escaping (Result<TokenResponse, NetworkError>) -> Void) {
        guard let url = URL(string: Constants.API.urlEmailVerification) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        do {
            let model = try JSONEncoder().encode(emailCode)
            request.httpBody = model
        } catch {
            completion(.failure(.decodingError("Error encoding email verification data")))
            return
        }
        
        request.httpMethod = "POST" // Make sure this matches the expected method by your API
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError("Invalid response from server")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                completion(.success(tokenResponse))
            } catch {
                completion(.failure(.decodingError("Error decoding token response")))
            }
        }.resume()
    }

    func postLogin(login: LoginDetail, completion: @escaping(Result<TokenResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.API.urlLogin) else {
            return
        }
        var request = URLRequest(url: url)
        do {
            let model = try JSONEncoder().encode(login)
            request.httpBody = model
        } catch {
            print(error)
            completion(.failure(error))
            return
        }
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-type" : "application/json; charset=UTF-8"]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            switch httpResponse.statusCode {
            case (200..<300):
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                    completion(.success(tokenResponse))
                } catch {
                    completion(.failure(error))
                }
            default:
                print("Code status \(httpResponse.statusCode)")
            }
        }.resume()
    }
}

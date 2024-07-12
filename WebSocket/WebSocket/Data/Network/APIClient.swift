//
//  APIClient.swift
//  WebSocket
//
//  Created by Salva Moreno on 18/3/24.
//

import Foundation

// MARK: - APIRouter -
enum APIRouter {
    case signIn
    case signUp
    case getUserId
    case getUserInfo(id: String)
    case refresh
    case getMessages
    case uploadImage
    case saveProfileImage
    case search
    
    var host: String {
        switch self {
            case .signIn, .signUp, .getUserId, .getUserInfo, .refresh, .getMessages, .uploadImage, .saveProfileImage, .search:
                return Constants.host
        }
    }
    
    var port: Int {
        switch self {
            case .signIn, .signUp, .getUserId, .getUserInfo, .refresh, .getMessages, .uploadImage, .saveProfileImage, .search:
                return Constants.port
        }
    }
    
    var scheme: String {
        switch self {
            case .signIn, .signUp, .getUserId, .getUserInfo, .refresh, .getMessages, .uploadImage, .saveProfileImage, .search:
                return Constants.scheme
        }
    }
    
    var path: String {
        switch self {
            case .signIn:
                return Constants.api + "/auth/signin"
            case .signUp:
                return Constants.api + "/auth/signup"
            case .getUserId:
                return Constants.api + "/user/id"
            case .getUserInfo(let id):
                return Constants.api + "/user/info/\(id)"
            case .refresh:
                return Constants.api + "/auth/refresh"
            case .getMessages:
                return Constants.api + "/messages"
            case .uploadImage:
                return Constants.api + "/photo/upload"
            case .saveProfileImage:
                return Constants.api + "/photo/profile"
            case .search:
                return Constants.api + "/search"
        }
    }
    
    var method: String {
        switch self {
            case .signIn, .getUserId, .getUserInfo, .refresh, .getMessages, .search:
                return Constants.get
            case .signUp, .uploadImage, .saveProfileImage:
                return Constants.post
        }
    }
}

// MARK: - APIError -
enum APIError: Error {
    case unknown
    case malformedUrl
    case decodingFailed
    case encodingFailed
    case noData
    case noToken
    case statusCode(code: Int?)
}

// MARK: - APIClient -
final class APIClient: APIClientProtocol {
    // MARK: - Properties -
    private let session: URLSession
    
    // MARK: - Init -
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Functions -
    func signIn(
        email: String,
        password: String,
        apiRouter: APIRouter,
        completion: @escaping (Result<SessionToken, APIError>) -> Void
    ) {
        // Components
        var components = URLComponents()
        components.host = apiRouter.host
        components.port = apiRouter.port
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        // Authorization
        let signInString = String(format: "%@:%@", email, password)
        guard let signInData = signInString.data(using: .utf8) else {
            completion(.failure(.decodingFailed))
            return
        }
        let base64LoginString = signInData.base64EncodedString()
        
        // Request
        var request = URLRequest(url: url)
        // Headers
        request.setValue(Constants.apikey, forHTTPHeaderField: "Websockets-ApiKey")
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        // Method
        request.httpMethod = apiRouter.method
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let sessionToken = try? JSONDecoder().decode(SessionToken.self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(sessionToken))
        }
        
        task.resume()
    }
    
    func signUp(
        name: String,
        email: String,
        password: String,
        apiRouter: APIRouter,
        completion: @escaping (Result<SessionToken, APIError>) -> Void
    ) {
        // Components
        var components = URLComponents()
        components.host = apiRouter.host
        components.port = apiRouter.port
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        // Request
        var request = URLRequest(url: url)
        // Headers
        request.setValue(Constants.apikey, forHTTPHeaderField: "Websockets-ApiKey")
        // Body
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "name", value: name))
        queryItems.append(URLQueryItem(name: "email", value: email))
        queryItems.append(URLQueryItem(name: "password", value: password))
        components.queryItems = queryItems
        request.httpBody = components.query?.data(using: .utf8)
        // Method
        request.httpMethod = apiRouter.method
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let sessionToken = try? JSONDecoder().decode(SessionToken.self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(sessionToken))
        }
        
        task.resume()
    }
    
    func getUserId(email: String, apiRouter: APIRouter, completion: @escaping (Result<User.Id, APIError>) -> Void) {
        // Components
        var components = URLComponents()
        components.host = apiRouter.host
        components.port = apiRouter.port
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token = (UserDefaults.standard.object(forKey: Constants.accessToken) as? String) else {
            completion(.failure(.noToken))
            return
        }
        
        // Request
        var request = URLRequest(url: url)
        // Headers
        request.setValue(Constants.apikey, forHTTPHeaderField: "Websockets-ApiKey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(email, forHTTPHeaderField: "Email")
        // Method
        request.httpMethod = apiRouter.method
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let resource = try? JSONDecoder().decode(User.Id.self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(resource))
        }
        
        task.resume()
    }
    
    func getUserInfo(apiRouter: APIRouter, completion: @escaping (Result<User, APIError>) -> Void) {
        // Components
        var components = URLComponents()
        components.host = apiRouter.host
        components.port = apiRouter.port
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token = (UserDefaults.standard.object(forKey: Constants.accessToken) as? String) else {
            completion(.failure(.noToken))
            return
        }
        
        // Request
        var request = URLRequest(url: url)
        // Headers
        request.setValue(Constants.apikey, forHTTPHeaderField: "Websockets-ApiKey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // Method
        request.httpMethod = apiRouter.method
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let resource = try? JSONDecoder().decode(User.self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(resource))
        }
        
        task.resume()
    }
    
    func getMessages(
        apiRouter: APIRouter,
        completion: @escaping (Result<[Message], APIError>) -> Void
    ) {
        // Components
        var components = URLComponents()
        components.host = apiRouter.host
        components.port = apiRouter.port
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token = (UserDefaults.standard.object(forKey: Constants.accessToken) as? String) else {
            completion(.failure(.noToken))
            return
        }
        
        // Request
        var request = URLRequest(url: url)
        // Headers
        request.setValue(Constants.apikey, forHTTPHeaderField: "Websockets-ApiKey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // Method
        request.httpMethod = apiRouter.method
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let messagesWall = try? JSONDecoder().decode([Message.Wall].self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            let resource: [Message] = messagesWall.map {
                guard let date = Date().convertISO8601StringToDate(dateString: $0.airedAt, dateFormat: "yyyy-MM-dd'T'HH:mmZ") else {
                    return Message(id: $0.id, type: $0.type, message: $0.message, airedAt: nil, user: User.Id(id: $0.user))
                }
                
                return Message(id: $0.id, type: $0.type, message: $0.message, airedAt: date, user: User.Id(id: $0.user))
            }
            
            completion(.success(resource))
        }
        
        task.resume()
    }
    
    func uploadImage(
        type: PhotoType,
        imageData: Data,
        apiRouter: APIRouter,
        completion: @escaping (Result<String, APIError>) -> Void
    ) {
        // Components
        var components = URLComponents()
        components.host = apiRouter.host
        components.port = apiRouter.port
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        components.queryItems = [URLQueryItem(name: "type", value: type.rawValue)]
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token = (UserDefaults.standard.object(forKey: Constants.accessToken) as? String) else {
            completion(.failure(.noToken))
            return
        }
        
        // Request
        var request = URLRequest(url: url)
        // Headers
        request.setValue(Constants.apikey, forHTTPHeaderField: "Websockets-ApiKey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // Method
        request.httpMethod = apiRouter.method
        // Body
        request.httpBody = imageData
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let imageUrl = String(data: data, encoding: .utf8) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(imageUrl))
        }
        
        task.resume()
    }
    
    func saveProfileImage(
        email: String,
        imageString: String,
        apiRouter: APIRouter,
        completion: @escaping (Result<String, APIError>) -> Void
    ) {
        // Components
        var components = URLComponents()
        components.host = apiRouter.host
        components.port = apiRouter.port
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token = (UserDefaults.standard.object(forKey: Constants.accessToken) as? String) else {
            completion(.failure(.noToken))
            return
        }
        
        // Request
        var request = URLRequest(url: url)
        // Headers
        request.setValue(Constants.apikey, forHTTPHeaderField: "Websockets-ApiKey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // Body
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "email", value: email))
        queryItems.append(URLQueryItem(name: "image", value: imageString))
        components.queryItems = queryItems
        request.httpBody = components.query?.data(using: .utf8)
        // Method
        request.httpMethod = apiRouter.method
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let imageUrl = String(data: data, encoding: .utf8) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(imageUrl))
        }
        
        task.resume()
    }
    
    func search(
        query: String,
        apiRouter: APIRouter,
        completion: @escaping (Result<[Message], APIError>) -> Void
    ) {
        // Components
        var components = URLComponents()
        components.host = apiRouter.host
        components.port = apiRouter.port
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        components.queryItems = [URLQueryItem(name: "search", value: query)]
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token = (UserDefaults.standard.object(forKey: Constants.accessToken) as? String) else {
            completion(.failure(.noToken))
            return
        }
        
        // Request
        var request = URLRequest(url: url)
        // Headers
        request.setValue(Constants.apikey, forHTTPHeaderField: "Websockets-ApiKey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // Method
        request.httpMethod = apiRouter.method
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let messagesWall = try? JSONDecoder().decode([Message.Wall].self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            let resource: [Message] = messagesWall.map {
                guard let date = Date().convertISO8601StringToDate(dateString: $0.airedAt, dateFormat: "yyyy-MM-dd'T'HH:mmZ") else {
                    return Message(id: $0.id, type: $0.type, message: $0.message, airedAt: nil, user: User.Id(id: $0.user))
                }
                
                return Message(id: $0.id, type: $0.type, message: $0.message, airedAt: date, user: User.Id(id: $0.user))
            }
            
            completion(.success(resource))
        }
        
        task.resume()
    }
}

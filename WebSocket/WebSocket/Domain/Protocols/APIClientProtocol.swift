//
//  APIClientProtocol.swift
//  WebSocket
//
//  Created by Salva Moreno on 18/3/24.
//

import Foundation

protocol APIClientProtocol {
    func signIn(email: String, password: String, apiRouter: APIRouter, completion: @escaping (Result<SessionToken, APIError>) -> Void)
    func signUp(name: String, email: String, password: String, apiRouter: APIRouter, completion: @escaping (Result<SessionToken, APIError>) -> Void)
    func getUserId(email: String, apiRouter: APIRouter, completion: @escaping (Result<User.Id, APIError>) -> Void)
    func getUserInfo(apiRouter: APIRouter, completion: @escaping (Result<User, APIError>) -> Void)
    func getMessages(apiRouter: APIRouter, completion: @escaping (Result<[Message], APIError>) -> Void)
    func uploadImage(type: PhotoType, imageData: Data, apiRouter: APIRouter, completion: @escaping (Result<String, APIError>) -> Void)
    func saveProfileImage(email: String, imageString: String, apiRouter: APIRouter, completion: @escaping (Result<String, APIError>) -> Void)
    func search(query: String, apiRouter: APIRouter, completion: @escaping (Result<[Message], APIError>) -> Void)
}

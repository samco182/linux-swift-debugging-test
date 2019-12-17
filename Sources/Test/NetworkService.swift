//
//  NetworkService.swift
//  Test
//
//  Created by Samuel Cornejo on 9/13/19.
//

import Foundation

enum NetworkServiceError: Error {
    case dataNotAvailable
    case statusCodeNotOK
    case invalidCallingConvention
}

struct NetworkService {
    let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func execute(request: URLRequest, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let _ = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("Data fetched!")
                        
                    if let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode {
                        onCompletion(.success(()))
                    } else {
                        onCompletion(.failure(NetworkServiceError.statusCodeNotOK))
                    }
                } catch let error {
                    onCompletion(.failure(error))
                }
            } else if let error = error {
                onCompletion(.failure(error))
            } else {
                onCompletion(.failure(NetworkServiceError.dataNotAvailable))
            }
        }
        
        dataTask.resume()
    }
}

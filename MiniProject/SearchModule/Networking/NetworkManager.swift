//
//  NetworkManager.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import Foundation

class NetworkManager: NetworkManagerProtocol, SearchNetworkProtocol{
    
    static var shared = NetworkManager()
    
    internal func request<T: Decodable>(method: HTTPMethod, contentType: ContentType, data: Data?, url: String, queryItems: [URLQueryItem], completion: @escaping((Result<T, Error>) -> Void)){
        var components = URLComponents()
        components.queryItems = queryItems
        components.path = URLManager.baseUrl.url + url
        components.scheme = "https"
        guard let url = components.url else{completion(.failure(CustomError.callApiFailBecauseURLNotFound));return}
        print("error: \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "accept")
        if let apiKey = UserDefaults.standard.value(forKey: "apiKey"){
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error{
                completion(.failure(error))
            }
            guard let data = data else{
                completion(.failure(CustomError.apiReturnNoData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 300 && httpResponse.statusCode >= 200 else{
                completion(.failure(CustomError.somethingWentWrong))
                return
            }
            //            print(httpResponse)
            var decoder = JSONDecoder()
            do{
                var model = try decoder.decode(T.self, from: data)
                completion(.success(model))
            }catch{
                print(String(describing: error))
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchCategories(completion: @escaping(Result<[Category], Error>) -> Void){
        request(method: .get, contentType: .formUrlEncoded, data: nil, url: URLManager.getAllCategoriess.url, queryItems: []) { (result: Result<ModelContainer, Error>) in
            switch result{
            case .success(let model):
                guard let data = model.data,
                      let categories = data.categories else{
                    completion(.failure(CustomError.somethingWentWrong))
                    return
                }
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadFromJSON<T: Decodable>(_ type: T.Type) -> T?{
        if let path = Bundle.main.path(forResource: "data", ofType: "json"){
            do{
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                return model
                
            }catch{
                print("error: \(error.localizedDescription)")
            }
        }else{
            print("error: path does not exist")
        }
        return nil
    }
}

enum HTTPMethod: String{
    case get
    case post
}

enum ContentType: String{
    case formUrlEncoded = "application/x-www-form-urlencoded"
}

protocol NetworkManagerProtocol{
    func request<T: Decodable>(method: HTTPMethod, contentType: ContentType, data: Data?, url: String, queryItems: [URLQueryItem], completion: @escaping((Result<T, Error>) -> Void))
}

protocol SearchNetworkProtocol{
    func fetchCategories(completion: @escaping(Result<[Category], Error>) -> Void)
}

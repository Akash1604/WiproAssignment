//
//  NetworkAdopter.swift
//  AssignmentTestApp
//
//  Created by akash on 26/02/20.
//  Copyright © 2020 akash. All rights reserved.
//

import Foundation


public enum Method {
    case post,get,put,delete
}


extension Method {
    
    var name:String {
        switch self {
        case .post:
            return "POST"
        case .get:
            return "GET"
        case .put:
            return "PUT"
        default:
            return "DELETE"
        }
    }
}
enum Config {
    static let BASE_URL                      = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/"
    static let POSTS                         = "facts.json"
   
}


class HttpClientApi: NSObject{
    
    var session : URLSession = URLSession.shared
    
    static func instance() ->  HttpClientApi{
        return HttpClientApi()
    }
 
    func getAPICall<T: Decodable>(url: String,parameter:[String:Any],method: Method,decodingType: T.Type, callback:Callback<Any,String>) {
        let urlString = URL(string: Config.BASE_URL + url)
        var  request = URLRequest(url: urlString!)
        request.httpMethod = method.name
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if method.name == "POST" {
            let data = try! JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
            request.httpBody = data
        }
        let urlSession : URLSession = URLSession.shared
        print("Request URL is:\(request.url!.absoluteString)")

        urlSession.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    if let value = String(data: data, encoding: String.Encoding.ascii) {
                        
                        if let jsonData = value.data(using: String.Encoding.utf8) {
                            do {
                                let jsonObject = try JSONDecoder().decode(PostData.self, from: jsonData)
                                callback.onSuccess(jsonObject)
                                
                            }catch let error {
                                callback.onFailure(error.localizedDescription)
                            }
                        }
                    }
                } else if let response = response as? HTTPURLResponse, 400...499 ~= response.statusCode{
                    print("Api Failed with Response Code:\(response.statusCode)")
                    callback.onFailure(response.statusCode.description)
                }
            }else {
                callback.onFailure(error?.localizedDescription ?? "")
            }
            }.resume()
        
    }
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

    
}

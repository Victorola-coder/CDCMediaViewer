//
//  HttpError.swift
//  CDCMediaViewer
//
//  Created by VickyJay on 07/11/2024.
//


enum HttpError: Error {
    case invalidResponse
    case networkError(Error)
    case invalidStatusCode(Int)
}

class HttpClient {
    func get(url urlString: String, 
             success: @escaping (Dictionary<String, Any>) -> Void,
             failure: @escaping (String) -> Void) throws {
        
        guard let url = URL(string: urlString) else {
            failure("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle network error
            if let error = error {
                DispatchQueue.main.async {
                    failure(error.localizedDescription)
                }
                return
            }
            
            // Check HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    failure("Invalid response")
                }
                return
            }
            
            // Check status code
            guard httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    failure("HTTP Error: \(httpResponse.statusCode)")
                }
                return
            }
            
            // Parse JSON data
            guard let data = data,
                  let jsonObject = try? JSONSerialization.jsonObject(with: data),
                  let jsonDict = jsonObject as? Dictionary<String, Any> else {
                DispatchQueue.main.async {
                    failure("Invalid JSON data")
                }
                return
            }
            
            DispatchQueue.main.async {
                success(jsonDict)
            }
        }
        
        task.resume()
    }
} 
import Foundation

struct NetworkManager {
    static func get(
        url: String,
        success: @escaping ([String: Any]) -> Void,
        failure: @escaping (String) -> Void
    ) throws {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    failure("Request failed: \(error.localizedDescription)")
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                DispatchQueue.main.async {
                    failure("Failed with response code other than 200")
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    DispatchQueue.main.async {
                        success(json)
                    }
                } else {
                    DispatchQueue.main.async {
                        failure("Failed to parse JSON")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    failure("JSON Parsing Error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}

import Foundation

func translateText(_ text: String, targetLanguage: String, completion: @escaping (String?) -> Void) {
    let apiKey = "AIzaSyDe2NcjPQNYMM3JxX7EQ6WjhxHew_qZtaw"  // Replace with your actual API key
    let url = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let parameters: [String: Any] = [
        "q": text,
        "target": targetLanguage,
        "format": "text",
        "key": apiKey
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let dataObject = jsonResponse["data"] as? [String: Any],
           let translations = dataObject["translations"] as? [[String: Any]],
           let translatedText = translations.first?["translatedText"] as? String {
            completion(translatedText)
        } else {
            print("Failed to parse translation response.")
            completion(nil)
        }
    }
    
    task.resume()
}

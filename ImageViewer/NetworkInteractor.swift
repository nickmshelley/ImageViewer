
import Foundation

class NetworkInteractor {
    static func fetchImages(completion: @escaping () -> Void) {
        let url = URL(string: "https://api.gannett-cdn.com/internal/MobileServices/MMediaService.svc/mcontent/v1/gallery?galleryId=5197105&api_key=rtxdju9wfw78treew9uuhhsj")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return completion() }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        }
        
        task.resume()
    }
}

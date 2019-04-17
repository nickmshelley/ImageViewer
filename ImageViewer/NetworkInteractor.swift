
import Foundation

struct USAImage {
    let thumbnailURL: URL
    let nineBySixteenURL: URL
}

private struct Response: Decodable {
    let images: [USAImage]
    
    enum CodingKeys: String, CodingKey {
        case albums
        case slides
        case metaData
        case crops
        case nineBySixteen = "9_16"
        case items
        case publishurl
        case smallbasename
    }
    
    init(from decoder: Decoder) throws {
        let outer = try decoder.container(keyedBy: CodingKeys.self)
        var albums = try outer.nestedUnkeyedContainer(forKey: .albums)
        var slidesContainers: [UnkeyedDecodingContainer] = []
        while !albums.isAtEnd {
            let keyedAlbum = try albums.nestedContainer(keyedBy: CodingKeys.self)
            let slides = try keyedAlbum.nestedUnkeyedContainer(forKey: .slides)
            slidesContainers.append(slides)
        }
        
        var images: [USAImage] = []
        for var slidesContainer in slidesContainers {
            while !slidesContainer.isAtEnd {
                let slide = try slidesContainer.nestedContainer(keyedBy: CodingKeys.self)
                let metadata = try slide.nestedContainer(keyedBy: CodingKeys.self, forKey: .metaData)
                let cropsContainer = try metadata.nestedContainer(keyedBy: CodingKeys.self, forKey: .crops)
                let nineBySixteen = try cropsContainer.decode(String.self, forKey: .nineBySixteen)
                let items = try metadata.nestedContainer(keyedBy: CodingKeys.self, forKey: .items)
                let base = try items.decode(String.self, forKey: .publishurl)
                let path = try items.decode(String.self, forKey: .smallbasename)
                
                if let thumbURL = URL(string: base + path), let cropURL = URL(string: nineBySixteen) {
                    images.append(USAImage(thumbnailURL: thumbURL, nineBySixteenURL: cropURL))
                }
            }
        }
        
        self.images = images
    }
}

class NetworkInteractor {
    static func fetchImages(completion: @escaping ([USAImage]) -> Void) {
        let url = URL(string: "https://api.gannett-cdn.com/internal/MobileServices/MMediaService.svc/mcontent/v1/gallery?galleryId=5197105&api_key=rtxdju9wfw78treew9uuhhsj")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return completion([]) }
            
            let response = try! JSONDecoder().decode(Response.self, from: data)
            completion(response.images)
        }
        
        task.resume()
    }
}

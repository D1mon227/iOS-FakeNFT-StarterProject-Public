
import Foundation

protocol DownloadImageServiceProtocol {
    func getDataFromUrl(url: URL,
                        completion: @escaping (Data?, URLResponse?, Error?) -> ())
}

final class DownloadImageService: DownloadImageServiceProtocol {
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }.resume()
    }
 }





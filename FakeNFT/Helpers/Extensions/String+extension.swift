import UIKit

extension String {
    func makeUrl() -> URL? {
        if let url = URL(string: self) {
            return url
        }
        
        
        if let encodedLink = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedLink) {
            return url
        }
        
       return nil
    }
}


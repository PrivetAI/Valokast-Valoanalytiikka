import Foundation

class ValokastRedirectWatcher: NSObject, URLSessionTaskDelegate {
    var resolvedURL: URL?
    
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        resolvedURL = request.url
        completionHandler(request)
    }
}

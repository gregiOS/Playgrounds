import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
extension Notification.Name {
    static let urlSessionTaskDidStart = Notification.Name("didStartURLSessionTask")
    static let urlSessionTaskDidComplete = Notification.Name("didStartURLSessionTask")
}

extension Notification {
    static func makeURLSessionTaskNotification(_ urlSessionTask: URLSessionTask?,
                                               urlSession: URLSession?,
                                               forName name: Notification.Name) -> Notification {
        guard let urlSessionTask = urlSessionTask else { fatalError("URLSessionTask was empty.") }
        return Notification(name: name, object: urlSession, userInfo: [URLSessionTask.urlSessionTaskKey: urlSessionTask])
    }
}

extension URLSessionTask {
    static let urlSessionTaskKey = "URLSessionTask.urlSessionTaskKey"
}

class APIClient {
    enum APIClientError: Swift.Error {
        case invalidStatusCode
    }
    let urlSession = URLSession(configuration: .default)
    let notificationCenter = NotificationCenter.default
    
    func perform(_ urlRequest: URLRequest,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var urlSessionTask: URLSessionTask?
        urlSessionTask =
            urlSession
                .dataTask(with: urlRequest) { [weak self] (data, response, error) in
                    completion(data, response, error)
                    self?.notificationCenter
                        .post(.makeURLSessionTaskNotification(urlSessionTask,
                                                              urlSession: self?.urlSession,
                                                              forName: .urlSessionTaskDidStart))
        }
        urlSessionTask?.resume()
        notificationCenter
            .post(.makeURLSessionTaskNotification(urlSessionTask,
                                                  urlSession: urlSession,
                                                  forName: .urlSessionTaskDidStart))
    }
    
    func preformLogin(using urlRequest: URLRequest, completionHandler: @escaping (Bool, Error?) -> Void) {
        perform(urlRequest) { (data, urlResponse, error) in
            if let error = error {
                completionHandler(false, error)
                return
            }
            if let urlResponse = urlResponse as? HTTPURLResponse,
                (200..<300).contains(urlResponse.statusCode) {
                completionHandler(true, nil)
            } else {
                completionHandler(false, APIClientError.invalidStatusCode)
            }
        }
    }
}

class URLRequestsObserver {
    let notificationCenter = NotificationCenter.default
    private var tokens: [Any] = []
    init() {
        registerForNotifications()
    }
    deinit {
        tokens.forEach(notificationCenter.removeObserver)
    }
    private func registerForNotifications() {
        notificationCenter
            .addObserver(forName: .urlSessionTaskDidStart,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                            self?.handleURLSessionTaskDidStart(notification)
        }
        notificationCenter
            .addObserver(forName: .urlSessionTaskDidComplete,
                         object: nil,
                         queue: nil) { [weak self] (notification) in
                            self?.handleURLSessionTaskDidComplete(notification)
        }
    }
    private func handleURLSessionTaskDidStart(_ notification: Notification) {
        guard let urlSesisonTask = notification.userInfo?[URLSessionTask.urlSessionTaskKey] as? URLSessionTask else { return }
        print("URL session task did start: \(urlSesisonTask)")
    }
    private func handleURLSessionTaskDidComplete(_ notification: Notification) {
        guard let urlSesisonTask = notification.userInfo?[URLSessionTask.urlSessionTaskKey] as? URLSessionTask else { return }
        print("URL session task did complete: \(urlSesisonTask)")
    }
}

let apiClient = APIClient()
apiClient.preformLogin(using: URLRequest(url: URL(string: "https://api.github.com/v3/users")!)) { (isLoggedIn, error) in
    switch (isLoggedIn, error) {
    case (true, _):
        print("user was logged")
    case (false, let error?):
        print("error occured while login user: \(error)")
    default:
        print("Unknown stuff happend")
    }
}

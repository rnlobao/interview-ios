import UIKit

class MockURLSession: URLSession {
    var dataTaskMock: MockURLSessionDataTask!
    var mockData: Data?
    var mockError: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskMock = MockURLSessionDataTask {
            completionHandler(self.mockData, nil, self.mockError)
        }
        return dataTaskMock
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

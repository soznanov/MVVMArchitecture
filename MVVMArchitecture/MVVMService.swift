import Foundation

class MVVMCommand {
    private let closure: Closure

    init(with closure: @escaping Closure) {
        self.closure = closure
    }

    func execute() {
        closure()
    }

    static func empty() -> MVVMCommand { return MVVMCommand(with: {}) }
}

class MVVMCommandWith<Object> {
    typealias Action = (Object) -> Void
    private let closure: Action

    init(with closure: @escaping Action) {
        self.closure = closure
    }

    func execute(_ object: Object) {
        closure(object)
    }

    static func empty() -> MVVMCommandWith<Object> { return MVVMCommandWith<Object>(with: { _ in }) }
}

class MVVMCommandGet<Object> {
    private let closure: () -> Object

    init(with closure: @escaping () -> Object) {
        self.closure = closure
    }

    func execute() -> Object {
        return closure()
    }
}

class MVVMService<RequestObject, ResponseObject> {
    typealias Request = (RequestObject, @escaping Completion) -> Void
    typealias Response = Result<ResponseObject, Error>
    typealias Completion = (Response) -> Void

    private let request: Request

    init(with request: @escaping Request) {
        self.request = request
    }

    func execute(with object: RequestObject, completion: @escaping Completion) {
        return request(object, completion)
    }
}

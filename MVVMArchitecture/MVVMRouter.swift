import Foundation

enum MVVMAlertingStyle {
    case green
    case red
}

protocol MVVMAlertingProtocol {
    func showAlertOnTop(text: String, style: MVVMAlertingStyle)
    func showAlertOnTop(text: String, style: MVVMAlertingStyle, actionTitle: String?, action: Closure?)
}

protocol MVVMProcessingProtocol {
    func showProgress()
    func hideProgress()
}

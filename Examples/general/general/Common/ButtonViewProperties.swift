import UIKit

struct ButtonViewProperties {
    let title: String
    let image: UIImage?
    let action: Closure
    let isEnable: Bool
    
    init() {
        self.title = ""
        self.action = {}
        self.image = nil
        self.isEnable = true
    }
    
    init(title: String = "",
         image: UIImage? = nil,
         isEnable: Bool = true,
         action: @escaping Closure = {}) {
        
        self.title = title
        self.action = action
        self.image = image
        self.isEnable = isEnable
    }
}

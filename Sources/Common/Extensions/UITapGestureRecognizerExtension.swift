import UIKit

extension UITapGestureRecognizer {
    private static var privacyRangeKey: UInt8 = 0

    var privacyRange: NSRange? {
        get { return objc_getAssociatedObject(self, &UITapGestureRecognizer.privacyRangeKey) as? NSRange }
        set { objc_setAssociatedObject(self, &UITapGestureRecognizer.privacyRangeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

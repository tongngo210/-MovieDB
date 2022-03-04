import UIKit

extension UIFont {
    enum FontSize: CGFloat {
        case twelve = 12.0
        case fourteen = 14.0
        case sixteen = 16.0
        case eighteen = 18.0
    }
    
    static func setPoppinsFont(style: AppFont.Poppins, size: FontSize) -> UIFont {
        return UIFont(name: style.rawValue, size: size.rawValue) ?? UIFont()
    }
}

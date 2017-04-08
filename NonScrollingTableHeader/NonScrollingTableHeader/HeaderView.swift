//
//  HeaderView.swift
//  NonScrollingTableHeader
//
//  Created by Info Reqd on 1/4/17.
//  Copyright © 2017 Info Reqd. All rights reserved.
//

import UIKit

public class HeaderView : UIView {
    
    @IBOutlet weak var label : UILabel!
    
    @IBOutlet weak var heightConstraint : NSLayoutConstraint!

    /// constraint for superview's bottom to equal inner header bottom so that the height change follows the scroll content offset sign change
    @IBOutlet weak var headerViewBottomEqualInnerHeaderBottom : NSLayoutConstraint!

    /// size from the initial bounds of the view
    lazy var preferredMaximumHeight : CGFloat = {
        return self.bounds.size.height
    }()

    /// thought of getting this from the systemLayoutSizeFitting(UILayoutFittingCompressedSize), but since there is a height constraint, it cannot be derived like that
    lazy var preferredMinimumHeight : CGFloat = {
        return CGFloat(60.0)
    }()

}

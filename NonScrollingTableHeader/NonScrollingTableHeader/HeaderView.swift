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
    
    /// size from the initial bounds of the view
    lazy var preferredMaximumHeight : CGFloat = {
        return self.bounds.size.height
    }()

    /// throught of getting this from the systemLayoutSizeFitting(UILayoutFittingCompressedSize), but since there is a height constraint, it cannot be derived like that
    lazy var preferredMinimumHeight : CGFloat = {
        return CGFloat(40.0)
    }()

}

//
//  HeaderView.swift
//  NonScrollingTableHeader
//
//  Created by Info Reqd on 1/4/17.
//  Copyright © 2017 Info Reqd. All rights reserved.
//

import UIKit

/// the image is in the inner headerview is aspect fill, clips to bounds, center x align, equal width @750 so this breaks first, bottom, top space <= 0. This to give it the effect of image increasing in size as the header increases in height 

public class HeaderView : UIView {
    
    @IBOutlet weak var label : UILabel!
    
    @IBOutlet weak var heightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak internal var contentView: UIView!


    /// constraint for superview's bottom to equal inner header bottom so that the height change follows the scroll content offset sign change
    @IBOutlet weak var headerViewBottomEqualInnerHeaderBottom : NSLayoutConstraint!

    /// size from the initial bounds of the view
    lazy var preferredMaximumHeight : CGFloat = {
        return self.bounds.size.height
    }()

    /// As the contentview's size is fully defined by the contraints on the items within it, the systemLayoutSize will give a good approximation of the minimum. Only time it will fail is when the height of the labels etc within change due to two line labels etc. So these values should be set in the init functions
    lazy var preferredMinimumHeight : CGFloat = {
        let minContentSize = self.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return minContentSize.height
    }()

}

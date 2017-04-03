//
//  HeaderViewReduceHeightAtScrollUpDelegate.swift
//  NonScrollingTableHeader
//
//  Created by Info Reqd on 2/4/17.
//  Copyright © 2017 Info Reqd. All rights reserved.
//

import UIKit

/// SRP : handles the logic to continuously reduce the height of the headerView as the tableview scrolls
class HeaderViewReduceHeightAtScrollUpDelegate: NSObject {
 
    let kvoKeyPathForContentOffset = "contentOffset"
    let headerView : HeaderView
    unowned let scrollView : UIScrollView
    
    init(headerView: HeaderView, scrollView: UIScrollView) {
        self.headerView = headerView
        self.scrollView = scrollView
        super.init()
        self.scrollView.addObserver(self, forKeyPath: kvoKeyPathForContentOffset, options: [.old, .new], context: nil)
    }
    
    deinit {
        self.scrollView.removeObserver(self, forKeyPath: kvoKeyPathForContentOffset)
    }
    
    /// Provides continuous change in the height of the header as derived from the continuous change in the content offset of the associated scrollView
    ///
    /// - Parameters:
    ///   - keyPath: "contentOffset"
    ///   - object: the scrollView. But has to be cast as KVO returns Any?
    ///   - change: the old and new values of the keypath
    ///   - context: nil for now. Will put in if we need it
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let tableView = object as? UITableView {
            let newContentOffset = change?[.newKey] as! CGPoint
            if newContentOffset.y > 0 {
                //there has been a scroll change in the upward direction and scrollView is not just tracking
                let oldContentOffset = change?[.oldKey] as! CGPoint
                let offset = newContentOffset.y - oldContentOffset.y //highPositive - lowPositive = +ve
                if offset > 0 //Scrolling up
                {
                    let finalHeight = finalHeaderHeight(contentOffset: CGPoint(x: 0.0, y: offset),
                                                        contentInset: tableView.contentInset,
                                                        headerHeight: self.headerView.heightConstraint.constant,
                                                        preferredMinimumHeight: self.headerView.preferredMinimumHeight,
                                                        preferredMaximumHeight: self.headerView.preferredMaximumHeight)
                    self.headerView.heightConstraint.constant = finalHeight
                    
                }
            }
        }
    }
    
    /// Given the content offset of the scrollview at that time, this method provides the final height within the range [preferredMinimumHeight, preferredMaximumHeight] that the headerView should have
    ///
    /// - Parameters:
    ///   - contentOffset: contentOffset of scrollview
    ///   - contentInset: contentInset of scrollview
    ///   - headerHeight: height constraint value for the header at that point in time
    ///   - preferredMinimumHeight: preferred Minimum Height so that the method will not return height less than that
    ///   - preferredMaximumHeight: preferred Maximum Height so that the method will not return height MORE than that
    /// - Returns: final height that should be for the header
    func finalHeaderHeight(contentOffset: CGPoint, contentInset: UIEdgeInsets, headerHeight : CGFloat, preferredMinimumHeight: CGFloat, preferredMaximumHeight: CGFloat ) -> CGFloat {
        
        let absoluteContentOffset = contentOffset.y + contentInset.top
        let headerHeightDueToScroll = headerHeight - absoluteContentOffset
        let heightNormalisedToMinimumAllowedValue = fmax(preferredMinimumHeight, headerHeightDueToScroll)
        let heightNormalisedToMaximumAllowedValueAlso = fmin(preferredMaximumHeight, heightNormalisedToMinimumAllowedValue)
        
        return heightNormalisedToMaximumAllowedValueAlso
    }

    
}

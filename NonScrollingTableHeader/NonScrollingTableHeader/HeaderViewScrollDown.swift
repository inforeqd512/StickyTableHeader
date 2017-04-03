//
//  HeaderViewReduceHeightAtScrollUpDelegate.swift
//  NonScrollingTableHeader
//
//  Created by Info Reqd on 2/4/17.
//  Copyright © 2017 Info Reqd. All rights reserved.
//

import UIKit

/// SRP : handles the logic to continuously increase the height of the headerView as the tableview scrolls downwards. This is till the height reaches preferred max
class HeaderViewExpandHeightAtScrollDownDelegate: NSObject {
    
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
            
            if newContentOffset.y < 0 { //scrollview has scrolled south of (0,0) contentOffset, which will always be the case as after the collapse, the content offset of the scrollview is zero at the collapsed header height
                
                let oldContentOffset = change?[.oldKey] as! CGPoint
                let offset = newContentOffset.y - oldContentOffset.y//highMinus - lowMinus = -ve
                if offset < 0 { //Scrolling down
                    let headerHeight = self.headerView.heightConstraint.constant
                    let preferredMaximumHeight  = self.headerView.preferredMaximumHeight
                    let preferredMinimumHeight = self.headerView.preferredMinimumHeight
                    if headerHeight >= preferredMinimumHeight && //while the headerHeight is [preferredMin, preferredMax], adjust it
                        headerHeight < preferredMaximumHeight
                    {
                        //there has been a scroll change and scrollView is not just tracking
                        let finalHeight = finalHeaderHeight(contentOffset: newContentOffset,
                                                            contentInset: tableView.contentInset,
                                                            headerHeight: headerHeight,
                                                            preferredMinimumHeight: self.headerView.preferredMinimumHeight,
                                                            preferredMaximumHeight: preferredMaximumHeight)
                        self.headerView.heightConstraint.constant = finalHeight
                        
                    }
                }
                
            }
        }
    }
}

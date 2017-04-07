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
        
        //when tableView scrolls DOWN, contentOffset is -ve ie. southern direction from start of scrollView
        //when tableView scrolls UP, contentOffset is +ve ie. northern direction from start of scrollView
        //so have set up the headerViewBottomEqualInnerHeaderBottom for superview's bottom to equal inner header bottom so that the height change follows the scroll content offset sign change

        if let tableView = object as? UITableView {
            
            let newContentOffset = change?[.newKey] as! CGPoint
            let oldContentOffset = change?[.oldKey] as! CGPoint
            
            //compute offset as vector which indicates the scroll direction
            let offset = newContentOffset.y - oldContentOffset.y

            self.headerView.heightConstraint.constant = reducedHeight(of: self.headerView, by: offset, contentInset: tableView.contentInset, newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)

            self.headerView.headerViewBottomEqualInnerHeaderBottom.constant = reducedOverstretch(of: self.headerView, by: offset, newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
        }
    }
    
    /// shrink the header height when user is shrinking the header from its initial height by scrolling north of contentOffset (0,0)
    ///
    /// - Parameters:
    ///   - headerView: headerView headerView set up as V:HeaderView-TableView for shrinking as user or system scrolls up
    ///   - offset: offset delta change in scrolling as a vector
    ///   - contentInset: contentInset tableview's contentinset
    ///   - newContentOffset: newContentOffset new value as returned by KVO
    ///   - oldContentOffset: oldContentOffset old value that was , by KVO
    /// - Returns: the final reduced header height
    
    func reducedHeight(of headerView: HeaderView, by offset: CGFloat, contentInset: UIEdgeInsets, newContentOffset : CGPoint, oldContentOffset : CGPoint) -> CGFloat {
        
        if shouldReduceRealHeaderHeight(newContentOffset: newContentOffset) {
            if isScrollingUp(newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
            {
                let finalHeight = finalHeaderHeight(deltaContentOffset: CGPoint(x: 0.0, y: offset),
                                                    contentInset: contentInset,
                                                    headerHeight: headerView.heightConstraint.constant,
                                                    preferredMinimumHeight: headerView.preferredMinimumHeight,
                                                    preferredMaximumHeight: headerView.preferredMaximumHeight)
                return finalHeight
            }
        }
        return headerView.heightConstraint.constant
    }

    /// decides if the scroll up is so that the real height of the headerView should decrease upto preferred min
    ///
    ///   - newContentOffset: newContentOffset new value as returned by KVO
    /// - Returns: true if height should decrease
    func shouldReduceRealHeaderHeight(newContentOffset : CGPoint) -> Bool {
        if newContentOffset.y > 0 { //if scrolling upwards from content offset (0,0)
            return true //then actual height of the header view will decrease
        }else{
            return false
        }
    }
    
    /// shrink the overstretched inner header height when user scrolls up or when the scroll up happens automatically due to spring action of the scrollview as the user lifts his finger
    ///
    /// - Parameters:
    ///   - headerView: headerView headerview set up with an inner headerview that actually stretches during overstretch and so should be normalised when scroll up happens
    ///   - offset: offset delta change in scrolling as a vector
    ///   - newContentOffset: newContentOffset new value as returned by KVO
    ///   - oldContentOffset: oldContentOffset old value that was , by KVO
    /// - Returns: the final reduced inner header constraint constant
    func reducedOverstretch(of headerView: HeaderView, by offset: CGFloat, newContentOffset : CGPoint, oldContentOffset : CGPoint) -> CGFloat {
        if isHeaderOverstretched(headerView: headerView) { //if overstretch had occured on scroll down
            if isScrollingUp(newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
            {
                return reducedConstantForOverstretchInHeaderViewBottomEqualInnerHeaderBottomConstraint(headerView: self.headerView, deltaOffsetOfUpwardScroll: offset)
            }
        }
        return headerView.headerViewBottomEqualInnerHeaderBottom.constant
    }
    
    /// informs if the user is scrolling upwards
    ///
    /// - Parameters:
    ///   - newContentOffset: newContentOffset new value as returned by KVO
    ///   - oldContentOffset: oldContentOffset old value that was , by KVO
    /// - Returns: true if scrolling up
    func isScrollingUp(newContentOffset:CGPoint, oldContentOffset:CGPoint) -> Bool {
        let offset = newContentOffset.y - oldContentOffset.y
        if offset > 0 {
            return true
        }else{
            return false
        }
    }
    
    /// informs if the inner headerView is actually overstretched by looking at the bottom constraint's contant
    ///
    /// - headerView: headerView headerview set up with an inner headerview that actually stretches during overstretch and so should be normalised when scroll up happens
    /// - Returns: true if inner header view is overstretched
    func isHeaderOverstretched(headerView: HeaderView) -> Bool {
        if self.headerView.headerViewBottomEqualInnerHeaderBottom.constant < 0  {
            return true
        }else{
            return false
        }
    }
    
    /// calculates the new constant for the bottom constraint for reducing the parallax effect
    ///
    /// - Parameters:
    ///   - headerView: headerView headerview set up with an inner headerview that actually stretches during overstretch and so should be normalised when scroll up happens
    ///   - deltaOffsetOfUpwardScroll: deltaOffsetOfUpwardScroll delta change in scrolling as a vector
    /// - Returns: new normalised constant value
    func reducedConstantForOverstretchInHeaderViewBottomEqualInnerHeaderBottomConstraint(headerView: HeaderView, deltaOffsetOfUpwardScroll: CGFloat) -> CGFloat  {
        let overstretchVector = headerView.headerViewBottomEqualInnerHeaderBottom.constant
        var newOverstretchVector = overstretchVector + deltaOffsetOfUpwardScroll
        if newOverstretchVector > 0 {
            newOverstretchVector = 0
        }
        return newOverstretchVector
    }
}

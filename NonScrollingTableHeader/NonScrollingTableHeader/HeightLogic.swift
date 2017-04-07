//
//  HeightLogic.swift
//  NonScrollingTableHeader
//
//  Created by Shefali Mistry on 3/4/17.
//  Copyright © 2017 Info Reqd. All rights reserved.
//

import UIKit

/// Given the content offset of the scrollview at that time, this method provides the final height within the range [preferredMinimumHeight, preferredMaximumHeight] that the headerView should have
///
///   - deltaContentOffset: deltaContentOffset delta change vector of content offset +ve => change due to scroll up, -ve => change due to scroll down
///   - contentInset: contentInset of scrollview
///   - headerHeight: height constraint value for the header at that point in time
///   - preferredMinimumHeight: preferred Minimum Height so that the method will not return height less than that
///   - preferredMaximumHeight: preferred Maximum Height so that the method will not return height MORE than that
/// - Returns: final height that should be for the header
func finalHeaderHeight(deltaContentOffset: CGPoint, contentInset: UIEdgeInsets, headerHeight : CGFloat, preferredMinimumHeight: CGFloat, preferredMaximumHeight: CGFloat ) -> CGFloat {
    
    let absoluteContentOffset = deltaContentOffset.y + contentInset.top
    let headerHeightDueToScroll = headerHeight - absoluteContentOffset //reduces or increases the height based on sigh of deltaContentOffset
    let heightNormalisedToMinimumAllowedValue = fmax(preferredMinimumHeight, headerHeightDueToScroll)
    let heightNormalisedToMaximumAllowedValueAlso = fmin(preferredMaximumHeight, heightNormalisedToMinimumAllowedValue)
    
    return heightNormalisedToMaximumAllowedValueAlso
}

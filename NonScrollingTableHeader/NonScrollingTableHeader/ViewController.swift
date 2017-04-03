//
//  ViewController.swift
//  NonScrollingTableHeader
//
//  Created by Info Reqd on 1/4/17.
//  Copyright © 2017 Info Reqd. All rights reserved.
//

import UIKit
/*
 Preconditions:

 If the headerview is set as the tables's header view, then it scrolls offscreen when the table scrolls
 to make the header Stick to the top of the screen it has to be kept separate from the tableView
 as
 HeaderView
    |
 TableView
 
 This arrangement will also ensure that as the header view shrinks in height, the tableview moves up along with it, so it looks to the user as one single unit
 
 Now to get the Header view to shrink in height continuously as the user is scrolling up, we have to use the kvo on contentOffset as scrollviewDidScroll vends very large increments of change in the offset
 
 Since there is one KVO funnel method, so to implement SRP and OCP principle, have put that logic into HeaderViewReduceHeightAtScrollUpDelegate class so that when the user wants to know of how to change height during scroll, he looks at only this class. Also this class encapsuates all logic for just the height reduction so it's closed for change
 
 Views are defined in Storyboard or XIBs. So as to be able to derive as much information out of the autolayout system 
 */

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var headerViewReduceHeightAtScrollUpDelegate : HeaderViewReduceHeightAtScrollUpDelegate? = nil
    var headerViewExpandHeightAtScrollDownDelegate : HeaderViewExpandHeightAtScrollDownDelegate? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerViewReduceHeightAtScrollUpDelegate = HeaderViewReduceHeightAtScrollUpDelegate(headerView: self.headerView, scrollView: self.tableView)
        self.headerViewExpandHeightAtScrollDownDelegate = HeaderViewExpandHeightAtScrollDownDelegate(headerView: self.headerView, scrollView: self.tableView)

    }

}


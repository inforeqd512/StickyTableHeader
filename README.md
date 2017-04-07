# StickyTableHeader
In a TableView Controller, a TableView Header scrolls up with the table view. This project shows how to create one that will stay on screen while the table scrolls.  Also will incrementally add capabilities to animate the header height based on scroll



![Demo](https://cloud.githubusercontent.com/assets/4088886/24797762/1a5a6b18-1bd6-11e7-9d5a-f6c8763ce714.gif)


When the headerview is set as the tables's header view, then it scrolls offscreen when the table scrolls
 to make the header Stick to the top of the screen it has to be kept separate from the tableView
 as
 HeaderView
    |
 TableView
 
 This arrangement will also ensure that as the header view shrinks in height, the tableview moves up along with it, so it looks to the user as one single unit
 
 Now to get the Header view to shrink in height continuously as the user is scrolling up, we have to use the kvo on contentOffset as scrollviewDidScroll vends very large increments of change in the offset
 
 Since there is one KVO funnel method, so to implement SRP and OCP principle, have put that logic into HeaderViewReduceHeightAtScrollUpDelegate class so that when the user wants to know of how to change height during scroll, he looks at only this class. Also this class encapsuates all logic for just the height reduction so it's closed for change
 
 Views are defined in Storyboard or XIBs. So as to be able to derive as much information out of the autolayout system 

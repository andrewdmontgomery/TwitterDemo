//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/20/15.
//  Copyright © 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: User?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150.0
        tableView.estimatedSectionHeaderHeight = 150.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        if self.user == nil {
            self.user = User.currentUser
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onTapMenuBarButton(sender: UIBarButtonItem) {
        NSNotificationCenter.defaultCenter().postNotificationName(kUserDidPressMenuBarButton, object: nil)
    }

    // MARK: - TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileTableViewCell

        cell.user = self.user
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! ProfileHeaderTableViewCell
        
        headerCell.user = self.user
        
        return headerCell
    }
    
}

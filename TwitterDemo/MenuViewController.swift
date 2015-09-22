//
//  MenuViewController.swift
//  TwitterDemo
//
//  Created by Andrew Montgomery on 9/20/15.
//  Copyright © 2015 Andrew Montgomery. All rights reserved.
//

import UIKit

let kMenuTableViewCellIdentifier = "MenuTableViewCell"

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var profileNavigationController: UIViewController!
    private var tweetsNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    private var loginViewController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileNavigationController = AppDelegate.storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        tweetsNavigationController = AppDelegate.storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationControlller")
        mentionsNavigationController = AppDelegate.storyboard.instantiateViewControllerWithIdentifier("MentionsNavigationController")
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        hamburgerViewController.contentViewController = tweetsNavigationController
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

    // MARK: - TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kMenuTableViewCellIdentifier) as! MenuTableViewCell
        
//        let navController = viewControllers[indexPath.row] as! UINavigationController
//        let viewController = navController.viewControllers.first
//        if let cellTitle = viewController?.title {
//            cell.menuTitleLabel.text = cellTitle
//        }
        
        let titles = ["Profile", "Timeline", "Mentions", "Sign Out"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    // MARK: TableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
//            let profileNavController = profileNavigationController as! UINavigationController
//            let profileViewController = profileNavController.viewControllers.first as! ProfileViewController
//            profileViewController.user = User.currentUser
            //hamburgerViewController.contentViewController = profileViewController
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        case 3:
            User.currentUser?.logout()
        default:
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        }
//        if indexPath.row < 3 {
//            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
//        } else {
//            User.currentUser?.logout()
//        }
        
    }

}

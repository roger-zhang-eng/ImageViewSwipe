//
//  TabBarControlHelper.swift
//  ImageViewSwipe
//
//  Created by Roger Zhang on 2/2/17.
//  Copyright © 2017 Roger.Zhang. All rights reserved.
//
import UIKit
import Foundation

class TabBarControlHelper  {
    
    static let sharedInstance = TabBarControlHelper()
    var tabBarRef: UITabBarController?
    
    func currentIndex() -> Int {
        return  self.tabBarRef!.selectedIndex
    }
    
    func setDisplayView(index: Int) {
        self.tabBarRef!.selectedIndex = index
    }
    
    func setTabBarRef(ref: UITabBarController) {
        self.tabBarRef = ref
    }
    
    func getTabBarHeight() -> CGFloat {
        return tabBarRef!.tabBar.bounds.height
    }
    
    //display return true, hidden return false
    func checkDisplay() -> Bool {
        return !tabBarRef!.tabBar.isHidden
    }
    
    func hideTabBar() {
        guard self.tabBarRef != nil else {
            return
        }
        
        self.tabBarRef!.tabBar.isHidden = true
    }
    
    func showTabBar() {
        guard self.tabBarRef != nil else {
            return
        }
        
        self.tabBarRef!.tabBar.isHidden = false
    }
    
    func showTodayBarNumber(number: Int) {
        if number > 0 {
            self.tabBarRef!.tabBar.items!.first!.badgeValue = String(number)
        } else {
            self.tabBarRef!.tabBar.items!.first!.badgeValue = nil
        }
    }
}

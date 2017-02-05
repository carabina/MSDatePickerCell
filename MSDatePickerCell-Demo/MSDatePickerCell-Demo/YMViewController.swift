//
//  YMViewController.swift
//  MSDatePickerCell-Demo
//
//  Created by 須藤 将史 on 2017/02/06.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit

class YMViewController: UITableViewController {
    
    private var birthday: Birthday
    
    init(birthday: Birthday) {
        self.birthday = birthday
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "YM"
        self.tableView = UITableView.init(frame: self.view.frame, style: .grouped)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            if indexPath.row == 0 {
                
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "value1")
                cell.textLabel?.text = NSLocalizedString("Birthday", comment: "")
                
                if let birthday = self.birthday.ymDate {
                    
                    cell.detailTextLabel?.text = birthday.string(format: NSLocalizedString("MMMM, yyyy", comment: ""))
                    cell.detailTextLabel?.textColor = UIColor.tint()
                    
                } else {
                    
                    cell.detailTextLabel?.text = NSLocalizedString("not set", comment: "")
                    cell.detailTextLabel?.textColor = .black
                }
                
                return cell
                
            } else {
                
                let cell = MSDatePickerCell(style: .YM) { (date: Date) in
                    self.birthday.ymDate = date
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                }
                
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            
            if indexPath.row == 0 {
                return UITableViewAutomaticDimension
            } else {
                return MSDatePickerCell.preferredHeight()
            }
            
        default:
            return UITableViewAutomaticDimension
        }
    }
}

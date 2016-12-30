//
//  MissionCategoryTableViewController.swift
//  init
//
//  Created by Atsuo Yonehara on 2016/12/25.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class MissionCategoryTableViewController: UITableViewController {
    var categorys : [Category] = []
    
    @IBAction func addButton(_ sender: UIButton) {
    }
    @IBAction func reroadButton(_ sender: UIButton) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaultsHelper.isLogin() {
            // to login
            let storyboard = UIStoryboard(name: "RegisterViewController", bundle: nil)
            guard let nextVC = storyboard.instantiateInitialViewController() else {
                print("Failed to instantiate view controller")
                return
            }
            nextVC.modalTransitionStyle = .flipHorizontal
            self.present(nextVC, animated: true, completion: nil)
            return
        }
        getCategoryLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCategoryLists()
    }
    
    func getCategoryLists() {
        
        let headers: HTTPHeaders = [
            "Authorization":UserDefaultsHelper.getToken(),
            "Accept": "application/json"
        ]
        
        Alamofire.request("https://init-api.elzup.com/v1/categories", headers:headers)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                self.categorys.removeAll()
                json.forEach { (_, json) in
                    self.categorys.append(Category(json: json))
                }
                self.tableView.reloadData()
        }
    }
}

// MARK: UITableViewDataSource method

extension MissionCategoryTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        guard let categoryCell = cell as? MissionCategoryTableViewCell else {
            return cell
        }
        categoryCell.categoryLabel.text = categorys[indexPath.row].categoryName
        return categoryCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MissionListTableViewController", bundle: nil)
        let missionListController = storyboard.instantiateInitialViewController()
        guard let secondViewController = missionListController as? MissionListTableViewController else {
            return
        }
        let category = categorys[indexPath.row]
        secondViewController.category = category
        navigationController?.pushViewController(secondViewController, animated: true)
    }
}

//
//  MissionEditController.swift
//  init
//
//  Created by Atsuo on 2016/11/09.
//  Copyright © 2016年 Atsuo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MissionEditController: UIViewController {
    var mission: Mission?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let m = mission else {
            return
        }
        titleTextField.text = m.title
        descriptionTextView.text = m.description
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func changeMission() {
        guard let m = mission else {
            return print("mission is nill")
        }
        let parameters: Parameters = [
            "title":titleTextField.text!,
            "description":descriptionTextView.text!
        ]
        let headers: HTTPHeaders = [
            "Authorization":UserDefaultsHelper.getToken(),
            "Accept": "application/json"
        ]
        let str = m.id.description
        Alamofire.request("https://init-api.elzup.com/v1/missions/"+str,
                          method: .put, parameters:parameters, headers:headers)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                m.title = json["title"].stringValue
                m.description = json["description"].stringValue
        }
    }
    func deleteMission() {
        guard let m = mission else {
            return print("mission is nill")
        }
        let headers: HTTPHeaders = [
            "Authorization":UserDefaultsHelper.getToken(),
            "Accept": "application/json"
        ]
        let str = m.id.description
        Alamofire.request("https://init-api.elzup.com/v1/missions/"+str,
                          method: .delete, headers:headers)
            .responseJSON { response in
        }
    }
    @IBAction func changeButton(_ sender: UIButton) {
        changeMission()
        let storyboard = UIStoryboard(name: "MissionDetailController", bundle: nil)
        let missionDetailController = storyboard.instantiateInitialViewController()
        guard let secondViewController = missionDetailController as? MissionDetailController else {
            return
        }
        secondViewController.mission = self.mission
        _=self.navigationController?.popViewController(animated: true)
    }
    @IBAction func notChangeButton(_ sender: UIButton) {
        _=self.navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteButton(_ sender: UIButton) {
        deleteMission()
        _=navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
    }
}

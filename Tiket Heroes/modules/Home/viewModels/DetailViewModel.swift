//
//  DetailViewModel.swift
//  Tiket Heroes
//
//  Created by Rafly Prayogo on 18/12/20.
//

import Foundation
import Alamofire
import UIKit

class DetailViewModel {

    var dataModel       = HomeModel()
    
    func fetchData(_ sender: DetailViewController){
        sender.nameLbl.text         = dataModel.localizedName ?? ""
        sender.rolesLbl.text        = dataModel.roles?.joined(separator: ",")
        sender.attackLbl.text       = String(dataModel.baseAttackMin ?? 0) + "-" + String(dataModel.baseAttackMax ?? 0)
        sender.armorLbl.text        = String(dataModel.baseArmor ?? 0.0)
        sender.speedLbl.text        = String(dataModel.moveSpeed ?? 0)
        sender.healthLbl.text       = String(dataModel.baseHealth ?? 0)
        sender.manaLbl.text         = String(dataModel.baseMana ?? 0)
        sender.attrLbl.text         = dataModel.primaryAttr ?? ""
        
        sender.thumbIv.af_setImage(withURL: URL(string: URLConfig.BASE_URL + (dataModel.img ?? AppConfig.DEF_FAIL_IMG))!, placeholderImage: UIImage(named: "placeholder"))
        sender.thumbIv.roundCorners([.topLeft, .topRight], radius: AppConfig.ROUND_CARDVIEW)
    }

}

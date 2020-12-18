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
    
    var reloadData          = {() -> () in }
    var dataModel           = HomeModel()
    var dataRaw             = [HomeModel]()
    var dataModelSimilar    = [HomeModel](){
        didSet{
            reloadData()
        }
    }
    
    func fetchData(_ sender: DetailViewController){
        sender.nameLbl.text         = dataModel.localizedName ?? ""
        sender.rolesLbl.text        = dataModel.roles?.joined(separator: ",")
        sender.attackLbl.text       = String(dataModel.baseAttackMin ?? 0) + "-" + String(dataModel.baseAttackMax ?? 0)
        sender.armorLbl.text        = String(dataModel.baseArmor ?? 0.0)
        sender.speedLbl.text        = String(dataModel.moveSpeed ?? 0)
        sender.healthLbl.text       = String(dataModel.baseHealth ?? 0)
        sender.manaLbl.text         = String(dataModel.baseMana ?? 0)
        
        let attr                    = dataModel.primaryAttr ?? ""
        sender.attrLbl.text         = attr
        
        sender.thumbIv.af_setImage(withURL: URL(string: URLConfig.BASE_URL + (dataModel.img ?? AppConfig.DEF_FAIL_IMG))!, placeholderImage: UIImage(named: "placeholder"))
        sender.thumbIv.roundCorners([.topLeft, .topRight], radius: AppConfig.ROUND_CARDVIEW)
        
        var similar                 = [HomeModel]()
        if(attr == "agi"){
            similar                 = dataRaw.sorted{ $0.moveSpeed ?? 0 > $1.moveSpeed ?? 0 }
        }else if(attr == "str"){
            similar                 = dataRaw.sorted{ $0.baseAttackMax ?? 0 > $1.baseAttackMax ?? 0 }
        }else if(attr == "int"){
            similar                 = dataRaw.sorted{ $0.baseMana ?? 0 > $1.baseMana ?? 0 }
        }
        var i = 0
        for sim in similar {
            dataModelSimilar.append(sim)
            if(i == 2){
                break
            }
            i+=1
        }
    }
    
    func fetchHeroesCell(_ sender: DetailViewController, _ indexPath: IndexPath, _ reusableCell: UICollectionViewCell){
        if let cell = reusableCell as? SimilarCollCell {
            let model               = dataModelSimilar[indexPath.row]
            
            cell.thumbIv.af_setImage(withURL: URL(string: URLConfig.BASE_URL + (model.img ?? AppConfig.DEF_FAIL_IMG))!, placeholderImage: UIImage(named: "placeholder"))
            cell.thumbIv.roundCorners([.topLeft, .topRight], radius: AppConfig.ROUND_CARDVIEW)
            
            cell.cardView.customRoundedView(radius: AppConfig.ROUND_CARDVIEW)
            cell.cardView.dropShadow(radius: AppConfig.CARD_SHADOW)
            cell.nameLbl.text       = model.localizedName ?? ""
        }
    }

}

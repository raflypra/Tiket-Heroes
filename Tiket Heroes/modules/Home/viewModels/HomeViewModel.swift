//  
//  HomeViewModel.swift
//  Tiket Heroes
//
//  Created by Rafly Prayogo on 18/12/20.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class HomeViewModel {

    var reloadData      = {() -> () in }
    var reloadFilter    = {() -> () in }
    
    var dataRaw         = [HomeModel]()
    
    var dataModel       = [HomeModel](){
        didSet{
            reloadData()
        }
    }
    
    var dataModelFilter = [String](){
        didSet{
            reloadFilter()
        }
    }
    
    func fetchFilterCell(_ sender: HomeViewController, _ indexPath: IndexPath, _ reusableCell: UITableViewCell){
        if let cell = reusableCell as? FilterTableCell {
            let model               = dataModelFilter[indexPath.row]
            cell.filterLbl.text     = model
            
            if(sender.filter == model){
                cell.cardView.backgroundColor   = .red
            }else{
                cell.cardView.backgroundColor   = .darkGray
            }
            
            cell.cardView.customRoundedView(radius: AppConfig.ROUND_CARDVIEW)
            cell.cardView.dropShadow(radius: AppConfig.CARD_SHADOW)
        }
    }
    
    func fetchHeroesCell(_ sender: HomeViewController, _ indexPath: IndexPath, _ reusableCell: UICollectionViewCell){
        if let cell = reusableCell as? HeroesCollCell {
            let model               = dataModel[indexPath.row]
            
            cell.thumbIv.af_setImage(withURL: URL(string: URLConfig.BASE_URL + (model.img ?? AppConfig.DEF_FAIL_IMG))!, placeholderImage: UIImage(named: "placeholder"))
            cell.thumbIv.roundCorners([.topLeft, .topRight], radius: AppConfig.ROUND_CARDVIEW)
            
            cell.cardView.customRoundedView(radius: AppConfig.ROUND_CARDVIEW)
            cell.cardView.dropShadow(radius: AppConfig.CARD_SHADOW)
            cell.nameLbl.text       = model.localizedName ?? ""
        }
    }

}

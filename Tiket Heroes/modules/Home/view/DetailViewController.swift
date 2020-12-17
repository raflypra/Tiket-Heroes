//
//  DetailViewController.swift
//  Tiket Heroes
//
//  Created by Rafly Prayogo on 18/12/20.
//

import UIKit

class DetailViewController: UIViewController {
    
    // ===== OUTLETS HERE ===== //
    @IBOutlet weak var thumbIv: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var rolesLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var armorLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var healthLbl: UILabel!
    @IBOutlet weak var manaLbl: UILabel!
    @IBOutlet weak var attrLbl: UILabel!
    @IBOutlet weak var cardView1: UIView!
    @IBOutlet weak var cardView2: UIView!
    

    // ===== VARIABLES HERE ===== //
    var viewModel       = DetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchData(self)
    }
    
    func setupUI(){
        cardView1.customRoundedView(radius: AppConfig.ROUND_CARDVIEW)
        cardView1.dropShadow(radius: AppConfig.CARD_SHADOW)
        cardView2.customRoundedView(radius: AppConfig.ROUND_CARDVIEW)
        cardView2.dropShadow(radius: AppConfig.CARD_SHADOW)
        
        setupTap()
    }
    
    func setupTap(){}
    
    

}

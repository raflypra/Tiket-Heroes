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
    @IBOutlet weak var collectionView: UICollectionView!
    

    // ===== VARIABLES HERE ===== //
    var viewModel       = DetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchData(self)
    }
    
    func setupUI(){
        collectionView.delegate      = self
        collectionView.dataSource    = self
        
        cardView1.customRoundedView(radius: AppConfig.ROUND_CARDVIEW)
        cardView1.dropShadow(radius: AppConfig.CARD_SHADOW)
        cardView2.customRoundedView(radius: AppConfig.ROUND_CARDVIEW)
        cardView2.dropShadow(radius: AppConfig.CARD_SHADOW)
        
        viewModel.reloadData = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        setupTap()
    }
    
    func setupTap(){}
    
}

extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataModelSimilar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell        = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarCollCell", for: indexPath) as! SimilarCollCell
        viewModel.fetchHeroesCell(self, indexPath, cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model       = viewModel.dataModelSimilar[indexPath.row]
        let destVc      = MainHelper.instantiateVC(.mainStoryboard, "DetailViewController") as! DetailViewController
        destVc.viewModel.dataModel  = model
        destVc.viewModel.dataRaw    = viewModel.dataRaw
        destVc.title    = model.localizedName ?? ""
        self.navigationController?.pushViewController(destVc, animated: true)
    }
    
}

class SimilarCollCell : UICollectionViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var thumbIv: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
}

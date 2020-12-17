//  
//  HomeViewController.swift
//  Tiket Heroes
//
//  Created by Rafly Prayogo on 18/12/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

    // ===== OUTLETS HERE ===== //
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    

    // ===== VARIABLES HERE ===== //
    var viewModel       = HomeViewModel()
    var progressView    = ProgressView()
    var filter          = "All"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupUI(){
        collectionView.delegate      = self
        collectionView.dataSource    = self
        MainHelper.setTableview(sender: self, tableView: tableView, false)
        
        viewModel.reloadFilter = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.reloadData = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        setupTap()
    }
    
    func setupTap(){}
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataModelFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell    = tableView.dequeueReusableCell(withIdentifier: "FilterTableCell", for: indexPath) as! FilterTableCell
        viewModel.fetchFilterCell(self, indexPath, cell)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        let model               = viewModel.dataModelFilter[indexPath.row]
        filter                  = model
        self.title              = model
        if(model == "All"){
            viewModel.dataModel = viewModel.dataRaw
        }else{
            viewModel.dataModel = viewModel.dataRaw.filter{ ($0.roles?.contains(filter) ?? false) }
        }
    }
    
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell        = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroesCollCell", for: indexPath) as! HeroesCollCell
        viewModel.fetchHeroesCell(self, indexPath, cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 172, height: 167)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model       = viewModel.dataModel[indexPath.row]
        let destVc      = MainHelper.instantiateVC(.mainStoryboard, "DetailViewController") as! DetailViewController
        destVc.viewModel.dataModel  = model
        destVc.title    = model.localizedName ?? ""
        self.navigationController?.pushViewController(destVc, animated: true)
        
    }
    
}

class FilterTableCell : UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var filterLbl: UILabel!
}

class HeroesCollCell : UICollectionViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var thumbIv: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
}



//  
//  HomeServices.swift
//  Tiket Heroes
//
//  Created by Rafly Prayogo on 18/12/20.
//

import Foundation
import Alamofire

extension HomeViewController {
    
    @objc func getData() {
        if(CacheHelper.checkIsCached()){
            fetchModel(data: CacheHelper.get())
        }else{
            progressView.show(self)
        }
        
        ReqHelper.request(URLConfig.URL_GET_HERO) { (resModel) in
            self.progressView.hide()
            if(resModel.success){
                if(!CacheHelper.checkIsCached()){
                    self.fetchModel(data: resModel.data)
                }
                CacheHelper.createSession(resModel.data)
            }
        }
    }
    
    func fetchModel(data: Data){
        do{
            self.viewModel.dataRaw      = try MainHelper.getDecoder().decode([HomeModel].self, from: data)
            self.viewModel.dataModel    = self.viewModel.dataRaw
            self.viewModel.dataModelFilter.removeAll()
            for model in self.viewModel.dataModel {
                model.roles?.forEach{
                    if(!self.viewModel.dataModelFilter.contains($0)){
                        self.viewModel.dataModelFilter.append($0)
                    }
                }
            }
            self.viewModel.dataModelFilter.append("All")
        }catch let error{
            print(error)
            AlertHelper.errJson()
        }
    }

}

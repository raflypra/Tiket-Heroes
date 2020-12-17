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
        progressView.show(self)
        ReqHelper.request(URLConfig.URL_GET_HERO) { (resModel) in
            self.progressView.hide()
            if(resModel.success){
                do{
                    self.viewModel.dataRaw      = try MainHelper.getDecoder().decode([HomeModel].self, from: resModel.data)
                    self.viewModel.dataModel    = self.viewModel.dataRaw
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
    }

}

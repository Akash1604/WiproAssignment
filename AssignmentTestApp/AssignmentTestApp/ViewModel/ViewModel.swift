//
//  ViewModel.swift
//  AssignmentTestApp
//
//  Created by akash on 26/02/20.
//  Copyright © 2020 akash. All rights reserved.
//

import Foundation

class ViewModel:NSObject{
    var response = PostData()
    var canadaDetail = [CanadaDetails]()
    override init() {
        super.init()
    }
    
    func getCanadaDetail(response:PostData) {
        for row in response.rows! {
            self.canadaDetail.append(row)
        }
    }
}

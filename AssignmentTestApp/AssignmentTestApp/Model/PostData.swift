//
//  PostData.swift
//  AssignmentTestApp
//
//  Created by akash on 26/02/20.
//  Copyright © 2020 akash. All rights reserved.
//

import Foundation

public struct PostData: Codable {
    var title: String?
    var rows: [CanadaDetails]?
}
struct CanadaDetails: Codable {
    var title: String?
    var description: String?
    var imageHref: String?
}

//
//  ListTableView.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import UIKit

class MovieListTableView: UITableView {

    static let identifier = UUID().uuidString
    
    init() {
        super.init(frame: .infinite, style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

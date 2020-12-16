//
//  CategorySelectionView.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 14/12/20.
//

import UIKit

protocol CategorySelectionViewDelegate {
    func categorySelectionView(didTap superview: UIView)
}

class CategorySelectionView: UIView {
    
    // MARK: - Properties
    var delegate: CategorySelectionViewDelegate?
    
    // MARK: - UI Components
    private lazy var categoryContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setRoundedCorners([.topLeft,.topRight], withRadius: 15)
        return view
    }()
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .shadowBackgroundColor
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.onSuperviewDidTap(_:))
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    private lazy var heightConstraint = self.categoryContainerView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var categorySelectionTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(
            CategorySelectionTableViewCell.self,
            forCellReuseIdentifier: CategorySelectionTableViewCell.identifier
        )
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Initializers
    init() {
        super.init(frame: .infinite)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        self.addSubview(self.backgroundView)
        self.addSubview(self.categoryContainerView)
        self.categoryContainerView.addSubview(self.categorySelectionTableView)
        
        NSLayoutConstraint.activate([
            self.backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.categoryContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.categoryContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.categoryContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.heightConstraint,
  
            self.categorySelectionTableView.leadingAnchor.constraint(equalTo: self.categoryContainerView.leadingAnchor, constant: 20),
            self.categorySelectionTableView.trailingAnchor.constraint(equalTo: self.categoryContainerView.trailingAnchor, constant: -20),
            self.categorySelectionTableView.bottomAnchor.constraint(equalTo: self.categoryContainerView.bottomAnchor, constant: -20),
            self.categorySelectionTableView.topAnchor.constraint(equalTo: self.categoryContainerView.topAnchor, constant: 20),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc Functions
    @objc private func onSuperviewDidTap(_ sender: UITapGestureRecognizer) {
        if let view = sender.view {
            delegate?.categorySelectionView(didTap: view)
        }
    }
    
    // MARK: - Public Functions
    func setUITableViewDelegate(_ delegate: UITableViewDelegate) {
        self.categorySelectionTableView.delegate = delegate
    }
    
    func setUITableViewDataSource(_ dataSource: UITableViewDataSource) {
        self.categorySelectionTableView.dataSource = dataSource
    }
    
    func reloadTableView() {
        self.categorySelectionTableView.reloadData()
    }
    
    // MARK: - Private Functions
    func show() {
        self.heightConstraint.constant = 250
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func hide() {
        self.heightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.alpha = 0
        }
    }
    
    
}

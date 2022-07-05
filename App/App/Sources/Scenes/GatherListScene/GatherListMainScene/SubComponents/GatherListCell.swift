//
//  GatherListCell.swift
//  App
//
//  Created by 김나희 on 6/9/22.
//

import UIKit

final class GatherListCell: UITableViewCell {
    private let tags: [String] = ["말티즈 외 2종", "소형견", "여성 Only", "4-5명", "코커스파이넬", "말티즈 외 6종"] // 임시 데이터

    private lazy var categoryLabel: PaddingLabel = {
        let label = PaddingLabel(padding: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0))
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.backgroundColor = .Togaether.mainGreen
        label.text = "카테고리"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .Togaether.divider
        label.text = "00/00"
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = .Togaether.primaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 제목"
        label.textColor = .Togaether.primaryLabel
        label.font = UIFont.boldSystemFont(ofSize: 16)

        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 장소 주소"
        label.textColor = .Togaether.secondaryLabel
        label.font = UIFont.systemFont(ofSize: 12)

        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12월 31일(월)"
        label.textColor = .Togaether.mainGreen
        label.font = UIFont.boldSystemFont(ofSize: 14)

        return label
    }()
    
    private lazy var divisionView: UIView = {
        let view = UIView()
        view.backgroundColor = .Togaether.line
        
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "오후 10시 30분 - 12시"
        label.textColor = .Togaether.primaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var hostProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var hostNickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "호스트 닉네임"
        label.textColor = .Togaether.primaryLabel
        label.font = UIFont.systemFont(ofSize: 14)

        return label
    }()
    
    private lazy var tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerCell(type: TagCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        configureLayout()
        configureUI()
    }
    
    private func addSubviews() {
        addSubview(categoryLabel)
        addSubview(countLabel)
        addSubview(titleLabel)
        addSubview(addressLabel)
        addSubview(dateLabel)
        addSubview(divisionView)
        addSubview(timeLabel)
        addSubview(hostProfileImageView)
        addSubview(hostNickNameLabel)
        addSubview(tagCollectionView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.useAndActivateConstraints([
            categoryLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 14.0),
            categoryLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            categoryLabel.heightAnchor.constraint(equalToConstant: 18.0),
            
            countLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 37.0),
            countLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            countLabel.widthAnchor.constraint(equalToConstant: 55.0),
            countLabel.heightAnchor.constraint(equalToConstant: 55.0),
            
            titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12.0),
            titleLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -14.0),
            
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.0),
            addressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -14.0),
            
            dateLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12.0),
            dateLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor),

            divisionView.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 8.0),
            divisionView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            divisionView.widthAnchor.constraint(equalToConstant: 1.0),
            divisionView.heightAnchor.constraint(equalToConstant: 12.0),
            
            timeLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: divisionView.trailingAnchor, constant: 8.0),
            timeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            
            hostProfileImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16.0),
            hostProfileImageView.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor),
            hostProfileImageView.widthAnchor.constraint(equalToConstant: 28.0),
            hostProfileImageView.heightAnchor.constraint(equalToConstant: 28.0),
            
            hostNickNameLabel.leadingAnchor.constraint(equalTo: hostProfileImageView.trailingAnchor, constant: 8.0),
            hostNickNameLabel.centerYAnchor.constraint(equalTo: hostProfileImageView.centerYAnchor),
            
            tagCollectionView.topAnchor.constraint(equalTo: hostProfileImageView.bottomAnchor, constant: 16.0),
            tagCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tagCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tagCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -22)
            ])
    }
    
    private func configureUI() {
        backgroundColor = .Togaether.background
        selectionStyle = .none
    }
}

extension GatherListCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(withType: TagCollectionViewCell.self, for: indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureData(tags[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = tags[safe: indexPath.row] else {
            return CGSize(width: 0, height: 0)
        }
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)
        ])
        
        return CGSize(width: itemSize.width + 18, height: 18)
    }
    
}
//
//  DeliveryTableViewCell.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 01/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import AlamofireImage

class DeliveryTableViewCell: UITableViewCell {

    private let deliveryView: DeliveryView = {
        let view = DeliveryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
     }

     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(deliveryView)
        deliveryView.dropShadow()
        addConstraints()
        let padding = GlobalConstants.defaultSidePadding * 2 + DeliveryView.Constants.profileImageViewSize.width
        separatorInset = UIEdgeInsets.init(top: 0, left: padding, bottom: 0, right: 0)
    }

    private func addConstraints() {
        deliveryView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        deliveryView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        deliveryView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        deliveryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

// MARK: - Exposed Methods
extension DeliveryTableViewCell {
    func update(text: String?, imageUrl: String?) {
        deliveryView.update(text: text, imageUrl: imageUrl)
    }
}

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

    struct LayoutConstants
    {
        static var profileImageViewSize: CGSize { return CGSize.init(width: 52, height: 52) }
    }
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .darkGray
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = Constants.defautlCornerRadius
        img.clipsToBounds = true
       return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
     }
    
     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup()
    {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        addConstraints()
    }
    
    func addConstraints() {
        let views: [String: Any] = [
            "deliveryImageView": profileImageView,
            "deliveryLabel": nameLabel,
            "superview": contentView]

        var allConstraints: [NSLayoutConstraint] = []

        let horizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[deliveryImageView(80)]-10-[deliveryLabel]-10-|",
            metrics: nil,
            views: views)
        allConstraints += horizontalConstraint

        let imageVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(>=10)-[deliveryImageView(80)]-(>=10)-|",
            metrics: nil,
            views: views)
        allConstraints += imageVerticalConstraint

        let labelVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[deliveryLabel]-10-|",
            metrics: nil,
            views: views)
        allConstraints += labelVerticalConstraint

        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        contentView.addConstraints(allConstraints)
    }
    
    func update(text: String?, imageUrl: String?){
        nameLabel.text = text
        if let imageUrl = imageUrl, let url = URL.init(string: imageUrl) {
            profileImageView.af_setImage(
                withURL: url,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )
        }
    }
}

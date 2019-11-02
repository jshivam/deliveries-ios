//
//  DeliveryView.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 01/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import AlamofireImage

class DeliveryView: UIView {

    struct LayoutConstants {
        static var profileImageViewSize: CGSize { return CGSize.init(width: 52, height: 52) }
    }

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let profileImageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .darkGray
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = Constants.defautlCornerRadius
        img.clipsToBounds = true
       return img
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        addSubview(profileImageView)
        addSubview(descriptionLabel)
        addConstraints()
    }

    func addConstraints() {
        let views: [String: Any] = [
            "profileImageView": profileImageView,
            "descriptionLabel": descriptionLabel,
            "superview": self]

        var allConstraints: [NSLayoutConstraint] = []

        let metrics = ["profileImageViewHeight": LayoutConstants.profileImageViewSize.height,
                       "profileImageViewWidth": LayoutConstants.profileImageViewSize.width,
                       "padding": Constants.defaultSidePadding]

        let horizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-padding-[profileImageView(profileImageViewWidth)]-padding-[descriptionLabel]-padding-|",
            metrics: metrics,
            views: views)
        allConstraints += horizontalConstraint

        let imageVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-padding-[profileImageView(profileImageViewHeight)]-(>=padding)-|",
            metrics: metrics,
            views: views)
        allConstraints += imageVerticalConstraint

        let labelVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-padding-[descriptionLabel]-padding-|",
            metrics: metrics,
            views: views)
        allConstraints += labelVerticalConstraint

        descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        addConstraints(allConstraints)
    }

    func update(text: String?, imageUrl: String?) {
        descriptionLabel.text = text
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

//
//  DeliveryView.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import AlamofireImage

class DeliveryView: UIView {

    struct Constants {
        static let profileImageViewSize: CGSize = CGSize.init(width: 52, height: 52)
        static let labelFontSize: CGFloat = 16
        static let animationDuration: TimeInterval = 0.2
    }

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        label.textColor = .titleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

   private  let profileImageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .darkGray
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = GlobalConstants.defautlCornerRadius
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

    private func setup() {
        addSubview(profileImageView)
        addSubview(descriptionLabel)
        addConstraints()
    }

    private func addConstraints() {
        let views: [String: Any] = [
            "profileImageView": profileImageView,
            "descriptionLabel": descriptionLabel,
            "superview": self]

        var allConstraints: [NSLayoutConstraint] = []

        let metrics = ["profileImageViewHeight": Constants.profileImageViewSize.height,
                       "profileImageViewWidth": Constants.profileImageViewSize.width,
                       "padding": GlobalConstants.defaultSidePadding]

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
}

// MARK: - Exposed Methods
extension DeliveryView {

    func update(text: String?, imageUrl: String?) {
        descriptionLabel.text = text
        if let imageUrl = imageUrl, let url = URL.init(string: imageUrl) {
            profileImageView.af_setImage(
                withURL: url,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .crossDissolve(Constants.animationDuration)
            )
        }
    }
}

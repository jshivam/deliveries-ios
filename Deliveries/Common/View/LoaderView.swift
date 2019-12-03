//
//  LoaderVIew.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 03/12/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView.init(style: .gray)
        loader.color = .loaderColor
        loader.startAnimating()
        return loader
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(loader)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loader.frame = self.bounds
    }

    var preferredHeight: CGFloat {
        let height = 2 * GlobalConstants.defaultSidePadding + loader.intrinsicContentSize.height
        return height
    }
}

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

    let deliveryView: DeliveryView = {
        let view = DeliveryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
     }
    
     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        contentView.addSubview(deliveryView)
        addConstraints()
    }
    
    func addConstraints() {
        deliveryView.topAnchor.constraint(equalTo:contentView.topAnchor).isActive = true
        deliveryView.leftAnchor.constraint(equalTo:contentView.leftAnchor).isActive = true
        deliveryView.rightAnchor.constraint(equalTo:contentView.rightAnchor).isActive = true
        deliveryView.bottomAnchor.constraint(equalTo:contentView.bottomAnchor).isActive = true
    }
    
    func update(text: String?, imageUrl: String?){
        deliveryView.update(text: text, imageUrl: imageUrl)
    }
}

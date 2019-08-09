//
//  ButtonTableViewCell.swift
//  ShopList
//
//  Created by Mitch Merrell on 8/9/19.
//  Copyright © 2019 Mitch Merrell. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate {
    func buttonTapped(_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    var delegate: ButtonTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateButton(_ isComplete: Bool) {
        let buttonImageState = isComplete ? "complete" : "incomplete"
        completeButton.setImage(UIImage(named: buttonImageState), for: .normal)
    }

    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.buttonTapped(self)
    }
}

extension ButtonTableViewCell {
    func update(withItem item: Item) {
        nameLabel.text = item.name
        updateButton(item.isComplete)
    }
}

//
//  PlayerTableViewCell.swift
//  Bizingo
//
//  Created by Mateus Rodrigues on 10/02/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PlayerTableViewCell {
    public func configure(with player: Player) {
        self.nicknameLabel.text = player.name
        self.statusView.backgroundColor = player.number == 0 ? .systemBlue : .systemRed
        self.statusView.alpha = player.isConnected ? 1.0 : 0.5
    }
    
}

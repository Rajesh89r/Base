//
//  BLPaymentCell.swift
//  Bridge LLC
//
//  Created by Manojkumar on 19/03/16.
//  Copyright © 2016 Smaatone. All rights reserved.
//

import UIKit

class BLPaymentCell: UITableViewCell {

    var cardStatusLbl:UILabel!
    var cardNoLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createControls()
    }
    func createControls()
    {
        var posX = self.bounds.origin.x + 15
        var width:CGFloat = GRAPHICS.Screen_Width()/1.5//profileMaskImg.size.width/2
        var height:CGFloat = 16//profileMaskImg.size.height/2
        var posY = self.bounds.origin.y + 15
        cardStatusLbl = UILabel(frame: CGRectMake(posX, posY, width, height))
        cardStatusLbl.font = GRAPHICS.FONT_REGULAR(20)
        cardStatusLbl.textColor = UIColorFromRGB(HeaderTitleColor, alpha: 1.0)
        cardStatusLbl.text = "Active Credit Card"
        self.addSubview(cardStatusLbl)
        
        posX = posX + 5
        posY = cardStatusLbl.frame.maxY + 18
        cardStatusLbl = UILabel(frame: CGRectMake(posX, posY, width, height))
        cardStatusLbl.font = GRAPHICS.FONT_REGULAR(14)
        cardStatusLbl.textColor = UIColorFromRGB(HeaderTitleColor, alpha: 1.0)
        cardStatusLbl.text = "XXXX-XXXX-XXXX-3515"
        self.addSubview(cardStatusLbl)

        self.frame.size.height = 90;
        
        let lineImage = GRAPHICS.SETTINGS_LINE_IMAGE()
        posX = GRAPHICS.Screen_X()
        height = (lineImage?.size.height)!/6
        posY = self.frame.size.height - height
        width = GRAPHICS.Screen_Width()
        let lblLine = UIImageView(frame: CGRectMake(posX, posY, width, height))
        lblLine.image = lineImage
        self.addSubview(lblLine)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}

//
//  BLSettingsCell.swift
//  Surve
//
//  Created by Manojkumar on 29/02/16.
//  Copyright © 2016 Premkumar. All rights reserved.
//

import UIKit

class BLSettingsCell: UITableViewCell {

    var m_symbolImgView:UIImageView!
    var m_mainTitleLbl:UILabel!
    var rightArrowImgView:UIImageView!
    
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
//        let profileMaskImg = GRAPHICS.SEARCH_PROFILE_MASK_IMAGE()
        self.frame.size.height = 80
        var posX = self.bounds.origin.x + 30
        var width:CGFloat = 10//profileMaskImg.size.width/2
        var height:CGFloat = 15//profileMaskImg.size.height/2
        var posY = (self.frame.size.height - height)/2
        var fontSize:CGFloat!
        
        if GRAPHICS.Screen_Type() == IPHONE_4 || GRAPHICS.Screen_Type() == IPHONE_5
        {
            fontSize = 14
        }
        else if GRAPHICS.Screen_Type() == IPHONE_6
        {
            fontSize = 16
        }
        else
        {
            fontSize = 16
        }
        
        m_symbolImgView = UIImageView(frame: CGRectMake(posX, posY, width, height))
        self.addSubview(m_symbolImgView)
        
        
        posX = m_symbolImgView.frame.maxX + 10
        width = 50
        height = 20
        posY = (self.frame.size.height - height)/2
        m_mainTitleLbl = UILabel(frame: CGRectMake(posX, posY, width, height))
        m_mainTitleLbl.font = GRAPHICS.FONT_REGULAR(fontSize)
        m_mainTitleLbl.textColor = UIColor.init(red: 49.0/255.0, green: 72.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        self.addSubview(m_mainTitleLbl)
        
        
        
        let arrowImg = GRAPHICS.RIGHT_ARROW_IMAGE()
        width = (arrowImg?.size.width)!/4
        height = (arrowImg?.size.height)!/4
        posX = GRAPHICS.Screen_Width() - width - 25
        posY = (self.frame.size.height - height)/2
        rightArrowImgView = UIImageView(frame: CGRectMake(posX, posY, width, height))
        rightArrowImgView.image = arrowImg
        self.addSubview(rightArrowImgView)
        
        let lineImage = GRAPHICS.SETTINGS_LINE_IMAGE()
        posX = GRAPHICS.Screen_X()
        height = (lineImage?.size.height)!/4
        posY = self.frame.size.height - height
        width = GRAPHICS.Screen_Width()
        let lblLine = UIImageView(frame: CGRectMake(posX, posY, width, height))
        lblLine.image = lineImage
        self.addSubview(lblLine)

        
    }
    func setTextAndImageForLabelAndImgView(lblText : String , symbolImg: UIImage)
    {
        
        m_symbolImgView.frame.size.width = symbolImg.size.width/4
        m_symbolImgView.frame.size.height = symbolImg.size.height/4
        m_symbolImgView.image = symbolImg
        m_symbolImgView.frame.origin.y = (self.frame.size.height - m_symbolImgView.frame.size.height)/2
        m_mainTitleLbl.frame.origin.x = m_symbolImgView.frame.maxY + 10
        
        m_mainTitleLbl.text = lblText
        
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

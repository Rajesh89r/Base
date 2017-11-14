//
//  ChatCustomCell.swift
//  MeetIntro
//
//  Created by DHEENA on 25/11/15.
//  Copyright © 2015 Smaat Apps and Technologies. All rights reserved.
//

import Foundation
import UIKit
import UIKit


var cellBool : String = String()

class ChatCustomCell: UITableViewCell {

    var m_UserName_Label = UILabel()
    var m_Message_Label = UILabel()
    var m_Divider_view = UIView()
    var m_arrowImageView = UIImageView()
    var m_MessagelabelBg_view = UIView()
    
     var m_ChatMessageReceivedTime_Label = UILabel()
   

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        
        
        m_UserName_Label = UILabel(frame: CGRectZero)
        m_UserName_Label.backgroundColor = UIColor.clearColor()
        m_UserName_Label.font = GRAPHICS.FONT_REGULAR(12)
        m_UserName_Label.userInteractionEnabled  = true
        m_UserName_Label.hidden = false
        m_UserName_Label.clipsToBounds = true
        self.addSubview(m_UserName_Label)
        
        m_MessagelabelBg_view = UIView(frame: CGRectZero)
        m_MessagelabelBg_view.backgroundColor = UIColor.clearColor()
        self.addSubview(m_MessagelabelBg_view)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "buttonTapped:")
        m_MessagelabelBg_view.addGestureRecognizer(longPressRecognizer)
        
        
        
        
        m_Message_Label = UILabel(frame: CGRectZero)
        m_Message_Label.font = GRAPHICS.FONT_MEDIUM(12)
        m_Message_Label.numberOfLines = 0
        m_Message_Label.layer.cornerRadius = 12
        m_Message_Label.clipsToBounds = true
        m_Message_Label.sizeToFit()
        m_Message_Label.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        m_Message_Label.textAlignment = .Left
        m_Message_Label.lineBreakMode = NSLineBreakMode.ByClipping
        m_Message_Label.backgroundColor = UIColor(red: 69.0/255, green: 129.0/255, blue: 223.0/255, alpha: 1)
        m_Message_Label.textColor = UIColor.whiteColor()
        m_MessagelabelBg_view.addSubview(m_Message_Label)
        
        m_arrowImageView = UIImageView(frame: CGRectZero)
        m_arrowImageView.backgroundColor = UIColor.clearColor()
        self.addSubview(m_arrowImageView)
        
        
        
        m_ChatMessageReceivedTime_Label = UILabel(frame: CGRectZero)
        m_ChatMessageReceivedTime_Label.font = GRAPHICS.FONT_REGULAR(9)
        m_ChatMessageReceivedTime_Label.text = "12-May-2015"
        
        m_ChatMessageReceivedTime_Label.backgroundColor = UIColor.clearColor()
        m_ChatMessageReceivedTime_Label.textColor = UIColor.blackColor()
        self.addSubview(m_ChatMessageReceivedTime_Label)

        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //print("called after bool")
        
        
        
        
        
        
    }
    
    func setControls(ReceiverString : String ,height : CGFloat,width : CGFloat, isNegotiateChat : Bool)
    {
        
        print("VIEW CHAT HEIGHT::::\(height)")
        
        if ReceiverString == "SomeOne"
        {
            
            var XPos : CGFloat = 10.0
            var  YPos : CGFloat = height-50
            var Width : CGFloat = 70.0
            var Height : CGFloat = 30
            
            
            
            m_UserName_Label.frame = CGRectMake(XPos, YPos, Width, Height)
           // m_UserName_Label.text = "Adams"
             //m_UserImg_View.layer.cornerRadius = Width/2
            
            XPos = CGRectGetMaxX(m_UserName_Label.frame)+5
            YPos = 5
            Width = width + 8
            Height = height-30
            
            m_MessagelabelBg_view.frame = CGRectMake(XPos, YPos, Width, Height)
            m_MessagelabelBg_view.backgroundColor = UIColorFromRGB(FontChatGreenColor, alpha: 1)//FontChatGreenColor
            m_Message_Label.frame = CGRectMake(4, 0, CGRectGetWidth(m_MessagelabelBg_view.frame)-8, CGRectGetHeight(m_MessagelabelBg_view.frame))
            m_Message_Label.backgroundColor = UIColor.clearColor()
            
            m_Message_Label.textColor = UIColorFromRGB(FontWhiteColor, alpha: 1)
            
            YPos = CGRectGetMaxY(m_MessagelabelBg_view.frame)
            Width = 100
            Height = 20.0
            
            if CGRectGetWidth(m_MessagelabelBg_view.frame) < 70
            {
                
                XPos = CGRectGetMinX(m_MessagelabelBg_view.frame)
                m_ChatMessageReceivedTime_Label.textAlignment = NSTextAlignment.Left
                m_MessagelabelBg_view.layer.cornerRadius = 6

                m_MessagelabelBg_view.layer.cornerRadius = 6
                
            }
            else
            {
                XPos = CGRectGetMinX(m_MessagelabelBg_view.frame)
                m_ChatMessageReceivedTime_Label.textAlignment = NSTextAlignment.Left
                m_MessagelabelBg_view.layer.cornerRadius = 10
            }
            m_ChatMessageReceivedTime_Label.frame = CGRectMake(XPos, YPos, Width, Height)
            
            XPos = CGRectGetMinX(m_MessagelabelBg_view.frame)-15
            YPos = CGRectGetMaxY(m_MessagelabelBg_view.frame)-20
            Width = 15
            Height = 15
            
            m_arrowImageView.frame = CGRectMake(XPos, YPos, Width, Height)
            m_arrowImageView.image = GRAPHICS.CHAT_GREEN_ICON_IMAGE()
            if isNegotiateChat
            {
               
                m_Message_Label.textAlignment = .Center
                 m_Message_Label.font = GRAPHICS.FONT_MEDIUM(12)
            }
            
            
            
          
        }
            
        else
            
        {
            
            var XPos : CGFloat = GRAPHICS.Screen_Width()-75
            var  YPos : CGFloat = height-50
            var Width : CGFloat = 70.0
            var Height : CGFloat = 25
            
    
            m_UserName_Label.frame = CGRectMake(XPos, YPos, Width, Height)
            //m_UserName_Label.text = "James"
            
            
            XPos = GRAPHICS.Screen_Width()-width-Width-30
            YPos = 5
            Width = width + 8
            Height = height-30
            
            m_MessagelabelBg_view.frame = CGRectMake(XPos, YPos, Width, Height)
            m_MessagelabelBg_view.backgroundColor = UIColorFromRGB(FontChatPurpleColor, alpha: 1)
            m_Message_Label.frame = CGRectMake(4, 0, CGRectGetWidth(m_MessagelabelBg_view.frame)-8, CGRectGetHeight(m_MessagelabelBg_view.frame))
            m_Message_Label.backgroundColor = UIColor.clearColor()
            m_Message_Label.textColor = UIColorFromRGB(FontWhiteColor, alpha: 1)

            
            YPos = CGRectGetMaxY(m_MessagelabelBg_view.frame)
            Width = 100
            Height = 20.0
            
            if CGRectGetWidth(m_MessagelabelBg_view.frame) < 70
            {
                XPos = CGRectGetMaxX(m_MessagelabelBg_view.frame)-Width
                
                m_MessagelabelBg_view.layer.cornerRadius = 6
            }
            else
            {
                XPos = CGRectGetMaxX(m_MessagelabelBg_view.frame)-Width
               
                m_MessagelabelBg_view.layer.cornerRadius = 10
                
            }
            
               m_ChatMessageReceivedTime_Label.frame = CGRectMake(XPos, YPos, Width, Height)
               m_ChatMessageReceivedTime_Label.textAlignment = NSTextAlignment.Right
            
            XPos = CGRectGetMaxX(m_MessagelabelBg_view.frame)
            YPos = CGRectGetMaxY(m_MessagelabelBg_view.frame)-20
            Width = 15
            Height = 15
            
            m_arrowImageView.frame = CGRectMake(XPos, YPos, Width, Height)
            m_arrowImageView.image = GRAPHICS.CHAT_PURPLE_ICON_IMAGE()
            m_UserName_Label.textAlignment = .Right
            if isNegotiateChat
            {
                
                 m_Message_Label.textAlignment = .Center
                m_Message_Label.font = GRAPHICS.FONT_MEDIUM(12)
            }
            
        }
        
        
    }
    
    
    
    
    
    
}
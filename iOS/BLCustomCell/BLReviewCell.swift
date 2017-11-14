//
//  BLReviewCell.swift
//  Bridge LLC
//
//  Created by Manojkumar on 16/03/16.
//  Copyright © 2016 Smaatone. All rights reserved.
//

import UIKit

class BLReviewCell: UITableViewCell {
    
    var nameLbl:UILabel!
    var descLbl:UILabel!
    var dateLbl:UILabel!
    var lineLbl:UILabel!
    
    let ratingDummyArray : NSMutableArray = ["NO","NO","NO","NO","NO"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
}
    
    func createControls(nameStr : String, descStr : String , dateStr : String , ratingValues: Int,Height : CGFloat)
    {
        var xPos = GRAPHICS.Screen_X() + 5
        var yPos = self.bounds.origin.y + 15
        var width = (GRAPHICS.Screen_Width()/2) - 5
        var height:CGFloat = 20
        
        
        if nameLbl != nil{
            nameLbl.removeFromSuperview()
        }
        nameLbl = UILabel(frame: CGRectMake(xPos,yPos,width,height))
        nameLbl!.textColor = UIColor.init(red: 49.0/255.0, green: 72.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        nameLbl.text = nameStr
        nameLbl.backgroundColor = UIColor.clearColor()
        nameLbl.font = GRAPHICS.FONT_REGULAR(16)
        self.addSubview(nameLbl)
        
        let stringRatr = Double(2.50)
        switch stringRatr
        {
        case 0.50:
           ratingDummyArray.replaceObjectAtIndex(0, withObject: "YES")
            break;
        case 1.00:
           ratingDummyArray.replaceObjectAtIndex(0, withObject: "NO")
            break
        case 1.50:
             ratingDummyArray.replaceObjectAtIndex(1, withObject: "YES")
            break
        case 2.00:
             ratingDummyArray.replaceObjectAtIndex(1, withObject: "NO")
            break
        case 2.50:
            ratingDummyArray.replaceObjectAtIndex(2, withObject: "YES")
            break
        case 3.00:
            ratingDummyArray.replaceObjectAtIndex(2, withObject: "NO")
            break
        case 3.50:
            ratingDummyArray.replaceObjectAtIndex(3, withObject: "YES")
            break
        case 4.00:
            ratingDummyArray.replaceObjectAtIndex(3, withObject: "NO")
            break
        case 4.50:
            ratingDummyArray.replaceObjectAtIndex(4, withObject: "YES")
            break
        case 5.00:
            ratingDummyArray.replaceObjectAtIndex(4, withObject: "NO")
            break
        default : break
            
        }
        
        
        print("DUMMY::::\(ratingDummyArray)")
        
        let starUnselImg = GRAPHICS.REVIEW_STAR_GRAY_IMAGE()
        let starSelImg = GRAPHICS.REVIEW_STAR_GREEN_IMAGE()
         let starhalfImg = GRAPHICS.REVIEW_STAR_GREEN_HALF_IMAGE()
        let controlSize = GRAPHICS.getImageWidthHeight(starSelImg!)
        width = controlSize.width
        height = controlSize.height
        xPos = (GRAPHICS.Screen_Width() - width * 5) - 10
        yPos = yPos + 0
        for var i = 1 ; i <= 5; i += 1
        {
            let ratingImgView = UIImageView(frame: CGRectMake(xPos,yPos,width,height))
            if(i <= ratingValues)
            {
                ratingImgView.image = starSelImg
                //let val = ratingDummyArray.objectAtIndex(i-1) as! String
//                if val == "YES"
//                {
//                    print("HALF::::\(i)")
//                   ratingImgView.image = starhalfImg
//                    
//                }
//                else{
                  //  ratingImgView.image = starSelImg
               // }
                
            }
            else{
            ratingImgView.image = starUnselImg
            }
            ratingImgView.tag = i
            self.addSubview(ratingImgView)
            xPos = xPos + width + 1
        }

        
        xPos = GRAPHICS.Screen_X() + 30
        yPos = nameLbl.frame.maxY + 25
        width = GRAPHICS.Screen_Width() - 60
        height = 15
        
        if descLbl != nil{
            descLbl.removeFromSuperview()
        }
        
        descLbl = UILabel(frame: CGRectMake(xPos,yPos,width,height))
        descLbl!.textColor = UIColor.init(red: 49.0/255.0, green: 72.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        descLbl.font = GRAPHICS.FONT_REGULAR(14)
        descLbl.text = descStr
        descLbl.numberOfLines = 0
        descLbl.backgroundColor = UIColor.clearColor()
        descLbl.sizeToFit()
        descLbl.lineBreakMode = .ByWordWrapping
        self.addSubview(descLbl)

        width = GRAPHICS.Screen_Width()/4
        height = 20
        xPos = GRAPHICS.Screen_Width() - width - 10
        yPos = descLbl.frame.maxY+5
        
        
        if dateLbl != nil{
            dateLbl.removeFromSuperview()
        }
        dateLbl = UILabel(frame: CGRectMake(xPos,yPos,width,height))
        dateLbl!.textColor = UIColor.init(red: 49.0/255.0, green: 72.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        
        
        
        //dateStr = dateStr.substringToIndex(<#T##index: Index##Index#>)
        
        if dateStr.characters.count > 0
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let startDate = dateFormatter.dateFromString(dateStr)
            
            
            dateFormatter.dateFormat = "dd-MM-YY"
            
            if startDate != nil{
                let matchsstatStr = dateFormatter.stringFromDate(startDate!)
                
               dateLbl.text  = matchsstatStr
            }
            
        }
        
        
        dateLbl.textAlignment = .Right
        dateLbl.font = GRAPHICS.FONT_REGULAR(12)
        self.addSubview(dateLbl)
        
        
        
        width = GRAPHICS.Screen_Width()
        height = 1
        xPos = 0
        yPos = Height-1

        if lineLbl != nil{
            lineLbl.removeFromSuperview()
        }
        
        lineLbl = UILabel(frame: CGRectMake(xPos,yPos,width,height))
        lineLbl.backgroundColor = UIColorFromRGB(FontChatGreenColor, alpha: 1.0)
        
        self.addSubview(lineLbl)
        
        self.frame.size.height = lineLbl.frame.maxY
        
        print("SELF  HEIGHT::\(self.frame.size.height )")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

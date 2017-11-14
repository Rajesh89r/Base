//
//  BLEnterVerifyCodeViewController.swift
//  Bridge LLC
//
//  Created by Dheena on 3/16/16.
//  Copyright © 2016 Smaatone. All rights reserved.
//

import Foundation
import UIKit
import UIKit

class BLEnterVerifyCodeViewController : BLBaseViewController,ServerAPIDelegate
{
    
    var  vw_For_base = UIView()
    var verificationCode_Txt_Label = UILabel()
    var code_Label = UILabel()
    var  vw_For_Btn = UIView()
    var lineView_Above_Button = UIView()
    var btnContinue_For_Chat = UIButton()
    
    var btnOne = UIButton()
    var btnTwo = UIButton()
    var btnThree = UIButton()
    var btnFour = UIButton()
    var tappedCount = 0
    var vwValidation:UIView?
    var uniqueCodeTypedStr = NSMutableString()
    
    var isVerifiedSuccess = false
    
    var itemEntity = BLGoodsItemEntity(dic: NSMutableDictionary())
    
    override  func viewDidLoad()
    {
        super.viewDidLoad()
        self.lblTitle?.text = INSPECTMODE_TITLE.uppercaseString
        
        var cgSize = GRAPHICS.getImageWidthHeight(GRAPHICS.SIGNIN_BACK()!)
        var Width:CGFloat = (cgSize.width)
        var Height:CGFloat = (cgSize.height)
        var YPos:CGFloat = 40.0
        var XPos:CGFloat = 10.0
        
        
        cgSize = GRAPHICS.getImageWidthHeight(GRAPHICS.ENTERED_CODE_RESET_ICON_IMAGE()!)
        Width = (cgSize.width)+5
        Height = (cgSize.height)
        YPos = 40.0
        XPos = GRAPHICS.Screen_Width() - (Width + 10.0)
        
        self.rightBtn.frame = CGRectMake(XPos, YPos, Width, Height)
        self.rightBtn.setBackgroundImage(GRAPHICS.ENTERED_CODE_RESET_ICON_IMAGE(), forState: UIControlState.Normal)
        
        Width = leftBtn.frame.size.width + 10.0
        Height = leftBtn.frame.size.height + 10.0
        YPos = leftBtn.frame.origin.y - 5.0
        XPos =  leftBtn.frame.origin.x - 5.0
        
        Width = rightBtn.frame.size.width + 10.0
        Height = rightBtn.frame.size.height + 10.0
        YPos = rightBtn.frame.origin.y - 5.0
        XPos =  rightBtn.frame.origin.x - 5.0
        self.rightSideBigBtn.frame = CGRectMake(XPos, YPos, Width, Height)
        
        rightBtn.addTarget(self, action: #selector(BLEnterVerifyCodeViewController.resetBtnAction), forControlEvents: .TouchUpInside)
        rightSideBigBtn.addTarget(self, action: #selector(BLEnterVerifyCodeViewController.resetBtnAction), forControlEvents: .TouchUpInside)
        
        createControls()
        
        self.moveCurveToFront()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        resetBtnAction()
    }
    
    func createControls()
    {
        
        var XPos : CGFloat = 0
        var YPos:CGFloat = 0.0
        
        
        //var GAP:CGFloat = 0.0
        
               var Width : CGFloat = CGRectGetWidth(self.view.frame)
        var Height : CGFloat = imgBaseBG!.frame.height
        
        
        vw_For_base = UIView(frame: CGRectMake(XPos, YPos, Width, Height))
        vw_For_base.backgroundColor = UIColorFromRGB(FontChatPurpleColor, alpha: 1)
        imgBaseBG!.addSubview(vw_For_base)
        
        
        Width = (CGRectGetWidth(self.view.frame))
        XPos = 0
        YPos = 40
        Height = 30
        
        verificationCode_Txt_Label = UILabel (frame: CGRectMake(XPos,YPos,Width,Height))
        verificationCode_Txt_Label.backgroundColor = UIColor.clearColor()
        verificationCode_Txt_Label.font = GRAPHICS.FONT_REGULAR(16)
        verificationCode_Txt_Label.text = INSPECTMODE_EVERIFICATIONCODE
        verificationCode_Txt_Label.textAlignment  = .Center
        verificationCode_Txt_Label.numberOfLines = 0
        verificationCode_Txt_Label.lineBreakMode = .ByWordWrapping
        verificationCode_Txt_Label.textColor = UIColor.whiteColor()
        vw_For_base.addSubview(verificationCode_Txt_Label)
        
        
         YPos = CGRectGetMaxY(verificationCode_Txt_Label.frame)+10
          Width = 20
          XPos = (CGRectGetWidth(self.view.frame)-110)/2
        
      btnOne =   createButton(XPos, YPos: YPos, Width: Width, Height: Width, btnText: "", fonstSize: 14, intTag: 101)
      
         XPos = CGRectGetMaxX(btnOne.frame)+10
      btnTwo =     createButton(XPos, YPos: YPos, Width: Width, Height: Width, btnText: "", fonstSize: 14, intTag: 102)
         XPos = CGRectGetMaxX(btnTwo.frame)+10
      btnThree =    createButton(XPos, YPos: YPos, Width: Width, Height: Width, btnText: "", fonstSize: 14, intTag: 103)
         XPos = CGRectGetMaxX(btnThree.frame)+10
      btnFour =    createButton(XPos, YPos: YPos, Width: Width, Height: Width, btnText: "", fonstSize: 14, intTag: 104)
        
       
         YPos = CGRectGetMaxY(verificationCode_Txt_Label.frame)+50
        if GRAPHICS.Screen_Type() == 1
        {
            Width = (CGRectGetWidth(self.view.frame)-160)/3
            createButtons(YPos, WIDTH: Width,XPOS : 60,COUNT : 10)
            
        }
        else
        {
            Width = (CGRectGetWidth(self.view.frame)-110)/3
             createButtons(YPos, WIDTH: Width,XPOS : 35,COUNT : 10)
        }


        
        
}
    
    
    func createButtons(var YPOS : CGFloat,var WIDTH : CGFloat,var XPOS : CGFloat, COUNT : Int  )
    {
        var XPos : CGFloat = XPOS
        
       // YPos = CGRectGetMaxY(verificationCode_Txt_Label.frame)+50
        XPos = XPOS
        var gap : CGFloat = 0.0
        for i in 0 ..< COUNT
        {
            let X :CGFloat = XPos+gap
            
            
            let Btn:UIButton = UIButton(frame: CGRectMake(X, YPOS, WIDTH, WIDTH))
            
            Btn.backgroundColor = UIColor.clearColor()
            Btn.setTitleColor(UIColorFromRGB(FontChatPurpleColor, alpha: 1), forState: .Normal)
            Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            Btn.tag = i+1
            
            Btn.titleLabel!.font = GRAPHICS.FONT_REGULAR(30)
            Btn.addTarget(self, action: #selector(BLEnterVerifyCodeViewController.handleBtnEvents(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Btn.layer.cornerRadius = WIDTH / 2
            vw_For_base.addSubview(Btn)
            Btn.layer.borderWidth = 1
            Btn.layer.borderColor = UIColorFromRGB(FontChatGreenColor, alpha: 1).CGColor
            XPos = CGRectGetMaxX(Btn.frame)
            
            Btn.setBackgroundImage(GRAPHICS.ENTERED_CODE_DIGIT_NORMAL_IMAGE(), forState: .Normal)
            Btn.setBackgroundImage(GRAPHICS.ENTERED_CODE_DIGIT_SELECTED_IMAGE()!, forState: .Highlighted)
            Btn.selected = false
            gap = 10
            
            if COUNT > 4
            {
                Btn.backgroundColor = UIColorFromRGB(FontWhiteColor, alpha: 1)
                
                 Btn.setTitle(String(i+1), forState: .Normal)
                if i == 9
                {
                
                    Btn.setTitle(String("0"), forState: .Normal)
                }
               
                Btn.layer.borderWidth = 0
                Btn.layer.borderColor = UIColor.clearColor().CGColor
                gap = 20
                if i >= 2 && i <= 4
                    
                {
                    if i == 2
                    {
                        XPos = 35
                        if GRAPHICS.Screen_Type() == 1
                        {
                            XPos = 60
                        }
                       
                        gap = 0
                        YPOS = CGRectGetMaxY(Btn.frame)+15
                    }
                        
                    else
                    {
                        XPos = CGRectGetMaxX(Btn.frame)
                        gap = 20
                        
                    }
                    
                }
                else  if i > 4 && i < 9
                    
                {
                    if i == 5
                    {
                        XPos = 35
                        if GRAPHICS.Screen_Type() == 1
                        {
                            XPos = 60
                        }

                        gap = 0
                        YPOS = CGRectGetMaxY(Btn.frame)+15
                    }
                    else if i == 8
                    {
                        XPos = (CGRectGetWidth(self.view.frame)-WIDTH)/2
                        gap = 0
                        YPOS = CGRectGetMaxY(Btn.frame)+15
                    }
                        
                    else
                    {
                        XPos = CGRectGetMaxX(Btn.frame)
                        gap = 20
                        
                    }
                    
                }

            }
            
            
            
        }

        
    }
    // MEthod to create top four radio buttons
    
    func createButton(XPos:CGFloat, YPos:CGFloat, Width:CGFloat, Height:CGFloat, btnText:NSString, fonstSize:CGFloat, intTag:Int)->UIButton{
        
        let button = UIButton(frame: CGRectMake(XPos, YPos, Width, Height))
        button.backgroundColor =  UIColor.clearColor()
        button.addTarget(self, action: "handleRadioButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.hidden = false
        button.tag = intTag
        button.layer.cornerRadius = Width/2
        button.setImage(GRAPHICS.ENTERED_CODE_POINTER_NORMAL_IMAGE(), forState: .Normal)
        button.setImage(GRAPHICS.ENTERED_CODE_POINTER_SELECTED_IMAGE()!, forState: .Selected)
        button.selected =  false
        vw_For_base.addSubview(button)
        
        return button
    }

    
    // MEthod to handle when user tapped digits
    
    func handleBtnEvents(sender : UIButton)
    {
        sender.selected = true
        tappedCount =  tappedCount+1
        uniqueCodeTypedStr.appendString((sender.titleLabel?.text)!)
        
        print("UNIQUE CODE::::\(uniqueCodeTypedStr)")
        
        if tappedCount == 1
        {
          
            btnOne.backgroundColor = UIColor.clearColor()
            btnOne.selected = true
        }
        else if tappedCount == 2
        {
            btnTwo.backgroundColor = UIColor.clearColor()
            btnTwo.selected = true
        }
        else if tappedCount == 3
        {
            
            btnThree.backgroundColor = UIColor.clearColor()
            btnThree.selected = true
        }
        else if tappedCount == 4
        {
           
            btnFour.backgroundColor = UIColor.clearColor()
            btnFour.selected = true
            
            appdelegate.showLoadingIndicator()
           ServerAPI().API_FinishSale(Defaults[.userId], item_id: itemEntity.itemIdStr as String, unique_code: uniqueCodeTypedStr as String,payment_mode: Defaults[.paymentMode], delegate: self)

        }
        
       
        print("tapped on::: \(sender.tag)")
    }
    
    func moveToNextScreen()
    {
        appdelegate.hideLoadingIndicator()
        callCodeConfirmationMethod()

    }
    
     // This method will call after 4 digits entered by user to call service to confirming the code
    func callCodeConfirmationMethod()
    {
         showValidationMessage("Successfully Verified!")
        print("Verified")
    }
    // This method for reseting the code entered by user if user feels if code is wrong
    func resetBtnAction()
    {
        tappedCount = 0
        uniqueCodeTypedStr = ""
        btnOne.selected = false
        btnTwo.selected = false
        btnThree.selected = false
        btnFour.selected = false

    }
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showValidationMessage(message:String){
        vw_For_base.userInteractionEnabled = false
        
        var cgSize:CGSize?
        cgSize = getImageWidthHeight(GRAPHICS.BRIDGE_CONGRATS_DESCRIPTION_IMAGE()!)
        
        if (self.vwValidation != nil)
        {
            self.vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
        }
        vwValidation = CustomAlert.ShowAlertWithMessage(self, frame: view.frame, Title: "INSPECT MODE", Message: message, isButtonNeeded: true,Height : (cgSize?.height)!) as? UIView
        view.addSubview(vwValidation!)
        view.bringSubviewToFront(vwValidation!)

        vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
        
        UIView.animateWithDuration(0.5, animations:
            { () -> Void in
                
                self.vwValidation!.frame.origin.y = 0
        })
        
        //view.bringSubviewToFront( vwValidation!)
    }
    
    func handleOkButtonAction(){
        
        
        UIView.animateWithDuration(0.5, animations:
            { () -> Void in
                
                self.vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
                 self.vw_For_base.userInteractionEnabled = true
                
                if self.isVerifiedSuccess
                {
                    self.moveToRaingScreen()
                }
                else{
                     self.resetBtnAction()
                }
               
            },completion:
            { (Bool) -> Void in

                               
        })
        
        
        
        
        
    }
   func moveToRaingScreen()
 {
        
                    let ratingVc = BLRatingVC()
                    ratingVc.isFromBuyingList = false
                    ratingVc.ratingUserIdStr = itemEntity.buyer_id as String
                    ratingVc.itemIdStr = itemEntity.itemIdStr as String
                   ratingVc.ratingUserNameStr = itemEntity.buyer_first_name as String
                    ratingVc.itemIdStr = itemEntity.itemIdStr as String
        
                    self.navigationController!.pushViewController(ratingVc, animated: true)
    
    }

    // MARK: -  CHAT API DELEGATES
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        appdelegate.hideLoadingIndicator()
        print(errorMessage)
    }
    
    func API_CALLBACK_FinishSale(resultDict: NSDictionary)
    {
        uniqueCodeTypedStr = ""
        appdelegate.hideLoadingIndicator()
        print("GET FINSIH ::: \(resultDict)")
        
        if resultDict.objectForKey("response_code") as! String == STATUS_CODE_1
        {
            isVerifiedSuccess = true
           // showValidationMessage("Success")
            showValidationMessage(resultDict.objectForKey("message") as! String)
            
            

        }
        else if resultDict.objectForKey("response_code") as! String == STATUS_CODE_2
        {
                let bankDetailsVC = BLCardListViewController()//BLBankDetailsVC()
                //bankDetailsVC.isFromHome = false
                self.navigationController?.pushViewController(bankDetailsVC, animated: true)
        }
            
        else if resultDict.objectForKey("response_code") as! String == STATUS_CODE_3
        {
            do
            {
                let isMoved = try self.moveToViewControllerInNavStack(BLHomeViewController.self)
                print(isMoved)
            }
            catch
            {
                print ("Error on moving to Home screen")
                
            }

        }
        else
        {
             showValidationMessage(resultDict.objectForKey("message") as! String)
        }
        
        
    }
    
     
}

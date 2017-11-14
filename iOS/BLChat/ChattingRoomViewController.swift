//
//  ChattingRoomViewController.swift
//  Bridge LLC
//
//  Created by Dheena on 3/14/16.
//  Copyright © 2016 Smaatone. All rights reserved.
//

import Foundation
import UIKit
import UIKit


enum ACTION_STATES_CHAT : String {
    
    case  NEW_PRODUCT_DETAILS = "New Product Details"
    case GOOD_SELLING_DETAILS = "Good Selling Details"
    case SERVICE_START_DETAILS = "Service Start Details"
    case ELECTRONIC_BUYING_DETAILS = "Electronic Buying Details"
    case GOODS_BUYING_DETAILS = "Goods Buying Details"
    case NEGOTIATION_DETAILS  = "Negotiation Details"
    case FINISHED_TRANSACTION_DETAILS  = "Finished Transaction Details"
    
    
    case BUYING_PHYSICAL_GOODS  = "Buying Physical Goods"
    case BUYING_ELECTRONICAL_GOODS  = "Buying Electronical Goods"
    case BUYING_PHYSICAL_SERVICES  = "Buying Physical Services"
    case BUYING_ELECTRONICAL_SERVICES  = "Buying Electronical Services"
    case SELLING_PHYSICAL_GOODS  = "Selling Physical Goods"
    case SELLING_ELECTRONICAL_GOODS  = "Selling Electronical Goodss"
    case SELLING_PHYSICAL_SERVICES  = "Selling Physical Services"
    case SELLING_ELECTRONICAL_SERVICES  = "Selling Electronical Services"
    
    case ITEM_FROM_HOME  = "Item From Home"
    case BIDDED_ITEM  = "Bidded Items"
    case ITEM_FROM_PROFILE  = "Item From Profile"
    
    static let allValues = [NEW_PRODUCT_DETAILS, GOOD_SELLING_DETAILS,SERVICE_START_DETAILS,ELECTRONIC_BUYING_DETAILS,GOODS_BUYING_DETAILS,NEGOTIATION_DETAILS,FINISHED_TRANSACTION_DETAILS,BUYING_PHYSICAL_GOODS,BUYING_ELECTRONICAL_GOODS,BUYING_PHYSICAL_SERVICES,BUYING_ELECTRONICAL_SERVICES,SELLING_PHYSICAL_GOODS,SELLING_ELECTRONICAL_GOODS,SELLING_PHYSICAL_SERVICES,SELLING_ELECTRONICAL_SERVICES,ITEM_FROM_HOME,BIDDED_ITEM]
    
    
}



class ChattingRoomViewController : BLBaseViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ServerAPIDelegate,PayPalPaymentDelegate
{
    
    var payPalConfig = PayPalConfiguration()
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnectWithEnvironment(newEnvironment)
            }
        }
    }
    
    var acceptCreditCards: Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }

    var payoptionsForBuyView : UIView!
    
    var sendButtonHeight = CGFloat(0)
    
    var bottomViewPadding = CGFloat(0)
     var isFromPayPlaSuccess = false
    var forAction : NSString = NSString()
    var isApprovedMessageShown = false
    var isOtherUserApproved = false
    var isMoveToHome = false
    var isFromNegotiationTap = false
    var isFromRefresh = false
    var itemPaymentIdFromRefresh = ""
    var tblVw_For_Chatting = UITableView()
    var bottomView = UIImageView()
    var vW_divider = UIView()
    var messageTxtVw = UITextView()
    var btnSend = UIButton()
    var isNegotiateChat = true
    var isFromBiddingNegotiate = false
    var isFromHistoryProfileChat = false
    var infoAlertView : UIView?
    var  array_For_Messages = NSMutableArray()
    var  getDatesArray = NSMutableArray()
    var keyBoardTool = UIToolbar()
    var approveBtn = UIButton()
    var detailsBtn = UIButton()
    var isMineBool = false
    var textViewPlaceHolder_Str = String()
    var vwValidation:UIView?
    var lastAmount = ""
    var isApproved = false
    var BidEntity = BLBiddingEntity(dic: NSMutableDictionary())
    var FinalMessageArray = NSMutableArray()
    var ApiTimer: NSTimer!
    var m_MessageCount = 0
    var m_TotalMessageCount = 0
    var negotiateAmount_Approve = String()
    var selectedNegotiate_Quantity = "1"
    var negotiateId_Approve = String()
    var negotiateId_quantity = String()
    var negotiateItem_BuyerID = String()
    var negotiateItem_itemID = String()

     var negotiateItem_OfferBuyerID = String()
    var isApprvedAmount =  false
    var itemEntity = BLGoodsItemEntity(dic: NSMutableDictionary())
    var notificationType  = String()
    var notification_itemId  = String()
    var notification_BuyerId  = String()
    var totalInt = 0
    var isFromNegotiateForOffers = false
    
    
    var negotiate_BidId = ""
    var negotiateOffers_ItemName = ""
    override  func viewDidLoad()
    {
    
        super.viewDidLoad()
      if   Defaults[.isChatMessageNotification] == "1"
      {
        isNegotiateChat = false
      }
      else{
           isNegotiateChat = true
        }
        
        payPalConfig.acceptCreditCards = true
        //PayPalMobile.preconnectWithEnvironment(environment)
        payPalConfig.acceptCreditCards = acceptCreditCards;
        payPalConfig.merchantName = "Base LLC"
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "http://52.27.187.84/terms.html")
        payPalConfig.merchantUserAgreementURL = NSURL(string: "http://52.27.187.84/terms.html")
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages()[0]
        payPalConfig.payPalShippingAddressOption = .Provided
        payPalConfig.rememberUser = true
        payPalConfig.acceptCreditCards = false

        
        self.view.bringSubviewToFront( self.imgBaseHeader!)
        
        print("selectedNegotiate_Quantity:::\(selectedNegotiate_Quantity)")
       
        
        let  XPos = CGRectGetWidth(view.frame)-90
        let  YPos = leftBtn.frame.origin.y+3
        let  Width = CGFloat(80.0)
        let  Height = leftBtn.frame.height
        
        approveBtn = UIButton(frame: CGRectMake(XPos, YPos, Width, Height))
        approveBtn.backgroundColor = UIColor.clearColor()
        approveBtn .setTitle("APPROVE".capitalizedString, forState: UIControlState.Normal)
        approveBtn.contentHorizontalAlignment = .Right
        approveBtn.titleLabel?.font = GRAPHICS.FONT_REGULAR(16)
        approveBtn.hidden = true
        approveBtn.userInteractionEnabled = false
        approveBtn.setTitleColor(UIColorFromRGB(HeaderTitleColor, alpha: 1), forState: UIControlState.Normal)
        approveBtn.addTarget(self, action: #selector(ChattingRoomViewController.handleApproveBtnAction(_:)), forControlEvents:UIControlEvents.TouchUpInside)
        imgBaseHeader!.addSubview(approveBtn)
        
        
        
        let cgSize = GRAPHICS.getImageWidthHeight(GRAPHICS.CHAT_TO_HOME_ICON()!)
        let Width1:CGFloat = (cgSize.width)
        let Height1:CGFloat = (cgSize.height)
        let YPos1:CGFloat = 40.0
        let XPos1:CGFloat = GRAPHICS.Screen_Width()-Width1-10
        
        
        detailsBtn = UIButton(frame: CGRectMake(XPos1, YPos1, Width1, Height1))
        detailsBtn.setBackgroundImage(GRAPHICS.CHAT_TO_HOME_ICON(), forState: UIControlState.Normal)
       // detailsBtn.setBackgroundImage(GRAPHICS.HOME_SCREEN_MENU_CLOSE(), forState: .Selected)
        detailsBtn.addTarget(self, action: #selector(ChattingRoomViewController.handleDetailsBtnnAction(_:)), forControlEvents:UIControlEvents.TouchUpInside)
        detailsBtn.hidden = true
        //detailsBtn.userInteractionEnabled = false
        imgBaseHeader!.addSubview(detailsBtn)
        
        
        
        
         if isNegotiateChat
        {
             self.lblTitle?.text = Chat_Negotiate_room.uppercaseString
             approveBtn.hidden = false
            detailsBtn.hidden = true
        }
        else
        {
            self.lblTitle?.text = Chat_Title.uppercaseString
            detailsBtn.hidden = false
            
        }
        self.lblTitle?.font = GRAPHICS.FONT_REGULAR(18)
        
        //self.hideCurveImage()
        self .moveCurveToFront()
        appdelegate.showLoadingIndicator()
        
        

        moveToNextScreen()
        if isFromBiddingNegotiate
        {
            itemEntity.itemIdStr = BidEntity.itemIdStr as String
            itemEntity.userIdStr = BidEntity.userIdStr as String
            itemEntity.buyer_id = BidEntity.buyerIdStr as String
            selectedNegotiate_Quantity = BidEntity.quantityStr as String
//            itemEntity.itemIdStr = BidEntity.itemIdStr as String
            
        }
        
        ApiTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(ChattingRoomViewController.callBackgroundService), userInfo: nil, repeats: true)


    }
    
    
    override func viewWillAppear(animated: Bool) {
        if (self.vwValidation != nil)
        {
            self.vwValidation!.removeFromSuperview()
        }
        PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentProduction)
        
        if Defaults[.isFromNotification] == "0"
        {
           
        }
        else
        {
            if Defaults[.isFromNegotiateOffers] == "1"
            {
                isFromNegotiateForOffers = true
            }
            else
            {
                isFromNegotiateForOffers = false
            }
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
                if ApiTimer != nil
                {
        self.ApiTimer.invalidate()
        self.ApiTimer = nil
                }
    }

    // MARK: OTHER Methods
    
    func callApiForGetChatDetails()
    {
       // appdelegate.showLoadingIndicator()
        if isFromBiddingNegotiate
        {
            itemEntity.itemIdStr = BidEntity.itemIdStr as String
            itemEntity.userIdStr = BidEntity.userIdStr as String
            itemEntity.buyer_id = BidEntity.buyerIdStr as String
            //            itemEntity.itemIdStr = BidEntity.itemIdStr as String
            
        }
        if isNegotiateChat
        {
            var negotiationStr = ""
            if Defaults[.isFromNotification] == "0"
            {
                negotiationStr = ""
            }
            else
            {
                negotiationStr = "1"
            }
           if  Defaults[.isFromProfile] == "TRUE"
           {
                if Defaults[.userId] == itemEntity.buyer_id as String //
                {
                    ServerAPI().API_GetNegotiationMessageAPI(Defaults[.userId], item_id: itemEntity.itemIdStr as String,buyer_id :itemEntity.userIdStr as String,notification : negotiationStr,  delegate: self)
                }
               else // SELELR
                {
                    
                    if itemEntity.itemIdStr == "" && itemEntity.buyer_id == ""
                    {
                        
                        
                        ServerAPI().API_GetNegotiationMessageAPI(Defaults[.userId], item_id:  Defaults[.ITEMID_FROM_NOTIFICATION_NEGOTIATION],buyer_id : Defaults[.BUYERID_FROM_NOTIFICATION_NEGOTIATION],notification : negotiationStr,  delegate: self)
                        
                        
                    }
                    else
                    {
                        if Defaults[.userId] == itemEntity.userIdStr as String //Seller
                        {
                             ServerAPI().API_GetNegotiationMessageAPI(Defaults[.userId], item_id: itemEntity.itemIdStr as String,buyer_id :itemEntity.buyer_id as String,notification : negotiationStr,  delegate: self)
                        }
                        else
                        {
                             ServerAPI().API_GetNegotiationMessageAPI(Defaults[.userId], item_id: itemEntity.itemIdStr as String,buyer_id :itemEntity.buyer_id as String,notification : negotiationStr,  delegate: self)
                        }

                        
                    }
                    
                   
                }

            
                       
        }
           else
           {
            
            if Defaults[.userId] == itemEntity.userIdStr as String // SELLER
            {
                
                if   itemEntity.buyer_id == ""
                {
                    
                    
                    ServerAPI().API_GetNegotiationMessageAPI(Defaults[.userId], item_id:  itemEntity.itemIdStr as String,buyer_id : Defaults[.BUYERID_FROM_NOTIFICATION_NEGOTIATION],notification : negotiationStr,  delegate: self)
                    
                    
                }
                else
                {
                     ServerAPI().API_GetNegotiationMessageAPI(Defaults[.userId], item_id: itemEntity.itemIdStr as String,buyer_id :itemEntity.buyer_id as String,notification : negotiationStr,  delegate: self)
                }

                
                
                
               
            }
            else
            {
                if Defaults[.isFromNotification] == "0"
                {
                    
                }
                else
                {
                    if   itemEntity.buyer_id == ""
                    {
                        itemEntity.userIdStr =  Defaults[.BuyerID_For_WhenCOmingFromNotificationTapForOffers]
                    }
                    
                    if   itemEntity.itemIdStr == ""
                    {
                        itemEntity.itemIdStr =  Defaults[.itemID_For_WhenCOmingFromNotificationTapForOffers]
                    }

                }

                     
                ServerAPI().API_GetNegotiationMessageAPI(Defaults[.userId], item_id: itemEntity.itemIdStr as String,buyer_id :itemEntity.userIdStr as String,notification : negotiationStr,  delegate: self)
            }
            
            
            }
            
           
        }
        else
        {

            if  Defaults[.isFromProfile] == "TRUE"
            {
                
                if Defaults[.userId] == itemEntity.buyer_id as String
                {
                    ServerAPI().API_GetChatAPI(Defaults[.userId], friend_id: itemEntity.userIdStr as String, item_id: itemEntity.itemIdStr as String, delegate: self)
                }
                else{
                    if itemEntity.buyer_id as String == ""
                    {
                        ServerAPI().API_GetChatAPI(Defaults[.userId], friend_id: itemEntity.userIdStr as String, item_id: itemEntity.itemIdStr as String, delegate: self)
                        
                    }
                    else{
                        ServerAPI().API_GetChatAPI(Defaults[.userId], friend_id: itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, delegate: self)
                        
                    }

                    
//                    ServerAPI().API_GetChatAPI(Defaults[.userId], friend_id: itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, delegate: self)
                }
                
            }
            else
            {
                
                
                if Defaults[.userId] == itemEntity.buyer_id as String // BUYER
                {
                    
                    
                     ServerAPI().API_GetChatAPI(Defaults[.userId], friend_id: itemEntity.userIdStr as String, item_id: itemEntity.itemIdStr as String, delegate: self)
                }
                else
                {
                    if itemEntity.buyer_id as String == ""
                    {
                        ServerAPI().API_GetChatAPI(Defaults[.userId], friend_id: itemEntity.userIdStr as String, item_id: itemEntity.itemIdStr as String, delegate: self)
                        
                    }
                    else{
                        ServerAPI().API_GetChatAPI(Defaults[.userId], friend_id: itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, delegate: self)
                        
                    }
                    
                }
               
            }

            
            
        }
        
    }
    func callApiForSendChatDetails(message : String)
    {
        
        if selectedNegotiate_Quantity == ""
        
        {
            selectedNegotiate_Quantity = negotiateId_quantity
        }
        
        appdelegate.showLoadingIndicator()
        if isNegotiateChat
        {
            if  Defaults[.isFromProfile] == "TRUE"
            {
                if Defaults[.userId] == itemEntity.buyer_id as String
                {
                    ServerAPI().API_SendNegotiationMessageAPI(Defaults[.userId], item_id: itemEntity.itemIdStr as String, negitation_amount: message, to_user_id : itemEntity.userIdStr as String ,quantity : selectedNegotiate_Quantity,bid_id :negotiate_BidId,delegate: self)
                }
                else
                {
                    ServerAPI().API_SendNegotiationMessageAPI(Defaults[.userId], item_id: itemEntity.itemIdStr as String, negitation_amount: message, to_user_id : itemEntity.buyer_id as String ,quantity : selectedNegotiate_Quantity,bid_id :negotiate_BidId,delegate: self)
                }
                
            }
            else
            {
                
                if Defaults[.userId] == itemEntity.buyer_id as String
                {
                    ServerAPI().API_SendNegotiationMessageAPI(Defaults[.userId], item_id: itemEntity.itemIdStr as String, negitation_amount: message, to_user_id : itemEntity.userIdStr as String ,quantity : selectedNegotiate_Quantity,bid_id :negotiate_BidId,delegate: self)
                }
                else
                {
                    
                    if itemEntity.buyer_id as String == ""
                    {
                        ServerAPI().API_SendNegotiationMessageAPI(Defaults[.userId], item_id: itemEntity.itemIdStr as String, negitation_amount: message, to_user_id : itemEntity.userIdStr as String ,quantity : selectedNegotiate_Quantity,bid_id :negotiate_BidId,delegate: self)
                    }
                    else{
                        ServerAPI().API_SendNegotiationMessageAPI(Defaults[.userId], item_id: itemEntity.itemIdStr as String, negitation_amount: message, to_user_id : itemEntity.buyer_id as String ,quantity : selectedNegotiate_Quantity,bid_id :negotiate_BidId,delegate: self)
                    }
                    
                    
                }
                
            }
            
           
        }
        else
        {

            if  Defaults[.isFromProfile] == "TRUE"
            {
                
                
                if Defaults[.userId] == itemEntity.buyer_id as String
                {
                    ServerAPI().API_SendChatAPI(Defaults[.userId], friend_id: itemEntity.userIdStr as String, item_id: itemEntity.itemIdStr as String, chat_message: message,payment_id : itemEntity.paymentIdStr as String, delegate: self)//itemEntity.userIdStr as String
                    
                }
                else
                {
                    if itemEntity.buyer_id as String == ""
                    {
                        ServerAPI().API_SendChatAPI(Defaults[.userId], friend_id: itemEntity.userIdStr as String, item_id: itemEntity.itemIdStr as String, chat_message: message,payment_id : itemEntity.paymentIdStr as String, delegate: self)//itemEntity.userIdStr as String
                    }
                    else
                    {
                        ServerAPI().API_SendChatAPI(Defaults[.userId], friend_id: itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, chat_message: message,payment_id : itemEntity.paymentIdStr as String, delegate: self)//itemEntity.userIdStr as String
                    }
                    
                    
                }


            }
            else
            {
                
                if Defaults[.userId] == itemEntity.buyer_id as String
                {
                   ServerAPI().API_SendChatAPI(Defaults[.userId], friend_id: itemEntity.userIdStr as String, item_id: itemEntity.itemIdStr as String, chat_message: message,payment_id : itemEntity.paymentIdStr as String, delegate: self)//itemEntity.userIdStr as String
                    
                }
                else
                {
                    if itemEntity.buyer_id as String == ""
                    {
                        ServerAPI().API_SendChatAPI(Defaults[.userId], friend_id: itemEntity.userIdStr as String, item_id: itemEntity.itemIdStr as String, chat_message: message,payment_id : itemEntity.paymentIdStr as String, delegate: self)//itemEntity.userIdStr as String
                    }
                    else
                    {
                        ServerAPI().API_SendChatAPI(Defaults[.userId], friend_id: itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, chat_message: message,payment_id : itemEntity.paymentIdStr as String, delegate: self)//itemEntity.userIdStr as String
                    }

                    
                }
                
            }
            
            
        }

      
    }
    
    func callBackgroundService()
    {
        
        if self.navigationController?.visibleViewController == self
        {
           callApiForGetChatDetails()
        }
        
    }

    
    
    func moveToNextScreen()
    {
        appdelegate.showLoadingIndicator()
        CreateKeyBoardToolBar()
        callApiForGetChatDetails()
        CreateChattingControls()
              
    }

    
    func CreateChattingControls()
    {
       var XPos : CGFloat = 0
        var YPos : CGFloat = 0
        
        var GAP:CGFloat = 0.0
        var cgSize:CGSize?
         cgSize = GRAPHICS.getImageWidthHeight(GRAPHICS.BRIDGE_CHAT_TXTVIEW_SHADOW_IMAGE()!)
        cgSize?.height  = 50
       var Width : CGFloat = CGRectGetWidth(self.view.frame)
       var Height : CGFloat = CGRectGetHeight(imgBaseBG!.frame)-(cgSize?.height)!
        
        tblVw_For_Chatting = UITableView(frame: CGRectMake(XPos, YPos, Width, Height))
        tblVw_For_Chatting.dataSource = self
        tblVw_For_Chatting.delegate = self
        tblVw_For_Chatting.sectionFooterHeight = 0
        tblVw_For_Chatting.backgroundColor = UIColor.whiteColor()
        tblVw_For_Chatting.separatorStyle = UITableViewCellSeparatorStyle.None
        tblVw_For_Chatting.registerClass(ChatCustomCell.self, forCellReuseIdentifier: "ColorCell")
    
        [imgBaseBG!.addSubview(tblVw_For_Chatting)]
        
        YPos = CGRectGetMaxY(tblVw_For_Chatting.frame)
        
        
        Width = (cgSize?.width)!
        Height = (cgSize?.height)!
        YPos = CGRectGetMaxY(tblVw_For_Chatting.frame)
        XPos = 0
        
         bottomView = UIImageView(frame: CGRectMake(XPos, YPos, Width, Height))
//        bottomView.image = GRAPHICS.BRIDGE_CHAT_TXTVIEW_SHADOW_IMAGE()
        bottomView.backgroundColor = UIColor.whiteColor()
        bottomView.userInteractionEnabled = true
        imgBaseBG?.addSubview(bottomView)

        
        
        
        
        XPos = 5
        YPos = ((CGRectGetHeight(bottomView.frame)-40)/2)
        Width = CGRectGetWidth(bottomView.frame)-90-(2*XPos)
        Height = 40
        
        
        bottomViewPadding = YPos
        
        messageTxtVw.frame =  CGRectMake(XPos, YPos,Width, Height)
        messageTxtVw.delegate = self
        messageTxtVw.layer.borderWidth = 1.0
        messageTxtVw.layer.borderColor = UIColorFromRGB(FontChatGreenColor, alpha: 1).CGColor
        messageTxtVw.backgroundColor = UIColor.clearColor()
        messageTxtVw.autocorrectionType = UITextAutocorrectionType.No
        messageTxtVw.font = GRAPHICS.FONT_REGULAR(14)
        messageTxtVw.textColor = UIColor.lightGrayColor()
        if isNegotiateChat
        {
            
            self.lblTitle?.text = Chat_Negotiate_room.uppercaseString
            approveBtn.hidden = false
            detailsBtn.hidden = true
            
             messageTxtVw.keyboardType = .NumberPad
            messageTxtVw.inputAccessoryView = keyBoardTool
            messageTxtVw.text = Chat_TypeYour_Amount
            textViewPlaceHolder_Str = Chat_TypeYour_Amount
            
        }
        else
        {
            self.lblTitle?.text = Chat_Title.uppercaseString
            detailsBtn.hidden = false
            
             messageTxtVw.keyboardType = .Default
            messageTxtVw.text = Chat_TypeYour_Message
            textViewPlaceHolder_Str = Chat_TypeYour_Message
        }
       
        bottomView.addSubview(messageTxtVw)
        
        
        XPos = CGRectGetWidth(view.frame)-90
        YPos = 0
        Width = 90
        Height = (cgSize?.height)! - 0
        
        
        sendButtonHeight = Height
        
        btnSend = UIButton(frame: CGRectMake(XPos, YPos,Width, Height))
        btnSend.backgroundColor = UIColorFromRGB(FontChatGreenColor, alpha: 1)
        btnSend .setTitle(Chat_Send, forState: UIControlState.Normal)
        btnSend.setTitleColor(UIColorFromRGB(FontWhiteColor, alpha: 1), forState: UIControlState.Normal)
        
        btnSend.addTarget(self, action: #selector(ChattingRoomViewController.sendMessageBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
       
        bottomView.addSubview(btnSend)
        
        moveToLastRowInTableView()
        
        
        // TEXT FIELD SHOULD BE DISABLED WHEN CHAT COMES FROM HISTORY ITEM...THERE CHAT MESSAGE ONLY CAN VIEW BY USER
        if forAction == ACTION_STATES_CHAT.FINISHED_TRANSACTION_DETAILS.rawValue
        {
            bottomView.userInteractionEnabled = false
        }
        
        


    }
    
    // MARK: TABLEVIEW DELEGATES
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return FinalMessageArray.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        for i in 0..<FinalMessageArray.count
        {
            
            let dayArray = FinalMessageArray.objectAtIndex(section) as! NSDictionary
            let messageArr = dayArray.valueForKey("Message") as! NSArray
            
           // m_MessageCount =  m_MessageCount + messageArr.count
            return messageArr.count
            
        }
        return FinalMessageArray.count
        
        
       
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let reuseIndentifier = "ColorCell"
        var cell:ChatCustomCell? = tableView.dequeueReusableCellWithIdentifier(reuseIndentifier) as? ChatCustomCell
        
        if (cell != nil)
        {
            cell! = ChatCustomCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIndentifier)
        }
        let dayArray = FinalMessageArray.objectAtIndex(indexPath.section) as! NSDictionary
        let messageArr = dayArray.valueForKey("Message") as! NSArray
        let chatEnt = messageArr.objectAtIndex(indexPath.row)as! BLChatEntity
       
        var ReceiverString = String()
        var userIdStr = String()
        
        if isNegotiateChat
        {
            userIdStr = chatEnt.user_id as String
        }
        else
        {
            userIdStr = chatEnt.sender_id as String
        }
    
        if userIdStr == Defaults[.userId]
        {
           ReceiverString = "Mine"
          cell!.m_UserName_Label.text = Defaults[.firstName]
            
        }
        else
        {
            if isNegotiateChat
            {
                ReceiverString = "SomeOne"
                cell!.m_UserName_Label.text = chatEnt.user_name as String
            }
            else
            {
                ReceiverString = "SomeOne"
                cell!.m_UserName_Label.text = chatEnt.sender_first_name as String
            }
            
            
        }
        
        
        
        var str =  String()
        var  Height =  CGFloat()
        var  STATIC_WIDTH =  CGFloat()
        let font = GRAPHICS.FONT_MEDIUM(12)!
        let textAttributes = [NSFontAttributeName: font]
        var textRect =  CGRect()
       
        if isNegotiateChat
        {
            let amount = Int(Double(chatEnt.negitation_amount as String)!)
//            var amountStr = String(amount)
//         amountStr =   amountStr.stringByReplacingOccurrencesOfString(".00000", withString: "")
            str = String(format: "$%d", amount)
            if isMineBool
            {
                btnSend.enabled = false
                bottomView.userInteractionEnabled = false
            }
            else
            {
                btnSend.enabled = true
                bottomView.userInteractionEnabled = true
            }
        }
        else
        {
             str = chatEnt.chat_message as String
        }
       
        
        
        // if isNegotiateChat is true,negotiate chatting screen will come
        if isNegotiateChat
        {
          
           STATIC_WIDTH = 50
             textRect = str.boundingRectWithSize(CGSizeMake(160, 0), options: .UsesLineFragmentOrigin, attributes: textAttributes, context: nil)
            Height = heightForView(str, font: GRAPHICS.FONT_MEDIUM(12)!, width:textRect.width + 10 )
            
        }
        else // if isNegotiateChat is false,message chatting screen will come
        {
            STATIC_WIDTH = 10
             textRect = str.boundingRectWithSize(CGSizeMake(200, 0), options: .UsesLineFragmentOrigin, attributes: textAttributes, context: nil)
            Height = heightForView(str, font: GRAPHICS.FONT_MEDIUM(12)!, width:textRect.width + 10 )
            
        }
       
        
        
       // this is method for calculating message bubble height and width based on text length
        if isNegotiateChat
        {
            if  Height < 15.0
            {
                Height =  90
            }
            else
            {
                Height =  Height + 60
            }

        }
        else
        {
            if  Height < 15.0
            {
                Height =  75
            }
            else
            {
                Height =  Height + 60
            }

        }
        
        
        cell?.setControls(ReceiverString,height: Height,width: textRect.width+STATIC_WIDTH,isNegotiateChat : isNegotiateChat)
        cell!.m_Message_Label.text = str //str.stringByRemovingPercentEncoding!//
        var stringTime = GRAPHICS.getChatTimeFromString((chatEnt.chat_date_time as String))
        if isNegotiateChat
        {
            stringTime  = GRAPHICS.getChatTimeFromString((chatEnt.date_sent as String))
        }

        cell!.m_ChatMessageReceivedTime_Label.text = stringTime
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        cell!.m_MessagelabelBg_view.tag = indexPath.row
        
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
         // this is method for calculating message bubble height and width based on text length
        var str =  String()
        var  STATIC_WIDTH =  CGFloat()
        var textRect =  CGRect()
        
        
        let dayArray = FinalMessageArray.objectAtIndex(indexPath.section) as! NSDictionary
        let messageArr = dayArray.valueForKey("Message") as! NSArray
        let chatEnt = messageArr.objectAtIndex(indexPath.row)as! BLChatEntity
        
        
        str = chatEnt.chat_message as String


        let font = GRAPHICS.FONT_MEDIUM(12)!
        let textAttributes = [NSFontAttributeName: font]
        if isNegotiateChat
        {
            STATIC_WIDTH =  10
              textRect = str.boundingRectWithSize(CGSizeMake(160, 0), options: .UsesLineFragmentOrigin, attributes: textAttributes, context: nil)
        }
        else
        {
            STATIC_WIDTH =  10
              textRect = str.boundingRectWithSize(CGSizeMake(200, 0), options: .UsesLineFragmentOrigin, attributes: textAttributes, context: nil)
            
        }
       
       
        
        let  height: CGFloat = heightForView(str, font: GRAPHICS.FONT_MEDIUM(12)!, width:textRect.width+10)
        if isNegotiateChat // Only for numbers
        {
            if  height < 15.0
            {
                return 90
            }
            
            return height  + 60
        }
        else // Height for Message
        {
            if  height < 15.0
            {
                return 75
            }
            
            return height  + 60
        }
       
        
    }

    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }


    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let dayArray = FinalMessageArray.objectAtIndex(section) as! NSDictionary
        
        
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        //        label.backgroundColor = UIColorFromRGB(headerBlueCOlor, alpha: 1)
        
        view.backgroundColor = UIColorFromRGB(FontChatGreenColor, alpha: 0.5)
        
        label.textAlignment = .Center
        label.layer.cornerRadius = 15.0
        label.clipsToBounds = true
        label.font = GRAPHICS.FONT_BOLD(14)
        label.text = checkForTOday ((dayArray.valueForKey("Date") as? NSDate)!)
        label.textColor = UIColor.whiteColor()
        view.addSubview(label)
        
        return view
        
    }
    
    // Method to change the header section title as TODAY if there is any messages on today's date
    
    func checkForTOday ( date: NSDate) -> String
    {
        
        
        if date.isToday()
        {
            return "Today"
        }
        else
        {
            return date.toString(format: .Custom( "dd-MMM-yyyy"), timeZone: NSTimeZone.localTimeZone())
        }
        
    }

    
    // MARK: UITEXTVIEW DELEGATES
    
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        
        changeTableAndBottomPositionWhenResignKeyBoard()
        
        return true
        
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        messageTxtVw.textColor = UIColor.blackColor()
        
            UIView .animateWithDuration(0.25) { () -> Void in
                
                if self.isNegotiateChat
                {
                    self.tblVw_For_Chatting.frame.size.height =  self.tblVw_For_Chatting.frame.size.height - 260
                }
                else
                {
                    self.tblVw_For_Chatting.frame.size.height =  self.tblVw_For_Chatting.frame.size.height - 216
                }
              
                
                self.bottomView .frame.origin.y = CGRectGetMaxY(self.tblVw_For_Chatting.frame)
                self.moveToLastRowInTableView()
                
            }

        
        return true
        
    }
    func textViewDidBeginEditing(textView: UITextView)
    {
        
        if messageTxtVw.text == Chat_TypeYour_Message || messageTxtVw.text == Chat_TypeYour_Amount
        {
             messageTxtVw.text = ""
        }
       
        
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            messageTxtVw.textColor = UIColor.lightGrayColor()
            if isNegotiateChat
            {
                 messageTxtVw.text = Chat_TypeYour_Amount
                  textViewPlaceHolder_Str = Chat_TypeYour_Amount
            }
            else
            {
                if textView.text.characters.count == 0
                {
                                     messageTxtVw.text = Chat_TypeYour_Message
                                     textViewPlaceHolder_Str = Chat_TypeYour_Message
                    
                }
            
//                 messageTxtVw.text = Chat_TypeYour_Message
//                 textViewPlaceHolder_Str = Chat_TypeYour_Message
            }
           
            textView.resignFirstResponder()
            changeTableAndBottomPositionWhenResignKeyBoard()

           
        }
        else
        {
            if isNegotiateChat
            {
                
                if text == ""
                {
                    return true
                }
                
                if textView.text.characters.count == 6
                {
                    
                     return false
                }
                
                
            }
        }
        
        resizeTextView(textView)
        
        return true
    }
    // MARK: OTHER METHODS
    
    // method for resizing textview when typing messge
    func resizeTextView(textView:UITextView)
    {
        
        guard let font = textView.font  else
        {
            return
        }
        var newHeight =  heightForView(textView.text, font: textView.font!, width: textView.frame.width)
        
        
        print("HEIGHT ::::\(newHeight)")
        if newHeight < 20
        {
           newHeight = 40
        }
        
        else if newHeight < 35
        {
            newHeight = 40
        }
        else  if newHeight > 50
        {
            newHeight = 70
           
        }
        
        
        var frame = textView.frame
        
        frame.origin.y -= newHeight - frame.size.height
        tblVw_For_Chatting.frame.size.height =  tblVw_For_Chatting.frame.size.height - (newHeight - frame.size.height)
        
        frame.size.height = newHeight
        
        
        bottomView.frame.origin.y = CGRectGetMaxY(tblVw_For_Chatting.frame)
        bottomView.frame.size.height = frame.size.height + (2 * bottomViewPadding)
        
        
        frame.origin.y = bottomViewPadding    //((CGRectGetHeight(bottomView.frame)-newHeight)/2) + 8
        textView.frame = frame
        
        
        
        var frameSendBtn = btnSend.frame
        frameSendBtn.origin.y =  bottomView.frame.height - sendButtonHeight
        frameSendBtn.size.height = sendButtonHeight
        btnSend.frame = frameSendBtn

        
    }
    
     // Method of send message button action
    
    func sendMessageBtnAction()
    {
        
        if isNegotiateChat
        {
            btnSend.enabled = false
            bottomView.userInteractionEnabled = false
        }
        else
        {
            btnSend.enabled = true
            bottomView.userInteractionEnabled = true
        }
        
        let whitespaceSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        
        if messageTxtVw.text.characters.count == 0   || messageTxtVw.text == textViewPlaceHolder_Str || messageTxtVw.text.stringByTrimmingCharactersInSet(whitespaceSet) == ""
        {
            messageTxtVw.resignFirstResponder()
            changeTableAndBottomPositionWhenResignKeyBoard()
          
        }
            
        else
        {
        
            if isNegotiateChat
            {
                
                
                 let string1 = ""
                 let string2 = messageTxtVw.text
                 let appendString1 = "\(string1)\(string2)"
                
                if m_TotalMessageCount >= 10
                {
                    showValidationMessage(CHAT_NEGOTIATION_LIMIT_EXCEEDS ,isButtonNeeded : false)
                    
                }
                else
                {
                    if isMineBool
                    {
                        showValidationMessage(ALERT_FOR_WAITING_NEGOTIATION_AMOUNT ,isButtonNeeded : false)
                    }
                    else
                    {
                        callApiForSendChatDetails(appendString1)
                    }
                    
                }
                
                
            }
            else
            {
               callApiForSendChatDetails(messageTxtVw.text)
            }
            
            messageTxtVw.text = ""
            resizeTextView(messageTxtVw)
           
        
          
        }

    }
    func handleOkButtonAction()
    {
      
        //infoAlertView .removeFromSuperview()
        UIView.animateWithDuration(1.00, animations:
            { () -> Void in
                
                self.vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
        })
        
        if isOtherUserApproved
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
            //DO NOTHING
        }
        
       
    }
    func getImageWidthHeight(imgImage:UIImage)->CGSize{
        
        var Width:CGFloat =  imgImage.size.width / 1.15
        var Height:CGFloat = imgImage.size.height / 1.15
        
        
        if GRAPHICS.Screen_Type() == IPHONE_6_Plus{
            Width = Width / 0.96
            Height = Height / 0.96
        }
        else if GRAPHICS.Screen_Type() == IPHONE_6{
            
            Height = Height / 0.96
            Width = Width / 0.96
            
            Width = Width / 1.5
            Height = Height / 1.5
            
            Width = Width / 2.0
            Height = Height / 2.0
        }
        else
        {
            Height = Height / 0.96
            Width = Width / 0.96
            
            Width = Width / 1.5
            Height = Height / 1.5
            
            Width = Width / 1.171875
            Height = Height / 1.171875
            
            Width = Width / 2.0
            Height = Height / 2.0
        }
        return CGSizeMake(Width, Height)
    }
    
    
    func changeTableAndBottomPositionWhenResignKeyBoard()
    {
        UIView .animateWithDuration(0.25) { () -> Void in
            var XPos : CGFloat = 0
            var YPos : CGFloat = 0
            
           // var GAP:CGFloat = 0.0
            
            var cgSize:CGSize?
            cgSize = GRAPHICS.getImageWidthHeight(GRAPHICS.BRIDGE_CHAT_TXTVIEW_SHADOW_IMAGE()!)
            cgSize!.height = 50
            
            var Height : CGFloat = CGRectGetHeight(self.imgBaseBG!.frame)-(cgSize?.height)!
            self.tblVw_For_Chatting.frame.size.height =  Height

            YPos = CGRectGetMaxY(self.tblVw_For_Chatting.frame)
            self.bottomView .frame.origin.y = YPos
            self.bottomView .frame.size.height = (cgSize?.height)!

            XPos = 5
            YPos = ((CGRectGetHeight(self.bottomView.frame)-40)/2)
           let Width = CGRectGetWidth(self.bottomView.frame)-90-(2*XPos)
            Height = 40
            
            self.bottomViewPadding = YPos
            
           self.messageTxtVw.frame =  CGRectMake(XPos, YPos,Width, Height)
            
            if self.messageTxtVw.text.characters.count != 0 || self.messageTxtVw.text != Chat_TypeYour_Message
            {
                
            }
            else
            {
                
                if self.isNegotiateChat
                {
                    self.messageTxtVw.text = Chat_TypeYour_Amount
                    self.textViewPlaceHolder_Str = Chat_TypeYour_Amount
                }
                else
                {
                    self.messageTxtVw.text = Chat_TypeYour_Message
                    self.textViewPlaceHolder_Str = Chat_TypeYour_Message
                }
               
            }
            
            
            
            
            var frameSendBtn = self.btnSend.frame
            frameSendBtn.origin.y =  self.bottomView.frame.height - self.sendButtonHeight
            frameSendBtn.size.height = self.sendButtonHeight
            self.btnSend.frame = frameSendBtn
            
            
        }

    }
    
    // Method to show last row when calling get chat api and send new message
    
func moveToLastRowInTableView()
{
    if FinalMessageArray.count > 0
    {
        let messageArr = FinalMessageArray.objectAtIndex(FinalMessageArray.count-1).valueForKey("Message") as! NSArray
        
        if messageArr.count > 0
        {
            guard let indexPath = NSIndexPath(forRow: messageArr.count-1, inSection:FinalMessageArray.count-1) as? NSIndexPath else
            {
                return
            }
            
            
            tblVw_For_Chatting.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
            

        }
        
    }

}
    
    func ShowAlertWithButtons()
    {
        infoAlertView! .removeFromSuperview()
        var cgSize:CGSize?
        cgSize = getImageWidthHeight(GRAPHICS.BRIDGE_CONGRATS_DESCRIPTION_IMAGE()!)
        
        if (self.infoAlertView != nil)
        {
            self.infoAlertView!.frame.origin.y = GRAPHICS.Screen_Height()
        }

        infoAlertView = CustomAlert.ShowAlertWithMessageAndMultipleButtons(self, frame: view.frame, Title: "BRIDGE", Message: approveAlert, leftButtonTitle: "YES", rightButtonTitle: "NO") as? UIView
        view.addSubview(infoAlertView!)
        view.bringSubviewToFront( infoAlertView!)
        
        infoAlertView!.frame.origin.y = GRAPHICS.Screen_Height()
        
        UIView.animateWithDuration(1.00, animations:
            { () -> Void in
                
                self.infoAlertView!.frame.origin.y = 0
        })
        

    }
    
     // MARK: UITOOLBAR ABOVE KEYBOARD WITH DONE OPTION FOR NEGOTIATION CHAT
    
    func CreateKeyBoardToolBar()
    {
        keyBoardTool = UIToolbar(frame:CGRectMake(0, 0, view.frame.size.width, 44.0))
        keyBoardTool.barStyle = UIBarStyle.Default
        keyBoardTool.translucent = true
        keyBoardTool.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        keyBoardTool.sizeToFit()
        
        let cgSize:CGSize = getImageWidthHeight(GRAPHICS.PROFILESCREEN_LEFT_ARROW()!)
        let  Width = (cgSize.width)
        let Height = (cgSize.height)
        var YPos:CGFloat = 10.0
        var XPos:CGFloat = 10.0
        
        let btnPrev = UIButton ()
        btnPrev.frame = CGRectMake(XPos, YPos, Width, Height)
        btnPrev.backgroundColor =  UIColor.clearColor();
        //btnPrev.layer.cornerRadius = 7
        btnPrev.setBackgroundImage(GRAPHICS.PROFILESCREEN_LEFT_ARROW(), forState: .Normal)
        btnPrev.addTarget(self, action: Selector("previousAction"), forControlEvents: UIControlEvents.TouchUpInside)
        //keyBoardTool.addSubview(btnPrev)
        
        XPos = 50.0
        YPos = 10.0
        
        let btnNext = UIButton ()
        btnNext.frame = CGRectMake(XPos, YPos, Width, Height)
        btnNext.backgroundColor =  UIColor.clearColor();
        //btnNext.layer.cornerRadius = 7
        btnNext.addTarget(self, action: Selector("nextAction"), forControlEvents: UIControlEvents.TouchUpInside)
        btnNext.setBackgroundImage(GRAPHICS.PROFILESCREEN_RIGHT_ARROW(), forState: .Normal)
       // keyBoardTool.addSubview(btnNext)
        
        let btnDone = UIButton ()
        btnDone.frame = CGRectMake(CGRectGetWidth(self.view.frame)-80, 0, 70, 50)
        btnDone.backgroundColor =  UIColor.clearColor();
        btnDone.layer.cornerRadius = 7
        btnDone .setTitleColor(UIColor(red: 68.0/255.0, green: 130.0/255.0, blue: 223.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
        btnDone.setTitle("Cancel", forState: UIControlState.Normal)
        btnDone.addTarget(self, action: #selector(ChattingRoomViewController.doneAction), forControlEvents: UIControlEvents.TouchUpInside)
        btnDone.titleLabel?.font = GRAPHICS.FONT_BOLD(20)
        keyBoardTool.addSubview(btnDone)
        keyBoardTool.userInteractionEnabled = true
    }
    
    // DONE ACTION FOR KEYBOARD RESIGN WHEN USER ON NEGOTIATION CHAT
    
    func doneAction()
    {
        self.view.endEditing(true)
        resizeTextView(messageTxtVw)
         tblVw_For_Chatting.reloadData()
        changeTableAndBottomPositionWhenResignKeyBoard()
        messageTxtVw.textColor = UIColor.lightGrayColor()
        if isNegotiateChat
        {
            messageTxtVw.text = Chat_TypeYour_Amount
            textViewPlaceHolder_Str = Chat_TypeYour_Amount
            if isMineBool
            {
                approveBtn.hidden = true
            }
            else
            {
                approveBtn.hidden = false
            }
        }
        else
        {
            messageTxtVw.text = Chat_TypeYour_Message
            textViewPlaceHolder_Str = Chat_TypeYour_Message
        }
    }

    func handleApproveBtnAction(sender : UIButton)
    {
        self.view.endEditing(true)
        print("negotiateId_Approve:::\(negotiateId_Approve)")
        print("negotiateAmount_Approve:::\(negotiateAmount_Approve)")
           isApprvedAmount =  true
        showApprovedConfirmAlert(CHAT_APPROVE_ALERT)
        
      
        
    }
    
    override func backBtnAction() {
        // only if comes from teh code scren - from buy flow- need to move to Home page
        
        if isMoveToHome
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
            self.navigationController!.popViewControllerAnimated(true)
//            self.moveToViewControllerInNavStack(BLHomeViewController.self)
        }
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showApprovedConfirmAlert(message:String )
    {
        isOtherUserApproved = true
        var cgSize:CGSize?
        cgSize = getImageWidthHeight(GRAPHICS.BRIDGE_CONGRATS_DESCRIPTION_IMAGE()!)
       
        
        if (self.vwValidation != nil)
        {
            self.vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
        }
        
        
        if isFromNegotiateForOffers // APPROVE FOR NEGOTAITE OFFERS
        {
            
            print("OFFERS NEGOTIATION APPROVE")
            if negotiateItem_BuyerID == Defaults[.userId] // BUYER
            {
                
                let amnt : Int = Int(selectedNegotiate_Quantity)!*Int(Double(negotiateAmount_Approve)!)
                var str = GRAPHICS.getTotalAMountWithServiceFee(String(Double(amnt)))
                let  totalAmount = Double(amnt)
                
                var serviceFee : Double = 0.0
                if totalAmount >= 1 &&  totalAmount <= 9.99 // $1-9
                {
                    serviceFee = Double(0.60)
                }
                else if totalAmount >= 10 &&  totalAmount <= 132.99 // $10-19
                {
                    let feePercent = Double(7.5)
                    serviceFee = (totalAmount*feePercent)/100
                }
                else if totalAmount >= 133 &&  totalAmount <= 199.99
                {
                    let feePercent = Double(10)
                    serviceFee = Double(10)
                }
                    
                else if totalAmount >= 200
                {
                    let feePercent = Double(5.0)
                    serviceFee = (totalAmount*feePercent)/100
                }
                let netAMount : Double = serviceFee + totalAmount
                print("netAMount :::\(netAMount)")
                //let serviceFeeStr = String(format: "%0.2f",Double(String(serviceFee))!)
                str = String(totalAmount+serviceFee)
                // let totalStr = String(format: "%0.2f",Double(String(netAMount))!)
                //            let serviceFeeStr = NSString(format: "%0.2f",Double(String(serviceFee))!)
                //            let totalStr = NSString(format: "%.2f",Double(String(netAMount))!)
                
                vwValidation = CustomAlert.ShowAlertForBuyItNow(self, frame: view.frame, Title: appName, Message: approveAlert, isButtonNeeded: true, Height: 200.0, leftBtnTitle: "Yes", rightBtnTitle: "No",itemCost: String(totalAmount),serviceFee: serviceFee,totalAmount: netAMount ) as? UIView
                
            }
                
            else // SELLER ....NEed to show service charges alert forbuyer when approves amount
            {
                
                vwValidation = CustomAlert.ShowAlertWithMessageAndMultipleButtons(self, frame: view.frame, Title: appName, Message: message, leftButtonTitle: "YES", rightButtonTitle: "NO") as? UIView
                
                
            }

            
            
        }
        else
        {
            if negotiateItem_BuyerID == Defaults[.userId] // BUYER
            {
                
                let amnt : Int = Int(selectedNegotiate_Quantity)!*Int(Double(negotiateAmount_Approve)!)
                var str = GRAPHICS.getTotalAMountWithServiceFee(String(Double(amnt)))
                let  totalAmount = Double(amnt)
                
                var serviceFee : Double = 0.0
                if totalAmount >= 1 &&  totalAmount <= 9.99 // $1-9
                {
                    serviceFee = Double(0.60)
                }
                else if totalAmount >= 10 &&  totalAmount <= 132.99 // $10-19
                {
                    let feePercent = Double(7.5)
                    serviceFee = (totalAmount*feePercent)/100
                }
                else if totalAmount >= 133 &&  totalAmount <= 199.99
                {
                    let feePercent = Double(10)
                    serviceFee = Double(10)
                }
                    
                else if totalAmount >= 200
                {
                    let feePercent = Double(5.0)
                    serviceFee = (totalAmount*feePercent)/100
                }
                let netAMount : Double = serviceFee + totalAmount
                print("netAMount :::\(netAMount)")
                //let serviceFeeStr = String(format: "%0.2f",Double(String(serviceFee))!)
                str = String(totalAmount+serviceFee)
                // let totalStr = String(format: "%0.2f",Double(String(netAMount))!)
                //            let serviceFeeStr = NSString(format: "%0.2f",Double(String(serviceFee))!)
                //            let totalStr = NSString(format: "%.2f",Double(String(netAMount))!)
                
                vwValidation = CustomAlert.ShowAlertForBuyItNow(self, frame: view.frame, Title: appName, Message: approveAlert, isButtonNeeded: true, Height: 200.0, leftBtnTitle: "Yes", rightBtnTitle: "No",itemCost: String(totalAmount),serviceFee: serviceFee,totalAmount: netAMount ) as? UIView
                
            }
                
            else // SELLER ....NEed to show service charges alert forbuyer when approves amount
            {
                
                vwValidation = CustomAlert.ShowAlertWithMessageAndMultipleButtons(self, frame: view.frame, Title: appName, Message: message, leftButtonTitle: "YES", rightButtonTitle: "NO") as? UIView
                
                
            }

        }
      
        
        
      
        
        view.addSubview(vwValidation!)
        view.bringSubviewToFront(vwValidation!)
        
        
        vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
        
        UIView.animateWithDuration(1.00, animations:
            { () -> Void in
                
                self.vwValidation!.frame.origin.y = 0
        })
        
        
    }

    
    
    func showApprovedMessage(message:String )
    {
        if isApprovedMessageShown
        {
    
        }
        else{
            
            isApprovedMessageShown = true
        isOtherUserApproved = true
        var cgSize:CGSize?
        cgSize = getImageWidthHeight(GRAPHICS.BRIDGE_CONGRATS_DESCRIPTION_IMAGE()!)

            if (self.vwValidation != nil)
            {
                self.vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
            }
        
        vwValidation = CustomAlert.ShowAlertWithMessage(self, frame: view.frame, Title: "BRIDGE", Message: message, isButtonNeeded: true, Height: (cgSize?.height)!) as? UIView
    
    view.addSubview(vwValidation!)
    view.bringSubviewToFront(vwValidation!)
    
    
    vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
    
    UIView.animateWithDuration(1.00, animations:
    { () -> Void in
    
    self.vwValidation!.frame.origin.y = 0
    })
            
        }

    }
    func showValidationMessage(message:String ,isButtonNeeded : Bool){
        self.view.endEditing(true)
        resizeTextView(messageTxtVw)
        changeTableAndBottomPositionWhenResignKeyBoard()
       
        
        if (self.vwValidation != nil)
        {
            self.vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
        }
        
        var cgSize:CGSize?
        cgSize = getImageWidthHeight(GRAPHICS.BRIDGE_CONGRATS_DESCRIPTION_IMAGE()!)
        
        if isButtonNeeded
        {

        vwValidation = CustomAlert.ShowAlertWithMessageAndMultipleButtons(self, frame: view.frame, Title: "NEGOTIATE", Message: message, leftButtonTitle: YES_TITLE, rightButtonTitle: NO_TITLE) as? UIView
        
        }
        else
        {
            isApproved = true
       vwValidation = CustomAlert.ShowAlertWithMessage(self, frame: view.frame, Title: "NEGOTIATE", Message: message, isButtonNeeded: true, Height: (cgSize?.height)!) as? UIView
        }
        view.addSubview(vwValidation!)
        view.bringSubviewToFront(vwValidation!)
        
        
        vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
        
        UIView.animateWithDuration(1.00, animations:
            { () -> Void in
                
                self.vwValidation!.frame.origin.y = 0
        })
        
    
        
    }
    
    
    
  

    func handleLeftButtonAction()
    {
        
        
        
        UIView.animateWithDuration(1.00, animations:
            { () -> Void in
                if (self.vwValidation != nil)
                {
                    self.vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
                }
        })
        
       

        if isApprvedAmount
            
        {
            if ApiTimer != nil{
                ApiTimer.invalidate()
                ApiTimer = nil
            }
            
            if isFromNegotiateForOffers // APPROVE FOR NEGOTAITE OFFERS
            {
                
                print("OFFERS NEGOTIATION APPROVE")
                if negotiateItem_BuyerID == Defaults[.userId] // BUYER
                {
                    
                }
                else
                {
                    appdelegate.showLoadingIndicator()
                    ServerAPI().API_ApproveOffersNegotiation(Defaults[.userId], bid_amount: negotiateAmount_Approve, item_id: negotiateItem_itemID, bid_id: negotiate_BidId, request_user_id: negotiateItem_BuyerID, pay_id: "",negotiate_id : negotiateId_Approve,card_id:"",delegate: self)
                }
                
            }
            else
            {
                
                
                    if itemEntity.itemTypeStr as String == "2" &&  itemEntity.deliveryTypeStr as String == "2" // ELECTRONIC SERVIESE NO NEED TO SHOW SELECT QUANTITY PAGE
                    {
                        
                        
                        if Defaults[.userId] == itemEntity.buyer_id as String
                        {
                            print("BUYER")
                            appdelegate.showLoadingIndicator()
                            ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                            
                           
                        }
                        else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
                        {
                            print("FROM HOME")
                            appdelegate.showLoadingIndicator()
                            ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                        }
                        else
                        {
                            print("SELLER")
                            appdelegate.showLoadingIndicator()
                            print("Buyer ID::::\(itemEntity.buyer_id)")
                            ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve, tips: "0",delegate: self)
                            
                        }
                        
                    }
                    else if itemEntity.itemTypeStr as String == "2" &&  itemEntity.deliveryTypeStr as String == "1" // PHYSICAL SERVICE NO NEED TO SHOW SELECT QUANTITY PAGE
                    {
                        
                     
                        
                        if Defaults[.userId] == itemEntity.buyer_id as String // BUYER
                        {
                            appdelegate.showLoadingIndicator()
                            ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                        }
                        else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
                        {
                            print("FROM HOME")
                           
                            appdelegate.showLoadingIndicator()
                            ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                        }
                            
                            
                        else
                        {
                           
                            appdelegate.showLoadingIndicator()
                            ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                            
                            
                        }
                        
                        
                        
                    }
                        
                    else
                    {
                        appdelegate.hideLoadingIndicator()
                        
                        if selectedNegotiate_Quantity == ""
                            
                        {
                            selectedNegotiate_Quantity = negotiateId_quantity//itemEntity.itemQuanityStr as String
                        }
                        if isApprvedAmount
                        {
                            selectedNegotiate_Quantity = negotiateId_quantity
                        }
                        
                        
                        appdelegate.showLoadingIndicator()
                        print(Defaults[.userId],itemEntity.itemIdStr,selectedNegotiate_Quantity)
                        
                        
                        itemEntity.buyer_id =  negotiateItem_BuyerID
                        
                        if Defaults[.userId] == itemEntity.buyer_id as String // BUYER
                        {
                            
                            
                            ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity, negotiate_id : negotiateId_Approve,tips: "0",delegate: self)
                            
                        }
                        else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
                        {
                            print("FROM HOME")
                           
                            
                            ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity, negotiate_id : negotiateId_Approve,tips: "0",delegate: self)
                            
                        }
                        else
                        {
                            ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity,negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                        }
                        
                        
                        
                      }
        }
           
        }
        else{
            
        }
       
      
    }
    
    func handleRightButtonAction()
    {
        UIView.animateWithDuration(1.00, animations:
            { () -> Void in
                
                self.vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
        })
        
    }
    
    func moveToHomeScreen()
    {
        appdelegate.hideLoadingIndicator()

        showValidationMessage("Approved successfully",isButtonNeeded: false)
        
    }
    
    // MARK: -  CHAT API DELEGATES
    func API_CALLBACK_Error(errorNumber: Int, errorMessage: String)
    {
        self.view.endEditing(true)
        appdelegate.hideLoadingIndicator()
        print(errorMessage)
       
    }
    
    func API_CALLBACK_GetChat(resultDict: NSDictionary)
    {
    
        appdelegate.hideLoadingIndicator()
        
        if resultDict.objectForKey("response_code") as! String == STATUS_CODE_1
        {
          
            let chatMessageList = (GRAPHICS.checkKeyNotAvailForArray((resultDict) , key:"result") as! NSArray)
            
            array_For_Messages.removeAllObjects()
            FinalMessageArray.removeAllObjects()
            
            for i in 0 ..< chatMessageList.count
            {
                let chatDict = chatMessageList.objectAtIndex(i) as! NSDictionary
                
                let chatEntity = BLChatEntity.init(dic: chatDict)
                
                array_For_Messages.addObject(chatEntity)
                
               
            }
            
            
            getDatesArray.removeAllObjects()
            
            for i in 0 ..< array_For_Messages.count
            {
                let chatEnt = array_For_Messages .objectAtIndex(i)as! BLChatEntity
                
                let dateStr = chatEnt.chat_date_time as NSString
                
                
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dat = dateFormatter.dateFromString(dateStr as String)
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dat1 = dateFormatter.stringFromDate(dat!)
                
               getDatesArray.addObject(dat1)
                
            }
            
            let datesArray = NSMutableArray()
            for headerDateString in getDatesArray
            {
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let sectionDate = dateFormatter.dateFromString(headerDateString as! String)
                datesArray.addObject(sectionDate!)
            }

            let uniquearray = datesArray.valueForKeyPath("@distinctUnionOfObjects.self") as! NSArray
            
            let sortedArray = uniquearray.sortedArrayUsingComparator {
                (obj1, obj2) -> NSComparisonResult in
                
                let p1 = obj1 as! NSDate
                let p2 = obj2 as! NSDate
                let result = p1.compare(p2 as NSDate)
                return result
            }
            
           // SORTING MESSGAES BASED ON DATE
            
            for i in 0 ..< sortedArray.count
            {
                let dateStr = sortedArray[i] as! NSDate
               
                let addMessEntMut : NSMutableArray = NSMutableArray()
                
                for j in 0 ..< array_For_Messages.count
                {
                    
                    let chatInboxEnt = array_For_Messages .objectAtIndex(j)as! BLChatEntity
                    
                    chatInboxEnt.chat_message =  chatInboxEnt.chat_message .stringByRemovingPercentEncoding!
                    
                    if chatInboxEnt.chatDate!.isEqualToDateIgnoringTime(dateStr)
                    {
                        addMessEntMut.addObject(chatInboxEnt)
                    }
                }
                
                
                let messArray : NSMutableArray = addMessEntMut
                let dic = ["Date" : dateStr,"Message" : messArray]
                FinalMessageArray.addObject(dic)
            }

            
             // FINDING HERE NUMBER OF MESSAGES AND LAST MESSAGE SENT  BY WHOM
            
            var checkingMsgCount = 0

            for i in 0 ..< FinalMessageArray.count
            {
                
                let dayArray = FinalMessageArray.objectAtIndex(i) as! NSDictionary
                let messageArr = dayArray.valueForKey("Message") as! NSArray
                checkingMsgCount =  checkingMsgCount + messageArr.count
                
                let chatEnt = messageArr.objectAtIndex(messageArr.count-1)as! BLChatEntity
                
                if chatEnt.user_id == Defaults[.userId]
                {
                    isMineBool = true
                }
                else
                {
                    isMineBool = false
                }
                
                
            }
             // CONDITION FOR RELOAD TABLEVIEW IF THERE IS ANY NEW MESSAGE ARRAIVAL
            
            if checkingMsgCount > m_MessageCount
            {
                m_MessageCount = checkingMsgCount
                tblVw_For_Chatting.reloadData()
                moveToLastRowInTableView()
            }
            else
            {
                m_MessageCount = checkingMsgCount
                
            }
            
             m_TotalMessageCount = checkingMsgCount
        }


    
    }
    func API_CALLBACK_SendChat(resultDict: NSDictionary)
    {
        
        
        //print("CHAT RESULT::::\(resultDict)")
        
        if resultDict.objectForKey("response_code") as! String == STATUS_CODE_1
        {
            appdelegate.showLoadingIndicator()
            
            callApiForGetChatDetails()
            
            
        }
        else
        {
            appdelegate.hideLoadingIndicator()

        }

        
        
    }
    
    func API_CALLBACK_GetNegotiationChat(resultDict: NSDictionary)
    {
        
        appdelegate.hideLoadingIndicator()

        //print("Get Negotiation RESULT::::\(resultDict)")
        var isApprovedPrice = "0"
        var checkingMsgCount = 0

        if resultDict.objectForKey("response_code") as! String == STATUS_CODE_1
        {
            
            let negotiateMessageList = (GRAPHICS.checkKeyNotAvailForArray((resultDict) , key:"result") as! NSArray)
                
            array_For_Messages.removeAllObjects()
            FinalMessageArray.removeAllObjects()
            
            for i in 0 ..< negotiateMessageList.count
            {
                let chatDict = negotiateMessageList.objectAtIndex(i) as! NSDictionary
                
                let chatEntity = BLChatEntity.init(dic: chatDict)
                
                array_For_Messages.addObject(chatEntity)
                
                
            }
            
            getDatesArray.removeAllObjects()
            
            for i in 0 ..< array_For_Messages.count
            {
                let chatEnt = array_For_Messages .objectAtIndex(i)as! BLChatEntity
                
                let dateStr = chatEnt.date_sent as NSString
                let dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dat = dateFormatter.dateFromString(dateStr as String)
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let dat1 = dateFormatter.stringFromDate(dat!)
                getDatesArray.addObject(dat1)
                
            }
            
            let datesArray = NSMutableArray()
            
            
            for headerDateString in getDatesArray
            {
             
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let sectionDate = dateFormatter.dateFromString(headerDateString as! String)
                
                datesArray.addObject(sectionDate!)
            }
            
                       let uniquearray = datesArray.valueForKeyPath("@distinctUnionOfObjects.self") as! NSArray
            
            let sortedArray = uniquearray.sortedArrayUsingComparator {
                (obj1, obj2) -> NSComparisonResult in
                
                let p1 = obj1 as! NSDate
                let p2 = obj2 as! NSDate
                let result = p1.compare(p2 as NSDate)
                return result
            }
            
            for i in 0 ..< sortedArray.count
            {
                let dateStr = sortedArray[i] as! NSDate
                
                let addMessEntMut : NSMutableArray = NSMutableArray()
                
                for j in 0 ..< array_For_Messages.count
                {
                    let chatInboxEnt = array_For_Messages .objectAtIndex(j)as! BLChatEntity
                    
                    chatInboxEnt.chat_message =  chatInboxEnt.chat_message .stringByRemovingPercentEncoding!
                    
                    if chatInboxEnt.chatDate_Negotiate!.isEqualToDateIgnoringTime(dateStr)
                   {
                        addMessEntMut.addObject(chatInboxEnt)
                    }
                }
                
                
                let messArray : NSMutableArray = addMessEntMut
                let dic = ["Date" : dateStr,"Message" : messArray]
                FinalMessageArray.addObject(dic)
            }
            
            // FINDING HERE NUMBER OF MESSAGES , LAST MESSAGE SENT  BY WHOM AND HIDDING APPROVE BUTTON
            
            if FinalMessageArray.count > 0
            {
                for i in 0 ..< FinalMessageArray.count
                {
                    
                    let dayArray = FinalMessageArray.objectAtIndex(i) as! NSDictionary
                    let messageArr = dayArray.valueForKey("Message") as! NSArray
                    
                  
                    checkingMsgCount =  checkingMsgCount + messageArr.count
                    
                    let chatEnt = messageArr.objectAtIndex(messageArr.count-1)as! BLChatEntity
                    isApprovedPrice = chatEnt.approved as! String
                    if chatEnt.user_id == Defaults[.userId]
                    {
                        isMineBool = true
                    }
                    else
                    {
                        isMineBool = false
                        negotiateId_Approve = chatEnt.negotiate_id as String
                         negotiateAmount_Approve = chatEnt.negitation_amount as String
                        negotiateId_quantity = chatEnt.quantityStr as String
                        negotiateItem_BuyerID = chatEnt.negotiate_buyer_id as String
                        isFromNegotiateForOffers  = false
                        selectedNegotiate_Quantity = chatEnt.quantityStr as String
                        if chatEnt.bidID_Str as String != "0" && chatEnt.bidID_Str as String != ""
                        {
                            isFromNegotiateForOffers =  true
                        }
                        
                        if isFromNegotiateForOffers
                        {
                            negotiateItem_BuyerID = chatEnt.negotiate_Offerbuyer_id as String
                            negotiateItem_itemID = chatEnt.item_id as String
                            negotiate_BidId = chatEnt.bidID_Str as String
                            negotiateOffers_ItemName = chatEnt.itemName_Str as String
                            selectedNegotiate_Quantity = chatEnt.quantityStr as String
                        }
                    }
                    
                    
                }
                if isMineBool
                {
                    approveBtn.hidden = true
                    
                    
                    
                }
                else
                {
                    approveBtn.hidden = false
                    
                }
                
                
               // CONDITION FOR RELOAD TABLEVIEW IF THERE IS ANY NEW MESSAGE ARRAIVAL
                if checkingMsgCount > m_MessageCount
                {
                    m_MessageCount = checkingMsgCount
                    tblVw_For_Chatting.reloadData()
                     approveBtn.userInteractionEnabled = true
                    moveToLastRowInTableView()
                }
                else
                {
                    
                    m_MessageCount = checkingMsgCount
                    if isMineBool
                    {
                        approveBtn.hidden = true
                        if vwValidation == nil{
                            showValidationMessage(NEGOTIATE_ALERT ,isButtonNeeded : false)
                            
                        }
                        
                        btnSend.enabled = false
                        bottomView.userInteractionEnabled = false
                        
                    }
                    else
                    {

                        btnSend.enabled = true

                        approveBtn.hidden = false
                        bottomView.userInteractionEnabled = true
                    }

                }
              
                m_TotalMessageCount = checkingMsgCount
            }
                
            else
            {
                isMineBool = false
                 approveBtn.hidden = true
            }
           }
        
        else if resultDict.objectForKey("response_code") as! String == STATUS_CODE_2
        {
            if ApiTimer != nil{
                ApiTimer.invalidate()
                ApiTimer = nil
            }
            approveBtn.hidden = true
            if vwValidation == nil{
                vwValidation?.removeFromSuperview()
                //showValidationMessage(NEGOTIATE_ALERT ,isButtonNeeded : false)
                isOtherUserApproved = true
                
                
                if isFromNegotiateForOffers
                {
                    if itemEntity.userIdStr == Defaults[.userId] // IN REQUESt,Seller is Buyer
                    {
                        showValidationMessage("Your negotiation was approved!",isButtonNeeded : false)
                    }
                    else
                    {
                        showValidationMessage(CHAT_PRICE_APPROVED_ALERT,isButtonNeeded : false)
                        
                    }

                }
                else
                {
                    if itemEntity.userIdStr == Defaults[.userId] // SELLER
                    {
                        showValidationMessage(CHAT_PRICE_APPROVED_ALERT,isButtonNeeded : false)
                    }
                    else
                    {
                        showValidationMessage("Your negotiation was approved!",isButtonNeeded : false)
                        
                    }

                }
               
                
            }
            
            btnSend.enabled = false
            bottomView.userInteractionEnabled = false
            return

        }
        
        
        if isApprovedPrice == "1"
        {
            if ApiTimer != nil{
                ApiTimer.invalidate()
                ApiTimer = nil
            }
            
            if itemEntity.userIdStr == Defaults[.userId]
            {
                 showApprovedMessage(CHAT_PRICE_APPROVED_ALERT)
            }
            else
            {
                showApprovedMessage("Your negotiation was approved!")
                
            }
            
           
            tblVw_For_Chatting.userInteractionEnabled = false

        }
        
        appdelegate.hideLoadingIndicator()
        

    }
    
    func API_CALLBACK_SendNegotiationChat(resultDict: NSDictionary)
    {
      
//        appdelegate.hideLoadingIndicator()
        print("Send Negotiation RESULT::::\(resultDict)")
        
        if resultDict.objectForKey("response_code") as! String == STATUS_CODE_1
        {
            callApiForGetChatDetails()
        }
        
    }
    
    func API_CALLBACK_ApproveNegotiationAmount(resultDict: NSDictionary)
    {
        
        print("APPROVE  Negotiation RESULT::::\(resultDict)")
        
        if resultDict.objectForKey("response_code") as! String == STATUS_CODE_1
        {
            
            
            
            
                if itemEntity.itemTypeStr as String == "2" &&  itemEntity.deliveryTypeStr as String == "2" // ELECTRONIC SERVIESE NO NEED TO SHOW SELECT QUANTITY PAGE
                {
                    appdelegate.showLoadingIndicator()
                   // ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1", delegate: self)
                    
                    if Defaults[.userId] == itemEntity.buyer_id as String
                    {
                        print("BUYER")
                        
                        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                        
                        
                       // ServerAPI().API_PayForItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1", delegate: self)
                    }
                    else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
                    {
                        print("FROM HOME")
                       // ServerAPI().API_PayForItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1", delegate: self)
                        
                        
                         ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                    }
                    else
                    {
                        print("SELLER")
                        
                        print("Buyer ID::::\(itemEntity.buyer_id)")
                        ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: "1", negotiate_id : negotiateId_Approve,tips: "0",delegate: self)
                        
//                        ServerAPI().API_PayForItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: "1", delegate: self)
                        
                    }
                    
                }
                else if itemEntity.itemTypeStr as String == "2" &&  itemEntity.deliveryTypeStr as String == "1" // PHYSICAL SERVICE NO NEED TO SHOW SELECT QUANTITY PAGE
                {
                    appdelegate.showLoadingIndicator()
                    //ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1", delegate: self)
                    
                    if Defaults[.userId] == itemEntity.buyer_id as String // BUYER
                    {
//                        ServerAPI().API_PayForItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1", delegate: self)
                        
                        
                        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                    }
                    else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
                    {
                        print("FROM HOME")
//                        ServerAPI().API_PayForItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1", delegate: self)
                        
                        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                    }
                        
                        
                    else
                    {
                        //ServerAPI().API_PayForItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: "1", delegate: self)
                        
                        ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                        
                        
                    }
                    
                    
                    
                }

                else
                {
                    appdelegate.hideLoadingIndicator()

                    if selectedNegotiate_Quantity == ""
                        
                    {
                        selectedNegotiate_Quantity = negotiateId_quantity//itemEntity.itemQuanityStr as String
                    }
                    if isApprvedAmount
                    {
                        selectedNegotiate_Quantity = negotiateId_quantity
                    }

                    
                        appdelegate.showLoadingIndicator()
                        print(Defaults[.userId],itemEntity.itemIdStr,selectedNegotiate_Quantity)
                    
                    if Defaults[.userId] == itemEntity.buyer_id as String // BUYER
                    {
//                        ServerAPI().API_PayForItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity, delegate: self)
                        
                        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity,negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                        
                    }
                    else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
                    {
                        print("FROM HOME")
//                        ServerAPI().API_PayForItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity, delegate: self)
                        
                        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity,negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                        
                    }
                    else
                    {
                       // ServerAPI().API_PayForItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity, delegate: self)
                        
                        
                        ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity,negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                    }

                    
                    
                }
            
           
            }

        else
        {
        }
    }
    
       
    
    func API_CALLBACK_BuyItem(resultDict : NSDictionary)
    {
        //appdelegate.hideLoadingIndicator()
        print("BUY ITEM RESULT::::\(resultDict)")
        
        
        if resultDict.objectForKey("response_code") as! String == STATUS_CODE_1
        {
            
            appdelegate.showLoadingIndicator()
            
            
            
            let quantityStr  = String(selectedNegotiate_Quantity)
            
            let str = GRAPHICS.getTotalAMountWithServiceFee(String(negotiateAmount_Approve))
            
             totalInt = Int(Double(negotiateAmount_Approve)!)
            
            let  totalAmount = Double(totalInt)
            
            
            
            
            var serviceFee : Double = 0.0
            
            if totalAmount >= 1 &&  totalAmount <= 9.99 // $1-9
            {
                serviceFee = Double(0.60)
            }
            else if totalAmount >= 10 &&  totalAmount <= 132.99 // $10-19
            {
                let feePercent = Double(7.5)
                serviceFee = (totalAmount*feePercent)/100
            }
            else if totalAmount >= 133 &&  totalAmount <= 199.99
            {
                let feePercent = Double(10)
                serviceFee = Double(10)
            }
                
            else if totalAmount >= 200
            {
                let feePercent = Double(5.0)
                serviceFee = (totalAmount*feePercent)/100
            }
            
            
            let serviceFeeStr = String(format: "%0.2f",Double(String(serviceFee))!)
            let totalStr = String(format: "%0.2f",Double(String(str))!)

          let dict = resultDict.objectForKey("result") as! NSDictionary
//            
            let itemCostStr = dict.objectForKey("item_cost") as! NSString
           let itemNameStr = dict.objectForKey("item_name") as! NSString
            let itemQuantityStr = dict.objectForKey("item_quantity") as! NSString
           let itemTotalCostStr = dict.objectForKey("total_cost") as! NSString
            itemEntity.itemCostStr = itemCostStr
            
            let paymentModeStr = itemEntity.paymentModeStr as String
            print("PAY :::: \(paymentModeStr)")
            
            if paymentModeStr == "3"
            {
                
                if itemEntity.buyer_id == Defaults[.userId] // BUYER
                {
                   // appdelegate.showLoadingIndicator()
                    callPayPal(itemNameStr as String, totalCost: itemTotalCostStr as String , ItemQuantity: Int(itemQuantityStr as String)!, ItemCost: itemCostStr as String)
                }
                else
                {
                    //appdelegate.showLoadingIndicator()
                    ServerAPI().API_PayItem_PayPal(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: itemQuantityStr as String, item_cost: itemCostStr as String, total_cost: itemTotalCostStr as String, pay_id: "0", process_fee: serviceFeeStr, is_nagotiation: "1", negotiate_id: negotiateId_Approve,tips: "0",card_id:"", delegate: self)
                }
               
                
               
            }
            else{
                let quantityStr  = selectedNegotiate_Quantity
                
                if itemEntity.buyer_id == Defaults[.userId] // BUYER
                {
                    

                    callPayPal(itemNameStr as String, totalCost: totalStr as String, ItemQuantity: Int(itemQuantityStr as String)!, ItemCost: itemCostStr as String)
                }
                else
                {
                    
                    
                    ServerAPI().API_PayItem_PayPal(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: itemQuantityStr as String, item_cost: itemCostStr as String, total_cost:itemTotalCostStr as String, pay_id: "0", process_fee: serviceFeeStr, is_nagotiation: "1", negotiate_id: negotiateId_Approve,tips: "0",card_id:"", delegate: self)
                    
                }
                
               

            }
            
           
        }
            
        else if resultDict.objectForKey("response_code") as! String == STATUS_CODE_2
        {
            let quantityStr  = String(selectedNegotiate_Quantity)
            
            
            
            
            
            let str = GRAPHICS.getTotalAMountWithServiceFee(String(negotiateAmount_Approve))
            
            totalInt = Int(Double(negotiateAmount_Approve)!)
            
            let  totalAmount = Double(totalInt)
            
            
            
            
            var serviceFee : Double = 0.0
            
            if totalAmount >= 1 &&  totalAmount <= 9.99 // $1-9
            {
                serviceFee = Double(0.60)
            }
            else if totalAmount >= 10 &&  totalAmount <= 132.99 // $10-19
            {
                let feePercent = Double(7.5)
                serviceFee = (totalAmount*feePercent)/100
            }
            else if totalAmount >= 133 &&  totalAmount <= 199.99
            {
                let feePercent = Double(10)
                serviceFee = Double(10)
            }
                
            else if totalAmount >= 200
            {
                let feePercent = Double(5.0)
                serviceFee = (totalAmount*feePercent)/100
            }
            
            
            let serviceFeeStr = String(format: "%0.2f",Double(String(serviceFee))!)
            let totalStr = String(format: "%0.2f",Double(String(str))!)
            
            let dict = resultDict.objectForKey("result") as! NSDictionary
            //
            let itemCostStr = dict.objectForKey("item_cost") as! NSString
            let itemNameStr = dict.objectForKey("item_name") as! NSString
            let itemQuantityStr = dict.objectForKey("item_quantity") as! NSString
             let itemTotalCostStr = dict.objectForKey("total_cost") as! NSString
            let paymentModeStr = itemEntity.paymentModeStr as String
            print("PAY :::: \(paymentModeStr)")
            
            
            itemEntity.buyer_id = negotiateItem_BuyerID
            if paymentModeStr == "3"
            {
                
                
                if itemEntity.buyer_id == Defaults[.userId] // BUYER
                {
                    
                    // CHECKING FOR NEW FLOW AUG 12
                    
                    
                    
                    callPayPal(itemNameStr as String, totalCost: itemTotalCostStr as String, ItemQuantity: Int(itemQuantityStr as String)!, ItemCost: itemCostStr as String)
                }
                else
                {
                    appdelegate.showLoadingIndicator()
                    ServerAPI().API_PayItem_PayPal(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: itemQuantityStr as String, item_cost: itemCostStr as String, total_cost: itemTotalCostStr as String, pay_id: "", process_fee: serviceFeeStr as String, is_nagotiation: "1", negotiate_id: negotiateId_Approve,tips: "0",card_id:"", delegate: self)
                }
                
                
                
            }
            else{
                let quantityStr  = selectedNegotiate_Quantity
               if itemEntity.buyer_id == Defaults[.userId] // BUYER
                {
                    callPayPal(itemNameStr as String, totalCost: itemTotalCostStr as String, ItemQuantity: Int(itemQuantityStr as String)!, ItemCost: itemCostStr as String)
                }
                else
                {
                   // appdelegate.showLoadingIndicator()
                    ServerAPI().API_PayItem_PayPal(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: itemQuantityStr as String, item_cost: itemCostStr as String, total_cost: itemTotalCostStr as String, pay_id: "", process_fee: serviceFeeStr as String, is_nagotiation: "1", negotiate_id: negotiateId_Approve,tips: "0",card_id:"", delegate: self)
                }

                
            }
        }
        else
        {
            appdelegate.hideLoadingIndicator()
            //neetToMoveHome = false
            
            if Defaults[.isFromNotification] == "1"
            {
                 showValidationMessage(resultDict.objectForKey("message") as! String,isButtonNeeded: false)
            }
            else
            {
                 showValidationMessage(resultDict.objectForKey("message") as! String,isButtonNeeded: true)
            }
            
        }
        
    }
    
    func API_CALLBACK_PayForItem(resultDict: NSDictionary)
    {
        print("PAY ITEM RESULT::::\(resultDict)")
        
       
        if resultDict.objectForKey("response_code") as! String == STATUS_CODE_1
        {
            
            if itemEntity.itemTypeStr == "1" // GOODS
            {
                if itemEntity.deliveryTypeStr == "2" // ELECTRONICS GOODS
                {
                   // neetToMoveHome = true
                    
                    if Defaults[.userId] == itemEntity.buyer_id as String // BUYER
                    {
                         appdelegate.hideLoadingIndicator()
                        showValidationMessage(ELECTRONIC_GOODS_ALERT, isButtonNeeded: true)
                    }
                    else
                    {
                         appdelegate.hideLoadingIndicator()
                        showValidationMessage(ELECTRONIC_GOODS_ALERT, isButtonNeeded: true)
                        
                    }

                    
                    
                }
                else  if Defaults[.userId] == itemEntity.buyer_id as String
                {
                     appdelegate.hideLoadingIndicator()
                    UIView.animateWithDuration(1.00, animations:
                        { () -> Void in
                            
                            self.vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
                    })

                    let result = resultDict.objectForKey("result") as! NSDictionary
                    print("UNIQUE CODE::::\(result.valueForKey("unique_code"))")
                    
                    let verifyCodeVc = BLVerifyCodeViewController()
                    verifyCodeVc.itemEntity = itemEntity
                    verifyCodeVc.uniqueCodeString = result.valueForKey("unique_code") as! String
                    self.navigationController?.pushViewController(verifyCodeVc, animated: true)
                    
                }
                else
                {
                     appdelegate.hideLoadingIndicator()

                }
            }
            appdelegate.hideLoadingIndicator()
        }
        else
        {
             appdelegate.hideLoadingIndicator()
           // neetToMoveHome = false
            showValidationMessage(resultDict.objectForKey("message") as! String,isButtonNeeded: false)
        }
    }

    
    override func refreshScreen(typeId:String,type:String,itemId:String,paymentId : String,isFromBackground:Bool)  -> Bool {
        // refresh the screen
        
        
        self.view.endEditing(true)
        isFromRefresh = true
        
        itemPaymentIdFromRefresh = paymentId
        notificationType = type
        notification_itemId = itemId
        notification_BuyerId = typeId
        Defaults[.paymentID] = paymentId
        
        
        
        
        Defaults[.BUYERID_FROM_NOTIFICATION_NEGOTIATION] = notification_BuyerId
        Defaults[.ITEMID_FROM_NOTIFICATION_NEGOTIATION] = notification_itemId
        
        if type == "Chat"
        {
            isNegotiateChat  = false
        }
        
        

        if itemEntity.itemIdStr.length == 0 // no item entity
        {
             appdelegate.showLoadingIndicator()
            if Defaults[.isFromNegotiateOffers] == "1"
            {
                 ServerAPI().API_getItemDetails(Defaults[.userId], item_id: itemId,buyer_id : Defaults[.userId],payment_id : paymentId, delegate: self)
            }
            else
            {
                 ServerAPI().API_getItemDetails(Defaults[.userId], item_id: itemId,buyer_id : typeId,payment_id : paymentId, delegate: self)
           }
            
           
            
           
        }

        if itemEntity.itemIdStr == itemId
        {
            return true
        }
        else
        {
            return false

        }
        
    }
    
    
    func API_CALLBACK_getItemDetails(resultDict: NSDictionary) {
        
        
       print("GET ITEM DETAILS:::\(resultDict)")
        
        if resultDict.objectForKey("response_code") as! String == STATUS_CODE_1
        {
            
            guard let itemDicts = resultDict.objectForKey("result") else
            {
                return
            }
            let itemDict = itemDicts as! NSDictionary
            
            if itemDict.allKeys.count > 0
            {
                itemEntity = BLGoodsItemEntity.init(dic: itemDict )
                
                callApiForGetChatDetails()
                        
                    }
                    else
                        {
                            appdelegate.hideLoadingIndicator()

            }
                }
            
                
            else
        {
            appdelegate.hideLoadingIndicator()

        }
                
            }
    
    
    func handleDetailsBtnnAction(sender : UIButton)
    {
        
        if forAction == ACTION_STATES_CHAT.FINISHED_TRANSACTION_DETAILS.rawValue
        {
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            do
            {
                
                var isPopUp = false
                
                
                if let viewControllers = self.navigationController?.viewControllers
                {
                    for vc in viewControllers
                    {
                        if vc .isKindOfClass(BLServiceProfileVC)
                        {
                            isPopUp = true
                            
                            let vc1 = vc as! BLServiceProfileVC
                            Defaults[.paymentID] = itemEntity.paymentIdStr as String
                            if itemEntity.buyer_id as String == ""
                            {
                                if isFromRefresh
                                {
                                    vc1.CallAPiForDetailsWhenComeFromChatPage(Defaults[.userId], ItemId: itemEntity.itemIdStr as String,paymentId: itemPaymentIdFromRefresh)
                                    
                                    Defaults[.paymentID_from_Chat_detailsWhenPopingVC] = itemPaymentIdFromRefresh
                                    Defaults[.itemID_from_Chat_detailsWhenPopingVC] = itemEntity.itemIdStr as String
                                    Defaults[.buyerID_from_Chat_detailsWhenPopingVC] = Defaults[.userId]
                                }
                                else
                                {
                                    vc1.CallAPiForDetailsWhenComeFromChatPage(Defaults[.userId], ItemId: itemEntity.itemIdStr as String,paymentId: itemEntity.paymentIdStr as String)
                                    
                                    
                                    
                                    Defaults[.paymentID_from_Chat_detailsWhenPopingVC] = itemEntity.paymentIdStr as String
                                    Defaults[.itemID_from_Chat_detailsWhenPopingVC] = itemEntity.itemIdStr as String
                                    Defaults[.buyerID_from_Chat_detailsWhenPopingVC] = Defaults[.userId]
                                }
                                vc1.CallAPiForDetailsWhenComeFromChatPage(Defaults[.userId], ItemId: itemEntity.itemIdStr as String,paymentId: itemEntity.paymentIdStr as String)
                                
                                
                                Defaults[.paymentID_from_Chat_detailsWhenPopingVC] = itemEntity.paymentIdStr as String
                                Defaults[.itemID_from_Chat_detailsWhenPopingVC] = itemEntity.itemIdStr as String
                                Defaults[.buyerID_from_Chat_detailsWhenPopingVC] = Defaults[.userId]
                            }
                            else
                            {
                                
                                if isFromRefresh
                                {
                                    vc1.CallAPiForDetailsWhenComeFromChatPage(itemEntity.buyer_id as String, ItemId: itemEntity.itemIdStr as String,paymentId: itemPaymentIdFromRefresh)
                                    
                                    Defaults[.paymentID_from_Chat_detailsWhenPopingVC] = itemPaymentIdFromRefresh
                                    Defaults[.itemID_from_Chat_detailsWhenPopingVC] = itemEntity.itemIdStr as String
                                    Defaults[.buyerID_from_Chat_detailsWhenPopingVC] = itemEntity.buyer_id as String
                                }
                                else
                                {
                                    vc1.CallAPiForDetailsWhenComeFromChatPage(itemEntity.buyer_id as String, ItemId: itemEntity.itemIdStr as String,paymentId: itemEntity.paymentIdStr as String)
                                    
                                    Defaults[.paymentID_from_Chat_detailsWhenPopingVC] = itemEntity.paymentIdStr as String
                                    Defaults[.itemID_from_Chat_detailsWhenPopingVC] = itemEntity.itemIdStr as String
                                    Defaults[.buyerID_from_Chat_detailsWhenPopingVC] = itemEntity.buyer_id as String
                                }
                                
                            }
                            
                            Defaults[.isFromChatDetailsPageWhilePoping] = "TRUE"
                            
                            
                            self.navigationController!.popToViewController(vc1, animated: true)
                        }
                    }
                }
                if(!isPopUp)
                {
                     Defaults[.paymentID] = itemEntity.paymentIdStr as String
                    Defaults[.isFromChatDetailsPageWhilePoping] = "FALSE"
                    let vc = BLServiceProfileVC()
                    vc.itemEntity = itemEntity
                   
                    vc.isComingFromChatDetailsWhenDetailsPageNotInStack = true
                    self.navigationController!.pushViewController(vc, animated: true)
                }
                
            }
            catch
            {
                print ("Error on moving to Home screen")
                
            }

        }
       
    }
    
    
    func  handleBuyItNowLeftButtonAction()
    {
                    if (self.vwValidation != nil)
                    {
                        self.vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
                    }
        
        createViewForPayOptionsToBuy()
        
//        if isApprvedAmount
//            
//        {
//            if (self.vwValidation != nil)
//            {
//                self.vwValidation!.frame.origin.y = GRAPHICS.Screen_Height()
//            }
//            
//            if isFromNegotiateForOffers
//            {
//                    print("NEGOTIATE OFFERS BUY NOW")
//                
//                
//                
//                
//                let amnt : Int = Int(selectedNegotiate_Quantity)!*Int(Double(negotiateAmount_Approve)!)
//                var str = GRAPHICS.getTotalAMountWithServiceFee(String(Double(amnt)))
//                let  totalAmount = Double(amnt)
//                
//                var serviceFee : Double = 0.0
//                if totalAmount >= 1 &&  totalAmount <= 9.99 // $1-9
//                {
//                    serviceFee = Double(0.60)
//                }
//                else if totalAmount >= 10 &&  totalAmount <= 132.99 // $10-19
//                {
//                    let feePercent = Double(7.5)
//                    serviceFee = (totalAmount*feePercent)/100
//                }
//                else if totalAmount >= 133 &&  totalAmount <= 199.99
//                {
//                    let feePercent = Double(10)
//                    serviceFee = Double(10)
//                }
//                    
//                else if totalAmount >= 200
//                {
//                    let feePercent = Double(5.0)
//                    serviceFee = (totalAmount*feePercent)/100
//                }
//                let netAMount : Double = serviceFee + totalAmount
//                print("netAMount :::\(netAMount)")
//                //let serviceFeeStr = String(format: "%0.2f",Double(String(serviceFee))!)
//                str = String(totalAmount+serviceFee)
//
//               
//                var item1 = PayPalItem(name: "BASE", withQuantity: 1, withPrice: NSDecimalNumber(string: String(format :"%0.2f",netAMount)), withCurrency: "USD", withSku: "") //SivaGanesh-0001
//                    
//                    
//                
//                    let items = [item1]
//                    let subtotal = PayPalItem.totalPriceForItems(items)
//                    
//                    // Optional: include payment details
//                    let shipping = NSDecimalNumber(string: "0.00")
//                    let tax = NSDecimalNumber(string: "0.00")
//                    let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
//                    
//                    let total = subtotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
//                    
//                    let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: negotiateOffers_ItemName, intent: .Sale)
//                    
//                    payment.items = items
//                    payment.paymentDetails = paymentDetails
//                    
//                    if (payment.processable) {
//                        
//                        let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
//                        presentViewController(paymentViewController!, animated: true, completion: nil)
//                    }
//                    else {
//                        
//                        print("Payment not processalbe: \(payment)")
//                    }
//                    
//                
//
//            }
//            else
//            {
//                if itemEntity.itemTypeStr as String == "2" &&  itemEntity.deliveryTypeStr as String == "2" // ELECTRONIC SERVIESE NO NEED TO SHOW SELECT QUANTITY PAGE
//                {
//                    appdelegate.showLoadingIndicator()
//                    if Defaults[.userId] == itemEntity.buyer_id as String
//                    {
//                        print("BUYER")
//                        
//                        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
//                        
//                        
//                        
//                    }
//                    else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
//                    {
//                        print("FROM HOME")
//                        
//                        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
//                    }
//                    else
//                    {
//                        print("SELLER")
//                        
//                        print("Buyer ID::::\(itemEntity.buyer_id)")
//                        ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
//                        
//                        
//                        
//                    }
//                    
//                }
//                else if itemEntity.itemTypeStr as String == "2" &&  itemEntity.deliveryTypeStr as String == "1" // PHYSICAL SERVICE NO NEED TO SHOW SELECT QUANTITY PAGE
//                {
//                    appdelegate.showLoadingIndicator()
//                    
//                    if Defaults[.userId] == itemEntity.buyer_id as String // BUYER
//                    {
//                        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
//                    }
//                    else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
//                    {
//                        print("FROM HOME")
//                        
//                        
//                        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
//                    }
//                        
//                        
//                    else
//                    {
//                        
//                        
//                        ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
//                        
//                        
//                    }
//                    
//                    
//                    
//                }
//                    
//                else
//                {
//                    appdelegate.showLoadingIndicator()
//                    
//                    if selectedNegotiate_Quantity == ""
//                        
//                    {
//                        selectedNegotiate_Quantity = negotiateId_quantity//itemEntity.itemQuanityStr as String
//                    }
//                    if isApprvedAmount
//                    {
//                        selectedNegotiate_Quantity = negotiateId_quantity
//                    }
//                    
//                    
//                    appdelegate.showLoadingIndicator()
//                    print(Defaults[.userId],itemEntity.itemIdStr,selectedNegotiate_Quantity)
//                    
//                    if Defaults[.userId] == itemEntity.buyer_id as String // BUYER
//                    {
//                        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity, negotiate_id : negotiateId_Approve,tips: "0",delegate: self)
//                        
//                    }
//                    else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
//                    {
//                        print("FROM HOME")
//                        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity, negotiate_id : negotiateId_Approve,tips: "0",delegate: self)
//                        
//                    }
//                    else
//                    {
//                        
//                        ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity,negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
//                    }
//                    
//                    
//                    
//                }
//            }
//            
//        
//            
//            
//        }
//        else{
//            
//        }


        
    }
    
    func  handleBuyItNowRightButtonAction()
    {
        isOtherUserApproved = false
        handleOkButtonAction()
        
    }
    
    
    //MARK: - PAYPAL DELEGATES
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        
          ApiTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(ChattingRoomViewController.callBackgroundService), userInfo: nil, repeats: true)
        
            paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController, didCompletePayment completedPayment: PayPalPayment) {
        
        print("PayPal Payment Success !")
        paymentViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            print(completedPayment.confirmation["response"]!["id"])
            
            
            if self.isFromNegotiateForOffers
            {
                self.callAPI_NegotiationOffers(completedPayment.confirmation["response"]!["id"] as! String)
            }
            else
            {
                self.CallingpaypalPayItemApi(completedPayment.confirmation["response"]!["id"] as! String)
            }
            
            
        })
    }
    
    func callAPI_NegotiationOffers(payId : String)
    {
        
        appdelegate.showLoadingIndicator()
        ServerAPI().API_ApproveOffersNegotiation(Defaults[.userId], bid_amount: negotiateAmount_Approve, item_id: negotiateItem_itemID, bid_id: negotiate_BidId, request_user_id: negotiateItem_BuyerID, pay_id: payId,negotiate_id : negotiateId_Approve,card_id:"",delegate: self)
        
    }
    
    
    
    func callPayPal(itemName : String,totalCost : String,ItemQuantity : Int,ItemCost : String)
    {
        appdelegate.hideLoadingIndicator()
        let item1 = PayPalItem(name: "BRIDGE Item", withQuantity: 1, withPrice: NSDecimalNumber(string: totalCost), withCurrency: "USD", withSku: "SivaGanesh-0001")
        
        
        
        let items = [item1]
        let subtotal = PayPalItem.totalPriceForItems(items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: itemName, intent: .Sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            presentViewController(paymentViewController!, animated: true, completion: nil)
        }
        else {
            
            print("Payment not processalbe: \(payment)")
        }
        
    }
    
    func CallingpaypalPayItemApi(payId : String)
    {
        
        let quantityStr  = String(selectedNegotiate_Quantity)
        
        
        
        let amnt : Int = Int(selectedNegotiate_Quantity)!*Int(Double(negotiateAmount_Approve)!)
        let str = GRAPHICS.getTotalAMountWithServiceFee(String(Double(amnt)))
        
       // let str = GRAPHICS.getTotalAMountWithServiceFee(String(negotiateAmount_Approve))
        
        totalInt = Int(Double(String(amnt))!)
        
        let  totalAmount = Double(totalInt)
        
        
        
        
        var serviceFee : Double = 0.0
        
        if totalAmount >= 1 &&  totalAmount <= 9.99 // $1-9
        {
            serviceFee = Double(0.60)
        }
        else if totalAmount >= 10 &&  totalAmount <= 132.99 // $10-19
        {
            let feePercent = Double(7.5)
            serviceFee = (totalAmount*feePercent)/100
        }
        else if totalAmount >= 133 &&  totalAmount <= 199.99
        {
            let feePercent = Double(10)
            serviceFee = Double(10)
        }
            
        else if totalAmount >= 200
        {
            let feePercent = Double(5.0)
            serviceFee = (totalAmount*feePercent)/100
        }
        
        
        let serviceFeeStr = String(format: "%0.2f",Double(String(serviceFee))!)
        let totalStr = String(format: "%0.2f",Double(String(str))!)
        
        
        if itemEntity.itemCostStr as String == ""
        {
            itemEntity.itemCostStr = "0"
        }
        
        
        appdelegate.showLoadingIndicator()
        ServerAPI().API_PayItem_PayPal(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity, item_cost: negotiateAmount_Approve, total_cost: String(totalStr), pay_id: payId, process_fee: String(serviceFeeStr), is_nagotiation: "1", negotiate_id: negotiateId_Approve,tips: "0",card_id:"", delegate: self)
        
    }
    
    func API_CALLBACK_PayForItemPayPal(resultDict: NSDictionary) {
        
        
        print("PAY ITEM PAYPAL RESULT::::\(resultDict)")
        
        
        if resultDict.objectForKey("response_code") as! String == STATUS_CODE_1
        {
            Defaults[.paymentID] = resultDict.objectForKey("result")?.objectForKey("paymnet_id") as! String
            if itemEntity.itemTypeStr == "1" // GOODS
            {
                if itemEntity.deliveryTypeStr == "2" // ELECTRONICS GOODS
                {
                 showValidationMessage(ELECTRONIC_GOODS_ALERT, isButtonNeeded: false)
                    
                }
                else
                {
                    if itemEntity.userIdStr == Defaults[.userId]
                    {
                        showValidationMessage(CHAT_PRICE_APPROVED_ALERT, isButtonNeeded: false)
                    }
                    else
                    {
                       // appdelegate.hideLoadingIndicator()
                        let result = resultDict.objectForKey("result") as! NSDictionary
                        print("UNIQUE CODE::::\(result.valueForKey("unique_code"))")
                        
                        let verifyCodeVc = BLVerifyCodeViewController()
                        itemEntity.paymentIdStr = Defaults[.paymentID] 
                        verifyCodeVc.itemEntity = itemEntity
                        verifyCodeVc.paymentIdFromPreviousScreen = Defaults[.paymentID] 
                        verifyCodeVc.uniqueCodeString = result.valueForKey("unique_code") as! String
                        self.navigationController?.pushViewController(verifyCodeVc, animated: true)

                    }
                    
                }
                
                appdelegate.hideLoadingIndicator()
                
                
            }
            else // SERVICES
            {
                if itemEntity.deliveryTypeStr == "2" // ELECTRONICS SERVICES
                {
                    isFromPayPlaSuccess = true
                   // appdelegate.hideLoadingIndicator()
                    
                    
                    if itemEntity.userIdStr == Defaults[.userId]
                    {
                        showValidationMessage(CHAT_PRICE_APPROVED_ALERT, isButtonNeeded: false)
                    }
                    else
                    {
                        showValidationMessage(Buy_physical_service_success_Alert, isButtonNeeded: false)
                    }
                    
                    
                    
                    
                    
                }
                else
                {
                    isFromPayPlaSuccess = true
                    
                    if itemEntity.userIdStr == Defaults[.userId]
                    {
                       showValidationMessage(SellerSide_success_Alert, isButtonNeeded: false)
                    }
                    else
                    {
                        
                         showValidationMessage(CHAT_PRICE_APPROVED_ALERT, isButtonNeeded: false)
                    }


                    
                }

            }
            
            appdelegate.hideLoadingIndicator()
            
        }
        else
        {
            appdelegate.hideLoadingIndicator()
            isFromPayPlaSuccess = false
        }
        
    }
    
    func API_CALLBACK_NegotiationOffersApprove(resultDict: NSDictionary)
    {
        print("NEGOTAITAION OFFERS APPROVE:::\(resultDict)")
         appdelegate.hideLoadingIndicator()
        if resultDict.objectForKey("response_code") as! String == STATUS_CODE_1
        {
            isOtherUserApproved = true
            if negotiateItem_BuyerID == Defaults[.userId]
            {
                showValidationMessage(CHAT_PRICE_APPROVED_ALERT,isButtonNeeded : false)
            }
            else
            {
                showValidationMessage(CHAT_PRICE_APPROVED_ALERT,isButtonNeeded : false)
                
            }

        }
        else
        {
            isOtherUserApproved = false
        }
    }
    
    
    
    
    func cancelPaymentoptionsView()
    {
        if payoptionsForBuyView != nil
        {
            payoptionsForBuyView.removeFromSuperview()
        }
    }
    
    
    func createViewForPayOptionsToBuy()
    { if payoptionsForBuyView != nil
    {
        payoptionsForBuyView.removeFromSuperview()
        }
        
        payoptionsForBuyView = UIView(frame : CGRectMake(0,0,GRAPHICS.Screen_Width(),GRAPHICS.Screen_Height()))
        payoptionsForBuyView.backgroundColor = UIColor.whiteColor()
        view.addSubview(payoptionsForBuyView)
        
        
        
        
        let headerImage = GRAPHICS.SINGIN_HEADER()
        var XPos:CGFloat = 0.0
        var YPos:CGFloat = 0.0
        let viewHeight = GRAPHICS.getImageWidthHeight(headerImage!)
        var Width:CGFloat = viewHeight.width
        var Height:CGFloat = viewHeight.height
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let imgBaseHeader = UIImageView(frame: CGRectMake(XPos, YPos
            , Width, Height))
        imgBaseHeader.userInteractionEnabled = true
        imgBaseHeader.image = headerImage
        payoptionsForBuyView.addSubview(imgBaseHeader)
        
        
        
        let cgSize = GRAPHICS.getImageWidthHeight(GRAPHICS.HOME_SCREEN_MENU_CLOSE()!)
        Width = (cgSize.width)+5
        Height = (cgSize.height)+5
        YPos = 40.0
        XPos = 10.0
        
        let cancelViewBtn = UIButton()
        cancelViewBtn.frame = CGRectMake(XPos, YPos, Width, Height)
        cancelViewBtn.setBackgroundImage(GRAPHICS.HOME_SCREEN_MENU_CLOSE(), forState: UIControlState.Normal)
        cancelViewBtn.addTarget(self, action: #selector(ChattingRoomViewController.cancelPaymentoptionsView), forControlEvents: .TouchUpInside)
        imgBaseHeader.addSubview(cancelViewBtn)
        
        
        
        Height = 30.0
        YPos =  40.0
        Width = GRAPHICS.Screen_Width()-60
        XPos = 30.0
        var fontSize:CGFloat!
        if(GRAPHICS.Screen_Type() == IPHONE_4 || GRAPHICS.Screen_Type() == IPHONE_5)
        {
            fontSize = 18
        }
        else
        {
            fontSize = 20
        }
        
        
        let  lblTitle = UILabel(frame:CGRectMake(XPos, YPos, Width, Height))
        lblTitle.textAlignment = NSTextAlignment.Center
        lblTitle.adjustsFontSizeToFitWidth =  true
        lblTitle.text = "PAYMENT"
        lblTitle.textColor = UIColorFromRGB(HeaderTitleColor, alpha: 1)
        lblTitle.font = GRAPHICS.FONT_LIGHT(fontSize)
        lblTitle.backgroundColor = UIColor.clearColor()
        imgBaseHeader.addSubview(lblTitle)
        
        
        
        
        
        let  lbl_selectPayoptions = UILabel(frame:CGRectMake(0, 110, GRAPHICS.Screen_Width(), 50))
        lbl_selectPayoptions.textAlignment = NSTextAlignment.Center
        lbl_selectPayoptions.adjustsFontSizeToFitWidth =  true
        lbl_selectPayoptions.text = "Do you want to pay with?"
        lbl_selectPayoptions.textColor = UIColorFromRGB(HeaderTitleColor, alpha: 1)
        lbl_selectPayoptions.font = GRAPHICS.FONT_LIGHT(fontSize)
        lbl_selectPayoptions.backgroundColor = UIColor.clearColor()
        payoptionsForBuyView.addSubview(lbl_selectPayoptions)
        
        
        
        
        let paypmentcard = GRAPHICS.ADDPAYMENT_PAYMENTCARD()
        
        let btn_PaymentCard = UIButton(frame: CGRectMake(50,CGRectGetMaxY(lbl_selectPayoptions.frame)+30,GRAPHICS.Screen_Width()-100,60))
        btn_PaymentCard.backgroundColor = UIColor.clearColor()
        btn_PaymentCard.backgroundColor = UIColor.clearColor()
        btn_PaymentCard.addTarget(self, action: #selector(ChattingRoomViewController.paymentCardBtnAction(_:)), forControlEvents:UIControlEvents.TouchUpInside)
        btn_PaymentCard.setImage(paypmentcard, forState: .Normal)
        payoptionsForBuyView.addSubview(btn_PaymentCard)
        
        let paypalImg = GRAPHICS.ADDPAYMENT_PAYPAL()
        
        let btn_Paypal = UIButton(frame: CGRectMake(50,CGRectGetMaxY(btn_PaymentCard.frame)+30,GRAPHICS.Screen_Width()-100,60))
        btn_Paypal.backgroundColor = UIColor.clearColor()
        btn_Paypal.setImage(paypalImg, forState: .Normal)
        btn_Paypal.addTarget(self, action: #selector(ChattingRoomViewController.paypalCardBtnAction(_:)), forControlEvents:UIControlEvents.TouchUpInside)
        payoptionsForBuyView.addSubview(btn_Paypal)
        
        
    }
    
    func paymentCardBtnAction(sender: AnyObject)
    {
        print("CARD")
        let quantityStr  = String(selectedNegotiate_Quantity)
        let addCardVC = BLPayOptionsToBuyVC()
        addCardVC.buying_ItemID = itemEntity.itemIdStr as String
        addCardVC.buying_OwnerID = ""
        addCardVC.isBuyerApprovingBidFromNegotiationByStripe = false
        if isFromNegotiateForOffers
        {
            addCardVC.negotiateBIDID_Approved = negotiate_BidId
            addCardVC.isBuyerApprovingBidFromNegotiationByStripe = true
            addCardVC.offerNegotiate_ItemId = itemEntity.itemIdStr as String
            addCardVC.offerNegotiate_RequestUserId = negotiateItem_BuyerID
        }
        addCardVC.itemEntityFromDetails = itemEntity
        addCardVC.buying_Qunatity = quantityStr
        addCardVC.buying_TipsStr = "0"
        addCardVC.totalAmountInt = totalInt
        addCardVC.isFromChatRoomNegotiation  = true
        addCardVC.negotiateID_Approved = negotiateId_Approve
        addCardVC.negotiateAmount_Approved = negotiateAmount_Approve
        self.navigationController?.pushViewController(addCardVC, animated: true)
        
    }
    func paypalCardBtnAction(sender: AnyObject)
    {
        print("PAYPAL")
        if payoptionsForBuyView != nil
        {
            payoptionsForBuyView.removeFromSuperview()
        }
        
        let quantityStr  = String(selectedNegotiate_Quantity)
        appdelegate.showLoadingIndicator()
        print(Defaults[.userId],itemEntity.itemIdStr,quantityStr)
//        ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: quantityStr,negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
        
        
        
                if isApprvedAmount
        
                {
                    if ApiTimer != nil{
                        ApiTimer.invalidate()
                        ApiTimer = nil
                    }
        
                    if isFromNegotiateForOffers // APPROVE FOR NEGOTAITE OFFERS
                    {
        
                        print("OFFERS NEGOTIATION APPROVE")
                        if negotiateItem_BuyerID == Defaults[.userId] // BUYER
                        {
                            appdelegate.hideLoadingIndicator()
                            
                            let amnt : Int = Int(selectedNegotiate_Quantity)!*Int(Double(negotiateAmount_Approve)!)
                                            var str = GRAPHICS.getTotalAMountWithServiceFee(String(Double(amnt)))
                                            let  totalAmount = Double(amnt)
                            
                                            var serviceFee : Double = 0.0
                                            if totalAmount >= 1 &&  totalAmount <= 9.99 // $1-9
                                            {
                                                serviceFee = Double(0.60)
                                            }
                                            else if totalAmount >= 10 &&  totalAmount <= 132.99 // $10-19
                                            {
                                                let feePercent = Double(7.5)
                                                serviceFee = (totalAmount*feePercent)/100
                                            }
                                            else if totalAmount >= 133 &&  totalAmount <= 199.99
                                            {
                                                let feePercent = Double(10)
                                                serviceFee = Double(10)
                                            }
                            
                                            else if totalAmount >= 200
                                            {
                                                let feePercent = Double(5.0)
                                                serviceFee = (totalAmount*feePercent)/100
                                            }
                                            let netAMount : Double = serviceFee + totalAmount
                                            print("netAMount :::\(netAMount)")
                                            //let serviceFeeStr = String(format: "%0.2f",Double(String(serviceFee))!)
                                            str = String(totalAmount+serviceFee)
                            
                            
                                            let item1 = PayPalItem(name: "BASE", withQuantity: 1, withPrice: NSDecimalNumber(string: String(format :"%0.2f",netAMount)), withCurrency: "USD", withSku: "") //SivaGanesh-0001
                            
                            
                            
                                                let items = [item1]
                                                let subtotal = PayPalItem.totalPriceForItems(items)
                            
                                                // Optional: include payment details
                                                let shipping = NSDecimalNumber(string: "0.00")
                                                let tax = NSDecimalNumber(string: "0.00")
                                                let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
                                                
                                                let total = subtotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
                                                
                                                let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: negotiateOffers_ItemName, intent: .Sale)
                                                
                                                payment.items = items
                                                payment.paymentDetails = paymentDetails
                                                
                                                if (payment.processable) {
                                                    
                                                    let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
                                                    presentViewController(paymentViewController!, animated: true, completion: nil)
                                                }
                                                else {
                                                    
                                                    print("Payment not processalbe: \(payment)")
                                                }
                                                
                                            

        
                        }
                        else
                        {
                            appdelegate.showLoadingIndicator()
                            ServerAPI().API_ApproveOffersNegotiation(Defaults[.userId], bid_amount: negotiateAmount_Approve, item_id: negotiateItem_itemID, bid_id: negotiate_BidId, request_user_id: negotiateItem_BuyerID, pay_id: "",negotiate_id : negotiateId_Approve,card_id:"",delegate: self)
                        }
        
                    }
                    else
                    {
        
        
                            if itemEntity.itemTypeStr as String == "2" &&  itemEntity.deliveryTypeStr as String == "2" // ELECTRONIC SERVIESE NO NEED TO SHOW SELECT QUANTITY PAGE
                            {
        
        
                                if Defaults[.userId] == itemEntity.buyer_id as String
                                {
                                    print("BUYER")
                                    appdelegate.showLoadingIndicator()
                                    ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
        
        
                                }
                                else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
                                {
                                    print("FROM HOME")
                                    appdelegate.showLoadingIndicator()
                                    ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                                }
                                else
                                {
                                    print("SELLER")
                                    appdelegate.showLoadingIndicator()
                                    print("Buyer ID::::\(itemEntity.buyer_id)")
                                    ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve, tips: "0",delegate: self)
        
                                }
        
                            }
                            else if itemEntity.itemTypeStr as String == "2" &&  itemEntity.deliveryTypeStr as String == "1" // PHYSICAL SERVICE NO NEED TO SHOW SELECT QUANTITY PAGE
                            {
        
        
        
                                if Defaults[.userId] == itemEntity.buyer_id as String // BUYER
                                {
                                    appdelegate.showLoadingIndicator()
                                    ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                                }
                                else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
                                {
                                    print("FROM HOME")
        
                                    appdelegate.showLoadingIndicator()
                                    ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                                }
        
        
                                else
                                {
        
                                    appdelegate.showLoadingIndicator()
                                    ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: "1",negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
        
        
                                }
        
        
        
                            }
        
                            else
                            {
                                appdelegate.hideLoadingIndicator()
        
                                if selectedNegotiate_Quantity == ""
        
                                {
                                    selectedNegotiate_Quantity = negotiateId_quantity//itemEntity.itemQuanityStr as String
                                }
                                if isApprvedAmount
                                {
                                    selectedNegotiate_Quantity = negotiateId_quantity
                                }
        
        
                                appdelegate.showLoadingIndicator()
                                print(Defaults[.userId],itemEntity.itemIdStr,selectedNegotiate_Quantity)
        
        
                                itemEntity.buyer_id =  negotiateItem_BuyerID
        
                                if Defaults[.userId] == itemEntity.buyer_id as String // BUYER
                                {
        
        
                                    ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity, negotiate_id : negotiateId_Approve,tips: "0",delegate: self)
        
                                }
                                else if  itemEntity.buyer_id as String == "" // if it is come from home...there buyer id will be empty
                                {
                                    print("FROM HOME")
                                   
                                    
                                    ServerAPI().API_BuyItem(Defaults[.userId], item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity, negotiate_id : negotiateId_Approve,tips: "0",delegate: self)
                                    
                                }
                                else
                                {
                                    ServerAPI().API_BuyItem(itemEntity.buyer_id as String, item_id: itemEntity.itemIdStr as String, item_quantity: selectedNegotiate_Quantity,negotiate_id : negotiateId_Approve,tips: "0", delegate: self)
                                }
                                
                                
                                
                              }
                }
                   
                }
                else{
                    
                }
        
        
    }
    

    
    
}

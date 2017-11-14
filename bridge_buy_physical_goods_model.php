<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
date_default_timezone_set("UTC");
class bridge_buy_physical_goods_model extends CI_Model {
	public function __construct()	
	{
		parent::__construct();
		$this->load->model('bridge_negotiate_item_model');
		$this->load->model('bridge_stripe_model');
		$this->load->model('bridge_stripe_payment_model');
		$this->load->model('bridge_push_notification_model');
		$this->load->model('bridge_get_item_model');
		$this->load->model('bridge_service_model');
		
	}
    function buyservice($item_amount,$quantity,$buyer_id,$pushval)
	{
		
		
		
		
		
		
		$base= base_url();
		$to_user_id=$this->item_owner_id();
			if($_POST['user_id']==$to_user_id)
			{
				$user_id=$to_user_id;
				$to_user_id=$buyer_id;
			}
			else{
				
				$user_id=$_POST['user_id'];
				$to_user_id=$to_user_id;
			}
		$customerId= $this->bridge_stripe_model->customeridstripe($user_id);
		//$customerId="cus_87ZkLVy6UHhm1f";
		$processing_fee= $this->bridge_service_model->servicefee($item_amount , $quantity);
		$total_amt=  ($item_amount * $quantity)+ $processing_fee;
		
		
		
		$amount=$total_amt;
		//echo $base."stripe/payment.php?customerId=$customerId&amount=$amount";
		$ress = file_get_contents($base."stripe/payment.php?customerId=$customerId&amount=$amount");
		//$ress="paid,ch_17vQqeB1GSpeyclqf4ny53Vp,txn_17vQqeB1GSpeyclqRYgcXWKk,card_17ubrDB1GSpeyclqkKpSyq9X";
		$res=trim($ress);
		$striperesult = explode(',', $res);
		
		

		if($striperesult[0]=="paid"){
			
			
			$to_user_id=$this->item_owner_id();
			if($_POST['user_id']==$to_user_id)
			{
				$user_id=$to_user_id;
				$to_user_id=$buyer_id;
			}
			else{
				
				$user_id=$_POST['user_id'];
				$to_user_id=$to_user_id;
			}
			$item_id=$_POST['item_id'];
			
			$unique_code=$this->bridge_stripe_payment_model->updatepaymnetreq($striperesult,$amount,$processing_fee,$item_amount,$quantity,$item_id,$user_id,$to_user_id);
			$this->updateitemstatus($quantity);

			$paymnet_id=$this->getpayid($unique_code);
			
			$apifrom="Buy";
			$typeid=$_POST['item_id'];
			
			$item_name=$this->bridge_get_item_model->get_itemname($typeid);
			//$firstnmae=$this->bridge_get_item_model->get_itemname($typeid);
			$message="Your Product '".$item_name."' has purchased"; 
			
			//$message="Your item purchased and amount will be received shortly";
			
			/*if($_POST['user_id']==$to_user_id)
			{
				$user_id=$to_user_id;
				$to_user_id=$buyer_id;
			}
			else{
				
				$user_id=$_POST['user_id'];
				$to_user_id=$to_user_id;
			} */
			
			$this->transactionbuyermail($user_id,$striperesult[2],$item_amount,$processing_fee,$amount,$to_user_id,$typeid);
			
			
			if($pushval=="1")
			{
			$this->bridge_push_notification_model->push($user_id,$to_user_id,$apifrom,$typeid,$message,$paymnet_id);
			}
			  $result=array('message' => 'You have payed successfully.', 
			               'unique_code'=>"$unique_code",
						    'paymnet_id'=>"$paymnet_id",
							'payment_id'=>"$paymnet_id",
						   );
			$this->bridge_negotiate_item_model->deletepayed($user_id,$to_user_id);			   
			//$result="You have payed successfully.";
			
			$to_user_id=$this->item_owner_id();
		
			$checkbankstatus=$this->bridge_stripe_model->checkbankstatus($to_user_id);
			
			if($checkbankstatus=="")
			{
				
				$apifrom="Bank";
				$typeid=$_POST['item_id'];
				$message="Your Item has been purchased.Please add your bank details to receive payment.";
				$this->bridge_push_notification_model->push($user_id,$to_user_id,$apifrom,$typeid,$message,$paymnet_id);
			}
			
			
		}
		else{
			$result="false";
		} 
		
		
		return $result;
	}
	function transactionbuyermail($user_id,$transaction_id,$item_amount,$processing_fee,$amount,$to_user_id,$item_id)
	{
		$dateFormat="Y-m-d H:i:s"; 
		$Year = date("Y", strtotime($dateFormat));
		$Day = date("d", strtotime($dateFormat));
		$Month = date("M", strtotime($dateFormat));
		
		$item_amounts=$amount-$processing_fee;
		
		$this->db->select('*');
		$this->db->where('user_id', $user_id);
		$this->db->from('db_bridge_user');
		$query = $this->db->get();
		$result = $query->result_array();
		$email = $result[0]['email_id'];
		$user_id = $result[0]['user_id'];
		$firstName = $result[0]['first_name'];
		$last_name = $result[0]['last_name'];
		
		$this->db->select('*');
		$this->db->where('user_id', $to_user_id);
		$this->db->from('db_bridge_user');
		$query = $this->db->get();
		$results = $query->result_array();
		$oemail = $results[0]['email_id'];
		$ouser_id = $results[0]['user_id'];
		$ofirstName = $results[0]['first_name'];
		$olast_name = $results[0]['last_name'];
		
		$item_amounts= number_format((float)$item_amounts, 2, '.', ''); 
		$processing_fee= number_format((float)$processing_fee, 2, '.', ''); 
		$amount= number_format((float)$amount, 2, '.', ''); 
		$userId = $result[0]['userId'];
		$base= base_url()."download/download.php?filename=Electro.zip";
		
		$subject = "You sent a payment"; //.$item_name;
		$messagetext = "<p>Transaction ID: ".$transaction_id.",</p>";
		$messagetext .= "<p>Dear ".$firstName." ".$last_name.",</p>";
		$messagetext .= "<p>You sent a mobile payment for $".$item_amounts." USD to ".$ofirstName." . A message has been sent 
		to the recipient asking to accept or deny the payment.</p> </br>";
		$messagetext .= "<p>Amount you have sent: $".$item_amounts." USD</p>";
		$messagetext .= "<p>Your fee: $".$processing_fee." USD</p>";
		$messagetext .= "<p>Your total charge: $".$amount." USD</p>";
		//$messagetext .= "<p>".$ofirstName." ".$olast_name." will receive: $".$item_amounts." USD</p>";
		//$messagetext .= "<pSent on: ".$Month." ".$Day.",".$Year."</p>";
		$messagetext .= "<p>Sincerely,</p>";
		$messagetext .= "<p>Base Support Team</p>";
			
		$this->sendemail($email,$messagetext,$subject);
		return $email;
		
	}	
	function sendemail($email_id,$messagetext,$subject){
	
			
			
		    require_once('PHPMailer-master/class.phpmailer.php');
			$email = new PHPMailer();
			$email->From      = 'support@gobaseapp.com'; 
			$email->FromName  = 'Base';
			$email->Subject   = $subject;
			$email->Body      = $messagetext;
			$email->IsHTML(true); 
			$email->AddAddress($email_id); 
			$email->addReplyTo('support@gobaseapp.com');
			$email->Send();
	
	}
    function buyphysicalgoods($item_amount,$quantity,$pushval)
	{
		$base= base_url();
		$to_user_id=$this->item_owner_id();
		/*	if($_POST['user_id']==$to_user_id)
			{
				$user_id=$to_user_id;
				$to_user_id=$buyer_id;
			}
			else{
				
				$user_id=$_POST['user_id'];
				$to_user_id=$to_user_id;
			}
		 */
		$user_id=$_POST['user_id'];
		$customerId= $this->bridge_stripe_model->customeridstripe($user_id);
		//$customerId="cus_87ZkLVy6UHhm1f";
		$processing_fee= $this->bridge_service_model->servicefee($item_amount , $quantity);
		$total_amt=  ($item_amount * $quantity)+ $processing_fee;
		
		
		
		$amount=$total_amt;
		//echo $base."stripe/payment.php?customerId=cus_8RQbHLEMWiXiil&amount=$amount";
		$ress = file_get_contents($base."stripe/payment.php?customerId=$customerId&amount=$amount");
		//$ress="paid,ch_17vQqeB1GSpeyclqf4ny53Vp,txn_17vQqeB1GSpeyclqRYgcXWKk,card_17ubrDB1GSpeyclqkKpSyq9X";
		$res=trim($ress);
		$striperesult = explode(',', $res);
		
		    
			
			
			

		if($striperesult[0]=="paid"){
			$unique_code=$this->bridge_stripe_payment_model->updatepaymnet($striperesult,$amount,$processing_fee,$item_amount,$quantity);
			//$unique_code=$this->bridge_stripe_payment_model->updatepaymnetreq($striperesult,$amount,$processing_fee,$item_amount,$quantity,$item_id,$user_id,$to_user_id);
			
			$this->updateitemstatus($quantity);

			$paymnet_id=$this->getpayid($unique_code);
			
			$apifrom="Buy";
			$typeid=$_POST['item_id'];
			//$message="Your item has been purchased";
			$item_name=$this->bridge_get_item_model->get_itemname($typeid);
			$message="Your Product '".$item_name."' has purchased."; 
			if($pushval=="1")
			{
			$this->bridge_push_notification_model->push($user_id,$to_user_id,$apifrom,$typeid,$message,$paymnet_id);
			}
			$this->transactionbuyermail($user_id,$striperesult[2],$item_amount,$processing_fee,$amount,$to_user_id,$typeid);
			
			
			$to_user_id=$this->item_owner_id();
		
			$checkbankstatus=$this->bridge_stripe_model->checkbankstatus($to_user_id);
			
			if($checkbankstatus=="")
			{
				
				$apifrom="Bank";
				$typeid=$_POST['item_id'];
				$message="Your Item has been purchased.Please add your bank details to receive payment.";
				$this->bridge_push_notification_model->push($user_id,$to_user_id,$apifrom,$typeid,$message,$paymnet_id);
			}	


			$result=array('message' => 'You have payed successfully.', 
			               'unique_code'=>"$unique_code",
						    'paymnet_id'=>"$paymnet_id",
							'payment_id'=>"$paymnet_id",
						   );
			$this->bridge_negotiate_item_model->deletepayed($user_id,$to_user_id);			   
			//$result="You have payed successfully.";
			
			
			
			
			
		}
		else{
			$result="false";
		} 
		
		
		return $result;
	}	
	function getpayid($unique_code){
		
		$this->db->select('*');
		$this->db->where('unique_code',$unique_code);
		$this->db->from('db_bridge_payment');
		$query = $this->db->get();
		$result = $query->result_array();
		$payment_id=$result[0]['payment_id'];
		 return  $payment_id;
		
	}
	function item_owner_id(){
		
		$this->db->select('*');
		$this->db->where('item_id',$_POST['item_id']);
		$this->db->from('db_bridge_items');
		$query = $this->db->get();
		$result = $query->result_array();
		$user_id=$result[0]['user_id'];
		 return  $user_id;
	}
	function updateitemstatus($quantity){
		
		$this->db->select('*');
		$this->db->where('item_id', $_POST['item_id']);
		$this->db->from('db_bridge_items');
		$query = $this->db->get();
		$result = $query->result_array();
		$item_quantity=$result[0]['item_quantity'];
		$current_quantity=$item_quantity - $quantity;
		if($current_quantity<="0")
		{
			$data = array(
			'status'	 =>	"1",
			'delete_flag'	 =>	"2",
			'item_quantity'	 =>	$current_quantity,
			);
			$this->db->where('item_id',$_POST['item_id']);	
			$this->db->update('db_bridge_items',$data);
			
			$this->bridge_negotiate_item_model->deleteitemnegotiation();
			
		}
		if($current_quantity>0)
		{
			$data = array(
			'status'	 =>	"0",
			'item_quantity'	 =>	$current_quantity,
			);
			$this->db->where('item_id',$_POST['item_id']);	
			$this->db->update('db_bridge_items',$data);
		}
	}
	
	
}
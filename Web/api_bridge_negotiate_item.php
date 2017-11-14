<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
error_reporting(0);
require APPPATH.'/libraries/validationandresult.php';
require APPPATH.'/libraries/REST_Controller.php';
class api_bridge_negotiate_item extends REST_Controller {

	 public function __construct()
    {
        
        parent::__construct();
        $this->load->library('form_validation');
		$this->form_validation->set_error_delimiters('', '');	
        $this->load->model('bridge_negotiate_item_model');
    } 
	 
	 
	 function index_post()
	{
			$validationandresult = new validationandresult();
			if(isset($_POST) != "")
			{

					
					// Empty key checking.
					
					$pre_key = array('user_id','item_id','negitation_amount','to_user_id','quantity');
					
					$result = $validationandresult->keyvalidation($pre_key);
					
					if($result['message'] != '')
					{
						$this->response($result, 202);

					}
					else
					{
							$this->form_validation->set_rules('user_id', 'user_id',  'trim|required|callback_usercheck');
							$this->form_validation->set_rules('item_id', 'item_id',  'trim|required|callback_itemcheck');
							$this->form_validation->set_rules('negitation_amount', 'negitation_amount',  'trim|required');	
							$this->form_validation->set_rules('to_user_id', 'to_user_id',  'trim|required');
							$this->form_validation->set_rules('quantity', 'quantity',  'trim|required');
							if ($this->form_validation->run() == FALSE) {
				
							$validation_errors = validation_errors();
							$result = $validationandresult->formvalidation($validation_errors);
							$this->response($result, 202);
							}
							else
							{ 
							 
							    $owner_id= $this->getowner(); 
								if($owner_id!=$_POST['user_id'])
								{
								
									//$stripe=$this->checkcard();
									 $stripe=TRUE; 
									if($stripe==TRUE)
									{

											$results=$this->bridge_negotiate_item_model->negotiaterequest();
											if($results=="success")
											{
											$result = $validationandresult->successmessagewithemptyresult();
											$this->response($result, 200); 
											}
											else{
											$result = $validationandresult->formvalidation("Can't request for negotiation more than one.");
											$this->response($result, 202);

											}
									}
								    else{
									   
									    $result = $validationandresult->card();
										 $this->response($result, 200);
								   }
							    }
								else{
									
									       $results=$this->bridge_negotiate_item_model->negotiaterequest();
											if($results=="success")
											{
											$result = $validationandresult->successmessagewithemptyresult();
											$this->response($result, 200); 
											}
											else{
											$result = $validationandresult->formvalidation("Can't request for negotiation more than one.");
											$this->response($result, 202);

											}
								}
							}
									
									
								
							
					}
					
			}
			else
			{
					$result = $validationandresult->invalidrequest();
					$this->response($result, 202);
			 
			}
	
			
	
	}
	function getowner(){
		$this->db->select('*');
		$this->db->where('item_id', $_POST['item_id']);
		$this->db->from('db_bridge_items');
		$query = $this->db->get();
		$result = $query->result_array();
		return $user_id=$result[0]['user_id'];
	}
	function checkpaymnet_type(){
		$this->db->select('*');
		$this->db->where('user_id', $user_id);
		$this->db->from('db_bridge_user');
		$query = $this->db->get();
		$result = $query->result_array();
		return $result[0]['payment_mode'];
	}
	function checkcard(){
		
		$payment_mode =$this->checkpaymnet_type();
		if($payment_mode=="3")
		{
			$this->db->select('*');
			$this->db->where('user_id', $_POST['user_id']);
			$this->db->from('db_bridge_stripe_details');
			$query = $this->db->get();
			if ($query->num_rows() > 0){
			     return TRUE;
			}
			else{
				return FALSE;
				
			}
		}
		if(($payment_mode=="1") || ($payment_mode=="2"))
		{
		$this->db->select('*');
		$this->db->where('user_id', $_POST['user_id']);
		$this->db->from('db_bridge_stripe_details');
		$query = $this->db->get();
		
		if ($query->num_rows() > 0){
			$results = $query->result_array();
			$card_number=$results[0]['card_number'];
				if($card_number=="")
				{
					return FALSE;
				}
				else{
				$result = $query->result_array();
				return TRUE;
				}
			}
			else{
					return FALSE;
				}		
			
		}
		if($payment_mode=="0"){
			
			return FALSE;
		}
		
	}
	function itemcheck($item_id){
		
		$this->db->select('*');
		$this->db->where('item_id', $item_id);
		$this->db->from('db_bridge_items');
		$query = $this->db->get();
		if ($query->num_rows() > 0){
			
			$result = $query->result_array();
			
			$delete_flag=$result[0]['delete_flag'];
			$status=$result[0]['status'];
			if($status=="0"){
				
				return TRUE;	
				
			}
			if($status=="1"){
				
				$this->form_validation->set_message('itemcheck', "This item is currently unavailable.");
				return FALSE;
				
			}
			if($status=="2"){
				
				$this->form_validation->set_message('itemcheck', "This item is currently unavailable.");
				return FALSE;
				
			}
			
			else{
				if($delete_flag!="1"){
				$this->form_validation->set_message('itemcheck', "This item is currently unavailable.");
				return FALSE;	
				}
				if($delete_flag=="1"){
				return TRUE;	
				}
				
				
			}
			
		
					 
		}
		else{
		
		$this->form_validation->set_message('itemcheck', "Invalid item_id.");
		return FALSE;
			
		}
		
	} 
	function usercheck($user_id){
		$this->db->select('*');
		$this->db->where('user_id', $user_id);
		$this->db->from('db_bridge_user');
		$query = $this->db->get();
		if ($query->num_rows() > 0){
			
			$result = $query->result_array();
			$login_type=$result[0]['login_type'];
			$delete_flag=$result[0]['delete_flag'];
			
			if($delete_flag!="0"){
			$this->form_validation->set_message('usercheck', "Account is blocked.");
			return FALSE;	
			}
			if($delete_flag=="0"){
			return TRUE;	
			}
			
					 
		}
		else{
		
		$this->form_validation->set_message('usercheck', "Invalid user_id.");
		return FALSE;
			
		}
	}
	
	 
}
?>
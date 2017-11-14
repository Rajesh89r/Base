<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
date_default_timezone_set("UTC");
error_reporting(0);
class bridge_send_chat_model extends CI_Model {
	public function __construct()	
	{
		parent::__construct();
		$this->load->model('bridge_negotiate_item_model');
		$this->load->model('bridge_stripe_model');
		$this->load->model('bridge_userdetail_model');
		$this->load->model('bridge_push_notification_model');
		
	}
    
	function index(){ 
	
			
			if($_POST['payment_id']==""){
				
				$payment_id="0";
			}
			else{
				$payment_id=$_POST['payment_id'];
			}
			$this->chnagereadstatus();
			$dateFormat="Y-m-d H:i:s"; 
		    $timeNdate=gmdate($dateFormat, time());
			$data = array(
			'sender_id'	 		=>	$_POST['user_id'],
			'friend_id'			=>	$_POST['friend_id'],
			'item_id'			=>	$_POST['item_id'],
			'chat_message'  	=>  $_POST['chat_message'],
			'payment_id'		=>	$payment_id,
			'chat_date_time'	=>	$timeNdate,
			);
			$this->db->insert('db_bridge_chat',$data);
		
				$user_id=$_POST['user_id'];
				$to_user_id= $_POST['friend_id'];
				$apifrom="Chat";
				$typeid=$_POST['item_id'];
				$item_name= $this->getmessage();
				$message="You have received a message for '".$item_name."'";
				
				$this->bridge_push_notification_model->push($user_id,$to_user_id,$apifrom,$typeid,$message,$payment_id);
		
	}
	function getmessage(){
		
		$this->db->select('*');
		$this->db->where('item_id',$_POST['item_id']);
		$this->db->from('db_bridge_items');
		$query = $this->db->get();
		$result = $query->result_array();
		$item_name=$result[0]['item_name'];
		 return  $item_name;
	}	
	function chnagereadstatus(){
		
		
			$data = array(
			'chat_read_status'	 =>	"1",
			);
			$this->db->where('sender_id', $_POST['friend_id']);
			$this->db->where('friend_id', $_POST['user_id']);
			$this->db->where('item_id', $_POST['item_id']);
			$this->db->update('db_bridge_chat',$data); 
		
		
		
	}
	function getchatcount($item_id,$user_id){
		
		$sender_id=$_POST['user_id'];
		
		
		
		$query=$this->db->query("select * from db_bridge_chat where item_id = ".$item_id." AND  friend_id=  ".$sender_id."  AND chat_read_status='0' "); 
		if ($query->num_rows() > 0){
			
			$result=$query->num_rows();
		}
		else{
			$result=0;
		}
		
		return "$result";
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
	function deletechat(){
		
	$to_user_id=$this->item_owner_id();	
	//$query=$this->db->query("DELETE FROM `db_bridge_chat` where item_id = ".$_POST['item_id']." AND (( sender_id=  ".$to_user_id." AND  friend_id=  ".$_POST['user_id']." ) OR (sender_id=  ".$_POST['user_id']." AND  friend_id=  ".$to_user_id.") ) "); 
			
	}
	
	function getchat(){
		 
		$this->chnagereadstatus();
		$query=$this->db->query("select * from db_bridge_chat where item_id = ".$_POST['item_id']." AND (( sender_id=  ".$_POST['friend_id']." AND  friend_id=  ".$_POST['user_id']." ) OR (sender_id=  ".$_POST['user_id']." AND  friend_id=  ".$_POST['friend_id'].") ) ORDER BY `chat_id` ASC "); 
		
		if ($query->num_rows() > 0){
			
			$result =$query->result_array();
			foreach($result as $key=>$val)
			{
				
				$result[$key]['sender_first_name']= $this->bridge_userdetail_model->firstname($val['sender_id']);
				$result[$key]['sender_last_name']= $this->bridge_userdetail_model->lastname($val['sender_id']);
			}
		}
		else{
			
			$result =array();
		}
		return $result;
	}
}
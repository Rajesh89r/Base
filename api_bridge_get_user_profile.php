<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
error_reporting(0);
require APPPATH.'/libraries/validationandresult.php';
require APPPATH.'/libraries/REST_Controller.php';
class api_bridge_get_user_profile extends REST_Controller {

	 public function __construct()
    {
        
        parent::__construct();
        $this->load->library('form_validation');
		$this->form_validation->set_error_delimiters('', '');	
        $this->load->model('bridge_get_profile_model');
    } 
	 
	 
	 function index_post()
	{
			$validationandresult = new validationandresult();
			if(isset($_POST) != "")
			{


					// Empty key checking.
					
					$pre_key = array('user_id','profile_user_id');
					
					$result = $validationandresult->keyvalidation($pre_key);
					
					if($result['message'] != '')
					{
						$this->response($result, 202);

					}
					else
					{
							$this->form_validation->set_rules('user_id', 'user_id',  'trim|required|callback_usercheck');
							$this->form_validation->set_rules('profile_user_id', 'profile_user_id',  'trim|required|callback_usercheck');
												
							if ($this->form_validation->run() == FALSE) {
				
							$validation_errors = validation_errors();
							$result = $validationandresult->formvalidation($validation_errors);
							$this->response($result, 202);
							}
							else
							{ 
							 
							   $results=$this->bridge_get_profile_model->index();
							   $result = $validationandresult->successmessagewithresult($results);
							   $this->response($result, 200);
							  
							}
									
									
								
							
					}
					
			}
			else
			{
					$result = $validationandresult->invalidrequest();
					$this->response($result, 202);
			 
			}
	
			
	
	}
	 
	function usercheck($user_id)
	{
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
				
			}
			
					 
		}
		else{
		
		$this->form_validation->set_message('usercheck', "Invalid user_id.");
		return FALSE;
			
		}
	}
	
	 
}
?>
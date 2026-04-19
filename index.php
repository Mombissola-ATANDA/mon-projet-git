<?php
	include 'controller.php';
	if(isset($_GET['controller'])){
		$_GET['controller']();
	}else{
		member();
	}
?>
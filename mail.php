<?php
require("/var/www/html/phpmailer/class.phpmailer.php");

$ID = "replace_this_string_with_ID";
$Filename = "replace_this_string_with_Filename";
$HASH = "replace_this_string_with_Filehash";
$path = "/var/www/html/email.html";
$message = file_get_contents($path);
$message = str_replace('{random_data}',urlencode($ID),$message);
$message = str_replace('{attached_digital_asset}',$Filename ,$message);
$message = str_replace('{original_file_hash}',$HASH ,$message);

$mail = new PHPMailer();

$mail->IsSMTP();                                      // set mailer to use SMTP
$mail->SMTPAuth = true;     // turn on SMTP authentication
$mail->SMTPSecure = "ssl";
$mail->SMTPDebug = 4;
$mail->Host = "bcmail.inapp.com";  // specify main and backup server
$mail->Port = 465;
$mail->Username = "its@bcmail.inapp.com";  // SMTP username
$mail->Password = "Inapp123"; // SMTP password


$mail->From = "its@bcmail.inapp.com";
$mail->FromName = "ITS";
$mail->AddAddress("replace_to_email_from_script");

$mail->WordWrap = 50;                                 // set word wrap to 50 characters
$mail->IsHTML(true);                                  // set email format to HTML

$mail->Subject = "Succesfully Uploaded to Blockchain!!";
$mail->Body    = $message;

if(!$mail->Send())
{
   echo "Message could not be sent. <p>";
   echo "Mailer Error: " . $mail->ErrorInfo;
   exit;
}

echo "Message has been sent";
?>

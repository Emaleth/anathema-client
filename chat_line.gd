extends PanelContainer


func config(sender, timestamp, msg):
	$HBoxContainer/SenderLabel.text = str(sender)
	$HBoxContainer/TimeLabel.text = str(timestamp)
	$HBoxContainer/MessageLabel.text = str(msg)

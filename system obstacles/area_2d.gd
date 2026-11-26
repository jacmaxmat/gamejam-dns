extends Area2D

func hit(amount):
	if get_parent().has_method("hit"):
		get_parent().hit(amount)

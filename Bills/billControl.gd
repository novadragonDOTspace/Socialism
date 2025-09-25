extends Control

class_name BillControll

var Headline: String
var ContentBill: String

var PositionGoal: Vector2


func _ready() -> void:
	$HeadlineLabel.text = Headline
	$ContentBillLabel.text = ContentBill
	PositionGoal = position

	if position.y + 126 < 0:
		queue_free()


func _process(delta: float) -> void:
	$HeadlineLabel.text = Headline
	$ContentBillLabel.text = ContentBill
	position = position.move_toward(PositionGoal, 10)


func OffTheyGo() -> void:
	if position != PositionGoal: return
	PositionGoal = Vector2(position.x, position.y - 200)


func NextPls() -> void:
	if position != PositionGoal: return
	PositionGoal = Vector2(position.x - 255, position.y)

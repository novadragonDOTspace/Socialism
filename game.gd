extends Node
class_name Game

@export var AllProblems: Array[Problem]
@export var AllBills: Array[Bill]
@export var AllPricks: Array[Prick]

@onready var TimerGame: Timer = $TimerGame

@export var BillControllScene: PackedScene

@export var CurrentProblem: ActiveProblem
@export var Bills: Array[Bill]
@export var BCN: Array[BillControll]
@export var CurrentPrick: Prick

@export var Aligment: int

@export var solvedProblems: int = 0

@export var Budget: int

func BillsEmpty() -> void:
	Bills = AllBills.duplicate_deep()
	Bills.shuffle()

	var i: int = 0;
	for b in Bills:
		var nb: BillControll = BillControllScene.instantiate()
		nb.Headline = b.Title
		nb.ContentBill = b.Description
		nb.position = Vector2(200 + (255 * i), 24)
		add_child(nb)
		BCN.append(nb)
		i += 1


func _ready() -> void:
	BillsEmpty()
	CurrentPrick = AllPricks.pick_random()
	CurrentProblem = ActiveProblem.new()
	CurrentProblem.Prob = AllProblems.pick_random()
	


func ButtonBressed():
	var currentTime: float = TimerGame.time_left
	TimerGame.start(currentTime + Bills[0].TimeModify)
	Budget += Bills[0].MoneyTransfer
	if Bills[0].ProblemResolution != null:
		if Bills[0].ProblemResolution.Target == CurrentProblem.Prob:
			CurrentProblem.Resolution += Bills[0].ProblemResolution.ResolutionAmount
			Budget -= Bills[0].ProblemResolution.ResolutionAmount
	
	$Control/Budget.text = "¢" + str(float(Budget) / 10)
	$Control/SolvedProblems.text = str(solvedProblems)
	$Control/TextureProgressBar.value = CurrentProblem.Resolution

	print(CurrentProblem.Resolution)
	BCN[0].OffTheyGo()
	BCN.remove_at(0)
	for i in BCN:
		i.NextPls()
	Bills.pop_front()
	if Bills.size() == 0:
		BillsEmpty()
	
func _process(_delta: float) -> void:
	if CurrentProblem.Resolution > CurrentProblem.Prob.Budget:
		CurrentProblem = ActiveProblem.new()
		CurrentProblem.Prob = AllProblems.pick_random()
		solvedProblems += 1
	$Control/TimerLabel.text = str(int($TimerGame.time_left) / 60) + ":" + str(int($TimerGame.time_left) % 60)
	$Control/PrickName.text = CurrentPrick.Name
	$Control/ProblemText.text = CurrentProblem.Prob.Name
	$Control/TextureProgressBar.max_value = CurrentProblem.Prob.Budget

func _input(_event: InputEvent) -> void:
	if _event is  InputEventKey and _event.pressed:
		if _event.keycode == KEY_SPACE:
			ButtonBressed()

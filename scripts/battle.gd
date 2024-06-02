extends Node2D

enum BattleState {RUNNING, WIN, LOSE, TIE}

@export var first_team: Array[Emoji]
@export var second_team: Array[Emoji]
var index: int
var turn: int
var turns_left: int
var press_turns: int
var battle_state: BattleState

func _ready():
	index = 0
	turn = 0
	turns_left = len(first_team)
	press_turns = 0
	battle_state = BattleState.RUNNING


func _get_random_emoji(emojis: Array[Emoji]):
	return emojis.pick_random()


func _get_living_emojis(emojis: Array[Emoji]):
	var living_emojis = 0
	for emoji in emojis:
		if emoji.health > 0:
			living_emojis += 1
	return living_emojis


func _check_death():
	var living_emojis1 = _get_living_emojis(first_team)
	var living_emojis2 = _get_living_emojis(second_team)
	
	if living_emojis1 == 0 and living_emojis2 == 0:
		self.battle_state = BattleState.TIE
	elif living_emojis1 == 0:
		self.battle_state = BattleState.LOSE
	elif living_emojis2 == 0:
		self.battle_state = BattleState.WIN


func _get_current_team():
	return first_team if turn == 0 else second_team


func _get_other_team():
	return second_team if turn == 0 else first_team


func _pass_turn():
	var current_team = _get_current_team()
	var press_turn = current_team[self.index].press_turn
	self.index = (self.index + 1) % len(current_team)
	if press_turn and self.press_turns < self.turns_left:
		self.press_turns += 1
	else:
		self.turns_left -= 1
		if self.press_turns > 0:
			self.press_turns -= 1
	
	if self.turns_left == 0:
		self.turn = (self.turn + 1) % 2
		self.index = 0
		self.turns_left = _get_living_emojis(_get_current_team())


func _tick():
	if self.battle_state != BattleState.RUNNING:
		return

	var current_team: Array[Emoji] = _get_current_team()
	var other_team: Array[Emoji] = _get_other_team()
	var current_emoji: Emoji = current_team[self.index]
	while current_emoji.health <= 0:
		self.index = (self.index + 1) % len(current_team)
		current_emoji = current_team[self.index]

	var target: Emoji = _get_random_emoji(_get_other_team())
	target.health -= current_emoji.attack
	
	self._check_death()
	self._pass_turn()


func _process(delta):
	pass


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			_tick()

extends ContentInfo

var unsellable_stickers:Array = []
var unsellable_stickers_by_tag:Dictionary = {}
var exchange_code = preload("res://mods/VendingMachine_Mod/scripts/exchange_code_patch.gd")

func _init():
	exchange_code.patch()

	var by_id = Datatables.load("res://data/battle_moves/").table
	var moves = by_id.values()
	for move in moves:
		if move.is_debug:
			continue
		if move.tags.has("asleep") or move.tags.has("fusion"):
			continue
		if move.name == "MOVE_NAME_BOOBY_TRAP":
			continue
		for tag in move.tags:
			assert (tag != "")
			if tag == "unsellable":
				unsellable_stickers.push_back(move)
				if not unsellable_stickers_by_tag.has(tag):
					unsellable_stickers_by_tag[tag] = []
				unsellable_stickers_by_tag[tag].push_back(move)


extends BaseLootTable

export (Array, String) var sticker_tags:Array
export (int) var num_stickers:int = 6
export (int) var num_rarity_upgrades:int = 1

var bad_forecast = preload("res://data/battle_moves/bad_forecast.tres")

func generate_rewards(rand:Random, _max_value:int, max_num:int = - 1)->Array:
	var rewards = []

	var count = num_stickers
	if max_num >= 0 and max_num < count:
		count = max_num

	var moves:Array
	if sticker_tags.size() == 0:
		moves = DLC.mods_by_id["vending_stacks_mod"].unsellable_stickers
	else :
		for tag in sticker_tags:
			moves += DLC.mods_by_id["vending_stacks_mod"].unsellable_stickers_by_tag.get(tag, [])

	assert (moves.size() > 0)
	if moves.size() == 0:
		return []

	for i in range(count):
		var move = rand.choice(moves)
		var item = ItemFactory.generate_item(move, rand)
		assert (item != null)

		if i < num_rarity_upgrades and move_is_upgradable(item.battle_move):
			item = ItemFactory.upgrade_rarity(item, rand)
			assert (item != null)
			assert (item.rarity >= BaseItem.Rarity.RARITY_UNCOMMON)

		rewards.push_back({item = item, amount = 1})

	return rewards

func move_is_upgradable(move:BattleMove)->bool:
	return move.attribute_profile != null

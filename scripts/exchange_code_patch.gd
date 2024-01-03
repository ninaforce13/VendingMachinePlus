static func patch():
	var script_path = "res://nodes/actions/ExchangeMenuAction.gd"
	var patched_script : GDScript = preload("res://nodes/actions/ExchangeMenuAction.gd")

	if !patched_script.has_source_code():
		var file : File = File.new()
		var err = file.open(script_path, File.READ)
		if err != OK:
			push_error("Check that %s is included in Modified Files"% script_path)
			return
		patched_script.source_code = file.get_as_text()
		file.close()

	var code_lines:Array = patched_script.source_code.split("\n")

	var class_name_index = code_lines.find("class_name ExchangeMenuAction")
	if class_name_index >= 0:
		code_lines.remove(class_name_index)

	var code_index = code_lines.find("func _ready():")
	if code_index > 0:
		code_lines.insert(code_index+1,get_code("add_items"))
		code_lines.insert(code_index-1,get_code("add_preloads"))
	else:
		code_index = code_lines.find("func _run():")
		if code_index > 0:
			code_lines.insert(code_index-1,get_code("add_ready"))

	code_lines.insert(code_lines.size()-1,get_code("new_functions"))

	patched_script.source_code = ""
	for line in code_lines:
		patched_script.source_code += line + "\n"
	ExchangeMenuAction.source_code = patched_script.source_code
	var err = ExchangeMenuAction.reload()
	if err != OK:
		push_error("Failed to patch %s." % script_path)
		return

static func get_code(block:String)->String:
	var code_blocks:Dictionary = {}
	code_blocks["add_preloads"] = """
var lightning_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/lightning_booster.tres")
var metal_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/metal_booster.tres")
var plant_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/plant_booster.tres")
var plastic_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/plastic_booster.tres")
var poison_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/poison_booster.tres")
var water_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/water_booster.tres")
var passive_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/passive_booster.tres")
var support_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/support_booster.tres")
var offense_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/offense_booster.tres")
var unsellable_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/unique_booster.tres")
var typeless_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/typeless_booster.tres")
		"""

	code_blocks["add_items"] = """
	if title == "RANGER_VENDING_MACHINE_NAME":
		add_new_boosters(exchanges)
		for packs in exchanges:
			packs.max_amount = 100
"""
	code_blocks["add_ready"] = """
var lightning_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/lightning_booster.tres")
var metal_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/metal_booster.tres")
var plant_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/plant_booster.tres")
var plastic_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/plastic_booster.tres")
var poison_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/poison_booster.tres")
var water_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/water_booster.tres")
var passive_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/passive_booster.tres")
var support_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/support_booster.tres")
var offense_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/offense_booster.tres")
var unsellable_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/unique_booster.tres")
var typeless_booster = preload("res://mods/VendingMachine_Mod/NewBoosterPacks/typeless_booster.tres")
func _ready():
	if title == "RANGER_VENDING_MACHINE_NAME":
		add_new_boosters(exchanges)
		for packs in exchanges:
			packs.max_amount = 100
"""

	code_blocks["new_functions"] = """
func add_new_boosters(exchanges):
	exchanges.append(lightning_booster)
	exchanges.append(metal_booster)
	exchanges.append(plant_booster)
	exchanges.append(plastic_booster)
	exchanges.append(poison_booster)
	exchanges.append(water_booster)
	exchanges.append(passive_booster)
	exchanges.append(support_booster)
	exchanges.append(offense_booster)
	exchanges.append(typeless_booster)
	exchanges.append(unsellable_booster)
	"""
	return code_blocks[block]

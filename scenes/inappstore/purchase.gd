extends Control

const loading = preload("res://scenes/general/loading.tscn")
@onready var OasisPrice = $CanvasLayer/HBoxContainer2/Oasis/Price
@onready var OasisName = $CanvasLayer/HBoxContainer2/Oasis/Name
@onready var OasisTick = $CanvasLayer/HBoxContainer2/Oasis/Tick
@onready var ThreeVillagesPrice = $CanvasLayer/HBoxContainer2/ThreeVillages/Price
@onready var ThreeVillagesName = $CanvasLayer/HBoxContainer2/ThreeVillages/Name
@onready var ThreeVillagesTick = $CanvasLayer/HBoxContainer2/ThreeVillages/Tick
@onready var FoggyValleyPrice = $CanvasLayer/HBoxContainer2/FoggyValley/Price
@onready var FoggyValleyName = $CanvasLayer/HBoxContainer2/FoggyValley/Name
@onready var FoggyValleyTick = $CanvasLayer/HBoxContainer2/FoggyValley/Tick
@onready var ProcessingLabel = $CanvasLayer/ProcessingContainer/Processing
@onready var ErrorLabel = $CanvasLayer/ErrorContainer/Error
@onready var SuccessLabel = $CanvasLayer/SuccessContainer/Success

var in_app_store = null
var processing := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	OasisPrice.text = tr('pooponred_oasis')
	OasisName.text = tr('MAP_4')
	
	ThreeVillagesPrice.text = tr('pooponred_three_village')
	ThreeVillagesName.text = tr('MAP_3')

	FoggyValleyPrice.text = tr('pooponred_foggy_valley')
	FoggyValleyName.text = tr('MAP_2')
	
	ProcessingLabel.text = tr('processing')
	ErrorLabel.text = tr('try_again')
	
	if Engine.has_singleton("InAppStore"):
		in_app_store = Engine.get_singleton("InAppStore")
		in_app_store.request_product_info( { "product_ids": ["pooponred_foggy_valley", "pooponred_three_village", "pooponred_oasis"] } )
		$Timer.start()
	else:
		show_error()
	
	FoggyValleyTick.visible = !!Storage.instance.get_var("pooponred_foggy_valley")
	ThreeVillagesTick.visible = !!Storage.instance.get_var("pooponred_three_village")
	OasisTick.visible = !!Storage.instance.get_var("pooponred_oasis")

func purchase_oasis() -> void:
	if !Storage.instance.get_var("pooponred_oasis") and !processing:
		purchase_product("pooponred_oasis")

func purchase_three_villages() -> void:
	if !Storage.instance.get_var("pooponred_three_village") and !processing:
		purchase_product("pooponred_three_village")

func purchase_foggy_valley() -> void:
	if !Storage.instance.get_var("pooponred_foggy_valley") and !processing:
		purchase_product("pooponred_foggy_valley")

func purchase_product(product_id) -> void:
	if in_app_store:
		in_app_store.set_auto_finish_transaction(true)
		var result = in_app_store.purchase({ "product_id": product_id })
		
		if result == OK:
			processing = true
			ProcessingLabel.visible = true
		else:
			show_error()

func restore_purchased() -> void:
	if in_app_store:
		in_app_store.set_auto_finish_transaction(true)
		var restored = in_app_store.restore_purchases()
		processing = true
		ProcessingLabel.visible = true

func back() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/MapSelection.tscn")

func check_events():
	while in_app_store and in_app_store.get_pending_event_count() > 0:
		var event = in_app_store.pop_pending_event()
		if event.type == "purchase" or event.type == "restore":
			if event.result == "ok":
				Storage.instance.set_var(event.product_id, true)
				show_success(event.product_id)
			#else:
				#show_error()

func show_success(product_id):
	ProcessingLabel.visible = false
	if product_id == 'pooponred_oasis':
		SuccessLabel.text = tr('MAP_4') + tr('PurchaseSuccess')
		OasisTick.visible = true
	if product_id == 'pooponred_three_village':
		SuccessLabel.text = tr('MAP_3') + tr('PurchaseSuccess')
		ThreeVillagesTick.visible = true
	if product_id == 'pooponred_foggy_valley':
		SuccessLabel.text = tr('MAP_2') + tr('PurchaseSuccess')
		FoggyValleyTick.visible = true
	SuccessLabel.visible = true
	await get_tree().create_timer(1.0).timeout
	hide_success()

func hide_success():
	var tween = get_tree().create_tween()
	tween.tween_property(SuccessLabel, 'modulate:a', 0.0, 1)

func show_error():
	ProcessingLabel.visible = false
	ErrorLabel.visible = true
	ErrorLabel.modulate.a = 1.0
	await get_tree().create_timer(1.0).timeout
	hide_error()

func hide_error():
	var tween = get_tree().create_tween()
	tween.tween_property(ErrorLabel, 'modulate:a', 0.0, 1)

tool
class_name ConfirmPopup
extends ColorRect

signal confirmed

const STRICT_COLOR := Color(1, 0.094118, 0.321569)
const NORMAL_COLOR := Color(0.239216, 1, 0.431373)

export var title := "" setget set_title
export(String, MULTILINE) var text_content := "" setget set_text_content
export var min_size := Vector2(200, 120) setget set_min_size
export var strict := false setget set_strict

onready var _root_container := $PanelContainer as Container
onready var _top_bar := $PanelContainer/Column/ProgressBar as ProgressBar
onready var _title_label := $PanelContainer/Column/Margin/Column/Title as Label
onready var _message_content := $PanelContainer/Column/Margin/Column/Message as RichTextLabel

onready var _confirm_button := $PanelContainer/Column/Margin/Column/Buttons/ConfirmButton as Button
onready var _cancel_button := $PanelContainer/Column/Margin/Column/Buttons/CancelButton as Button


func _ready():
	set_as_toplevel(true)
	_root_container.rect_min_size = min_size
	_root_container.rect_size = _root_container.rect_min_size
	_root_container.set_anchors_and_margins_preset(Control.PRESET_CENTER)
	
	_title_label.text = title
	_message_content.bbcode_text = text_content
	_update_top_bar()
	
	_confirm_button.connect("pressed", self, "emit_signal", ["confirmed"])
	_cancel_button.connect("pressed", self, "hide")


func set_title(value: String) -> void:
	title = value
	if is_inside_tree():
		_title_label.text = title


func set_text_content(value: String) -> void:
	text_content = value
	if is_inside_tree():
		_message_content.bbcode_text = text_content


func set_min_size(value: Vector2) -> void:
	min_size = value
	if is_inside_tree():
		_root_container.rect_min_size = min_size
		_root_container.rect_size = _root_container.rect_min_size
		_root_container.set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)


func set_strict(value: bool) -> void:
	strict = value
	_update_top_bar()


func popup() -> void:
	show()
	_root_container.rect_size = _root_container.rect_min_size
	_root_container.set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)


func _update_top_bar() -> void:
	if not is_inside_tree():
		return
	
	var highlight_color = STRICT_COLOR if strict else NORMAL_COLOR
	
	var bar_style := _top_bar.get_stylebox("fg").duplicate()
	if bar_style is StyleBoxFlat:
		(bar_style as StyleBoxFlat).bg_color = highlight_color
	_top_bar.add_stylebox_override("fg", bar_style)
	
	var button_style := _confirm_button.get_stylebox("normal").duplicate()
	if button_style is StyleBoxFlat:
		var button_style_box := button_style as StyleBoxFlat
		button_style_box.bg_color = highlight_color
		button_style_box.set_border_width_all(0)
	_confirm_button.add_stylebox_override("normal", button_style)

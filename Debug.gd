@tool
extends Node
class_name Debug

## colors
const _LOG_COLOR : String = "10FFFF"
const _WARNING_COLOR : String = "FFE100"
const _ERROR_COLOR : String = "FF4545"
const _MESSAGE_COLOR : String = "FFFFFF"

## name of this debug control (i.e., Node name where this class is instantiated). 
var where : String
var font_size : int = 20
var _node : Node


## inits the name for this instance to know from where the message comes from. 
func _init(_self : Node) -> void:
	where = _self.name
	_node = _self
	

## simple message
func log(message : String, pause_execution = false) -> void:
	if _is_on_editor():
		print_rich("[b][color=%s]Script '%s' says:[/color][b] [color=%s]%s[/color]" %[_LOG_COLOR, where, _MESSAGE_COLOR, message])
		
		assert(not pause_execution, message)

## info message
func log_warn(message : String, pause_execution = false) -> void:
	if _is_on_editor():
		print_rich("[b][color=%s]Script '%s' warns a message:[/color][b] [color=%s]%s[/color]" %[_WARNING_COLOR, where, _MESSAGE_COLOR, message])
		push_warning(message)
		
		assert(not pause_execution, message)

## error message
func log_error(message : String, pause_execution = true) -> void:
	if _is_on_editor():
		print_rich("[b][color=%s]Script '%s' says there's an error:[/color][b] [color=%s]%s[/color]" %[_ERROR_COLOR, where, _MESSAGE_COLOR, message])
		push_error(message)
		scope()
		assert(not pause_execution, message)
		
	
func _is_on_editor() -> bool:
	return OS.has_feature("editor")
	

func scope() -> void:
	const GD_EXTENSION = ".gd"
	
	var trl = RichTextLabel.new()
	trl.connect("meta_clicked",_on_url_click)
	
	var file_finder = FileFinder.new()
	
	## class_name and script file names must match to make this work
	var script_name : StringName = _node.get_script().get_global_name().to_lower() + GD_EXTENSION
	
	var script_res_path = file_finder.find_path_to_file(script_name)
	var script_user_path = file_finder._get_user_file_path(script_res_path)
	
	trl.text = "[url=%s]%s[/url]" % [script_user_path,script_name]

	print_rich(trl.text)


func _on_url_click(meta : String) -> void:
	print("url")
	OS.shell_open(str(meta))
	pass
	
		
## Debug used colors must be here	
class DebugColor:
	const BLACK = "000000"


## Logic for printing images in console must be here
class PrintImage:
	
	func console_image(_path : String) -> void:
		#var path = "res://icon.svg"
		print_rich("[img]%s[/img]"%_path)


## Logic for finding files that Debug uses must be here
class FileFinder:
	
	## returns user absolute path or empty string if not running in editor and pushes a warning
	func _get_user_file_path(editor_path) -> String:
		# Running in editor
		if _is_on_editor():
			return ProjectSettings.globalize_path(editor_path)
			
		else:
			push_warning("Not executing in editor")
			return ""
	
	func find_path_to_file(_name : String) -> String:
		var dir = DirAccess.open("res://")
		var directories = _find_directories(dir)
		#_print_directories(directories)
		var file_path = _get_file_path(directories,_name)
		return file_path
	

	func exists(_name):
		var dir = DirAccess.open("res://")
		var directories = _find_directories(dir)
		#print_directories(directories)
		var file_path = _get_file_path(directories,_name)
		if file_path.is_empty():
			return false
		else: return true


	## ChatGPT courtesy directory recursive find
	func _find_directories(dir: DirAccess) -> PackedStringArray:
		# Initialize the list to store directories
		var list_directories: PackedStringArray = []

		# Ensure we're in the editor and have a valid directory
		if _is_on_editor() and dir != null:
			# Add the current directory to the list
			list_directories.append(dir.get_current_dir())

			# Start listing the contents of the directory
			dir.list_dir_begin()

			var file_or_dir = dir.get_next()
			while file_or_dir != "":
				# Check if the item is a directory (not the parent or current directory)
				if dir.current_is_dir() and file_or_dir != "." and file_or_dir != "..":
					# Open the subdirectory
					var new_dir = DirAccess.open(dir.get_current_dir() + "/" + file_or_dir)
					
					if new_dir != null:
						# Recursively add directories from the subdirectory
						list_directories.append_array(_find_directories(new_dir))
				
				# Get the next item
				file_or_dir = dir.get_next()
			
			# Close the directory stream
			dir.list_dir_end()

		return list_directories

		
		
	func _get_file_path(directory_list : PackedStringArray, file_name : String) -> String:
		var file_path = ""
		if _is_on_editor():
			for directory in directory_list:
				var found = DirAccess.get_files_at(directory).has(file_name)
				if found:
					file_path = directory + "/" + file_name
					break;
		else:
			print("Not running in editor")
			return ""
			
		return file_path
			
	
	func _print_directories(array : PackedStringArray) -> void:
		for directory in array:
			directory = directory.trim_prefix("res://")
			var dirs = directory.split("/")
			print(dirs)
					

	func _is_on_editor():
		return OS.has_feature("editor")

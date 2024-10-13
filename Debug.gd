@tool
extends Node
## Debug class that customizes pushing warnings, errors or simply console log messages
## At instancing you must pass [code]self[/code].
## @experimental: Work in progress
class_name Debug

## Color for simple console message
const _LOG_COLOR : String = "10FFFF"
## Color for warning message
const _WARNING_COLOR : String = "FFE100"
## Color for error message
const _ERROR_COLOR : String = "FF4545"
## Color for the message itself
const _MESSAGE_COLOR : String = "FFFFFF"

## Name of this debug control (i.e., Node name where this class is instantiated). 
var where : String
## Font size for the printed logs.
var font_size : int = 20

var _node : Node
var _timer : Timer = Timer.new()
const _TIMER_DEFAULT_TIME : float = 2
var _fps : float = 0.0
var _seconds_warning_message : bool = false

# setting custom setter to change the timer wait_time
var _seconds : float = -1:
	set(value):
		if value == _TIMER_DEFAULT_TIME && not _seconds_warning_message:
			_seconds = value
		else:
			_seconds_warning_message = false
			_seconds = value
			_timer.wait_time = _seconds
		

## If set to true, the messages will print in the OS console since this one
## it's different from Output dock.
## @experimental: Not implemented in every log functions of this class. 
var print_to_os_console : bool = false

## inits the name for this instance to know from where the message comes from. 
func _init(_self : Node) -> void:
	where = _self.name
	_node = _self
	
	_timer.one_shot = false
	_timer.autostart = false
	_timer.name = "fps_timer"
	_timer.paused = true
	_node.add_child(_timer,false,Node.INTERNAL_MODE_BACK)
	_timer.paused = false
	_timer.timeout.connect(_on_time_out,CONNECT_PERSIST)
	_timer.start(_TIMER_DEFAULT_TIME)
	

## Simple message
func log(message : String, pause_execution = false) -> void:
	if _is_on_editor():
		print_rich("[b][color=%s]Script '%s' says:[/color][b] [color=%s]%s[/color]" %[_LOG_COLOR, where, _MESSAGE_COLOR, message])
		
		assert(not pause_execution, message)


## Info message
func log_warn(message : String, pause_execution = false) -> void:
	if _is_on_editor():
		print_rich("[b][color=%s]Script '%s' warns a message:[/color][b] [color=%s]%s[/color]" %[_WARNING_COLOR, where, _MESSAGE_COLOR, message])
		push_warning(message)
		
		assert(not pause_execution, message)

## Error message. Pauses execution by default unless [code]pause_execution[/code] is set to true
func log_error(message : String, pause_execution = true) -> void:
	if _is_on_editor():
		print_rich("[b][color=%s]Script '%s' says there's an error:[/color][b] [color=%s]%s[/color]" %[_ERROR_COLOR, where, _MESSAGE_COLOR, message])
		push_error(message)
		scope()
		assert(not pause_execution, message)


## Prints frames per second every 2 seconds by default and returns frame rate in %.1f format.[br] 
## The paramater [code]seconds[/code] is the time delay in seconds between each Output dock print.
## The frame rate returned comes from the current [SceneTree]. 
func log_fps_every_seconds(seconds : float = _TIMER_DEFAULT_TIME)  -> float:
	
	if seconds > 0:
		_seconds = seconds
		
	if seconds <= 0:
		_seconds = _TIMER_DEFAULT_TIME
		_seconds_warning_message = true
		
	return _fps
	
	
# Callable for log_fps_every_seconds timersignal. 
func _on_time_out() -> float:
	_fps = Engine.get_frames_per_second()
	
	if _seconds_warning_message:
		log_warn("'log_fps_every_seconds' function needs a time greater than 0. Time set to default (2s).")
		
	if print_to_os_console:
		printraw("\nFPS: %.1f" % _fps)
		
	else:
		print("FPS : %0.1f" % _fps)
			
	return _fps
		
	
func _is_on_editor() -> bool:
	return OS.has_feature("editor")
	
# Gets the user path to a given script
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

	# Recursive directory search
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

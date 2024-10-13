# Debug.gd class:

##  How to use
To use this tool, you must instantiate the Debug class in the Node's attached script as following: 

`var debug : Debug = Debug.new(self)`
### It is important to read 'Must have' section
then you can use it i.e.: 	

	debug.log("Hi.") # info message 
	debug.log_warn("Warning.") # warning message 
	debug.log_error("Error.") # error message 

Every Debug.log function has a last boolean parameter where you can optionally specify if the execution will be interrupted or not:

	debug.log("Today is a day", true) # this will stop the execution
	debug.log("A day is a day") # this will not stop the execution
	debug.log_error("Some soft error", false) # this will not stop execution

As you can see, `log_error` stops the execution by default without specify the last parameter. 

### Printing current frame rate. 
To get the current frame rate in the scene where Debug class was instantiated follow the next examples:
```
	debug.log_fps_every_seconds()# prints every 2 seconds (the default time).
	debug.log_fps_every_seconds(5)# prints every 5 seconds.
	debug.log_fps_every_seconds(0)# prints fps and a warning using the default time.
	debug.log_fps_every_seconds(-1)# prints fps and a warning using the default time.
```




## Colors
### Difference between LOG_COLOR and LOG_MESSAGE

 - **LOG_COLOR** it's used for the Node name ('where' class property).
 - **LOG_MESSAGE** it's used for the message itself passed in the different log functions as parameter.

## Must have

 - The script where the Debug class will be instantiated needs to have: `class_name SomeClassName`
Doing this the Debug instance will have a way to reference the current script.  

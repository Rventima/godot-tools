# Debug.gd class:

##  How to use
To use this tool, you must instantiate the Debug class in the Node's attached script as following: 

`var debug : Debug = Debug.new(self)`
### It is important toread 'Must have' section
then you can use it i.e.: 	

	debug.log("Hi.") # info message 
	debug.log_warn("Warning.") # warning message 
	debug.log_error("Error.") # error message 

Every Debug.log function has a last boolean parameter where you can optionally specify if the execution will be interrupted or not:

	debug.log("Today is a day", true) # this will stop the execution
	debug.log("A day is a day") # this will not stop the execution
	debug.log_error("Some soft error", false) # this will not stop execution

As you can see, `log_error` stops the execution by default without specify the last parameter. 

 



## Colors
### Difference between LOG_COLOR and LOG_MESSAGE

 - **LOG_COLOR** it's used for the Node name ('where' class property).
 - **LOG_MESSAGE** it's used for the message itself passed in the different log functions as parameter.

## Must have

 - The script where the Debug class will be instantiated needs to have: `class_name SomeClassName`
Doing this the Debug instance will have a way to reference the current script.  

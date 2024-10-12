# Debug.gd class:

For use this tool, you must instantiate the class in the next way : var debug : Debug = Debug.new(self.name)\
then you can use it i.e.: 	\

debug.log("Hi.") # info message \
debug.log_warn("Warning.") # warning message \
debug.log_error("Error.") # error message \

## colors
### Difference between LOG_COLOR and LOG_MESSAGE
LOG_COLOR it's used for the Node name ('where' class property). \
LOG_MESSAGE it's used for the message itself passed in the different log functions as parameter. \


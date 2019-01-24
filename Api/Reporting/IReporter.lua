--binding Interface, that is used for ActionReporter implementations
--if you want to use a self made class as a reporter in the api,
--then the class must at least implement functions with the prototypes:
--if your calss implements this interface mark it with:
-- IReporter



---will give the reporter the chance to initialize fields before usage of the reporter
--for example can be used to establish a rednet connection or open a file for writing
--the contract states, that this method must be called by everyone 
--who wants to use this reporter. 
--Thus it can be called multiple times and should not produce errors in this case.
--@return Must return whether or not the init code was succesfull
function bool_Init()
    error("Tried to execute Reporter interface!")
end

---Reports an Info. This is usually something like a status update for the user
--or the result of an action
function ReportInfo(str_message)
    error("Tried to execute Reporter interface!")
end

---Reports a warning. Usually something, that should be considered by the user.
--or an abnomally, that can be handled by the program
function ReportWarning(str_message)
    error("Tried to execute Reporter interface!")
end

---Reports a debug message.Mostly for development reasons.
--After development, this function can be made to a nop
--or you can easily search and replace in your code to remove calls to this method
function ReportDebug(str_message)
    error("Tried to execute Reporter interface!")
end

---Reports an error to the user. Usually something, that results in
--unusual termination of the program or something, that cant be handled by the program
function ReportError(str_message)
    error("Tried to execute Reporter interface!")
end

--End of Interface Defintion

---Can be used to check if a certain object is an implementation of this interface
--@return tru if the obj implements the IReporter interface, false otherwise
function bool_CheckisInterfaceImplementation(obj_toCheck)
    if(type(obj_toCheck.bool_Init) == nil)then
        return false
    end
    if(type(obj_toCheck.ReportDebug) == nil)then
        return false
    end
    if(type(obj_toCheck.ReportWarning) == nil)then
        return false
    end
    if(type(obj_toCheck.ReportError) == nil)then
        return false
    end
    if(type(obj_toCheck.ReportInfo) == nil)then
        return false
    end
    return true
end
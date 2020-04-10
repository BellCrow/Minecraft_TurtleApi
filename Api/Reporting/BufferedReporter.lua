--implements IReporter
BufferedReporter = {}
BufferedReporter.__index = BufferedReporter

---Creates a new instance of the BufferedReporter
function BufferedReporter:New()
    local instance = {}
    instance.table_DebugList = {}
    instance.table_WarningList = {}
    instance.table_InfoList = {}
    instance.table_ErrorList = {}
    setmetatable(instance, BufferedReporter)
    return instance;
end

--IActionReporter implementation start
---see API_IReporter
function BufferedReporter:bool_Init()
    return true 
end
---see API_IReporter
function BufferedReporter:ReportInfo(str_message)
    table.insert(self.table_InfoList,str_message)
end
---see API_IReporter
function BufferedReporter:ReportWarning(str_message)
    table.insert(self.table_WarningList,str_message)
end
---see API_IReporter
function BufferedReporter:ReportDebug(str_message)
    table.insert(self.table_DebugList,str_message)
end
---see API_IReporter
function BufferedReporter:ReportError(str_message)
    table.insert(self.table_ErrorList,str_message)
end

--IActionReporter implementations end
---Returns a table with all logged informations
--@return A table with all logged informations
function BufferedReporter:GetInfoList(str_message)
    return self.table_InfoList
end

---Returns a table with all logged warnings
--@return A table with all logged warnings
function BufferedReporter:GetWarningList(str_message)
    return self.table_WarningList
end

---Returns a table with all logged debug messages
--@return A table with all logged debug messages
function BufferedReporter:GetDebugList(str_message)
    return self.table_DebugList
end

---Returns a table with all logged errors
--@return A table with all logged errors
function BufferedReporter:GetErrorList(str_message)
    return self.table_ErrorList
end
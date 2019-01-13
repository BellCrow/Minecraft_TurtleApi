--implements Ieporter


--will buffer all log messages in respective tables and
--can deliver theses message to a caller
BufferedReporter = {}
BufferedReporter.__index = BufferedReporter

function BufferedReporter:New()
    instance = {}
    instance.table_DebugList = {}
    instance.table_WarningList = {}
    instance.table_InfoList = {}
    instance.table_ErrorList = {}
    setmetatable(instance, BufferedReporter)
    return instance;
end

--IActionReporter implementations start
function BufferedReporter:bool_Init()
    return true 
end

function BufferedReporter:ReportInfo(str_message)
    print("in func")
    table.insert(self.table_InfoList,str_message)
end

function BufferedReporter:ReportWarning(str_message)
    table.insert(self.table_WarningList,str_message)
end

function BufferedReporter:ReportDebug(str_message)
    table.insert(self.table_DebugList,str_message)
end

function BufferedReporter:ReportError(str_message)
    table.insert(self.table_ErrorList,str_message)
end

--IActionReporter implementations end

function BufferedReporter:GetInfoList(str_message)
    return self.table_InfoList
end

function BufferedReporter:GetWarningList(str_message)
    return self.table_WarningList
end

function BufferedReporter:GetDebugList(str_message)
    return self.table_DebugList
end

function BufferedReporter:GetErrorList(str_message)
    return self.table_ErrorList
end
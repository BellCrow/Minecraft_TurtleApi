--implements IActionReporter


--will buffer all log messages in respective tables and
--can deliver theses message to a caller
BufferedActionReporter = {}
BufferedActionReporter.__index__ = BufferedActionReporter

function BufferedActionReporter:New()
    instance = {}
    instance.table_DebugList = {}
    instance.table_WarningList = {}
    instance.table_InfoList = {}
    instance.table_ErrorList = {}
end

--IActionReporter implementations start
function BufferedActionReporter:bool_Init()return true end

function BufferedActionReporter:ReportInfo(str_message)
    table.insert(self.table_InfoList,str_message)
end

function BufferedActionReporter:ReportWarning(str_message)
    table.insert(self.table_WarningList,str_message)
end

function BufferedActionReporter:ReportDebug(str_message)
    table.insert(self.table_DebugList,str_message)
end

function BufferedActionReporter:ReportError(str_message)
    table.insert(self.table_ErrorList,str_message)
end

--IActionReporter implementations end

function BufferedActionReporter:GetInfoList(str_message)
    return self.table_InfoList
end

function BufferedActionReporter:GetWarningList(str_message)
    return self.table_WarningList
end

function BufferedActionReporter:GetDebugList(str_message)
    return self.table_DebugList
end

function BufferedActionReporter:GetErrorList(str_message)
    return self.table_ErrorList
end
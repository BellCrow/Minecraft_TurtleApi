-- implements IReporter


--a default actionreporter, that doesnt do anything with the message
--can be created by apis, if no actionreporter is supplied in
--order to not have to check for nil on every call.
NullReporter = {}
NullReporter.__index = NullReporter

function NullReporter:New()
    local instance = {}
    setmetatable(instance,NullReporter)
    return instance
end

function NullReporter:bool_Init()end

function NullReporter:ReportInfo(str_message)end

function NullReporter:ReportWarning(str_message)end

function NullReporter:ReportDebug(str_message)end

function NullReporter:ReportError(str_message)end
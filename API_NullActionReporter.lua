-- implements IActionReporter


--a default actionreporter, that doesnt do antything with the message
--can be created by apis, if no actionreporter is supplied in
--order to not have to check for nill on every call.
NullActionReporter = {}
NullActionReporter.__index = NullActionReporter

function NullActionReporter:New()
    instance = {}
    setmetatable(instanc,NullActionReporter)
    return instance
end

function NullActionReporter:bool_Init()end

function NullActionReporter:ReportInfo(str_message)end

function NullActionReporter:ReportWarning(str_message)end

function NullActionReporter:ReportDebug(str_message)end

function NullActionReporter:ReportError(str_message)end
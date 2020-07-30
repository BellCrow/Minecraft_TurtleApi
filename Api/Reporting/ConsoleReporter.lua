--implements the API_IActionReporter
ConsoleReporter = {}
ConsoleReporter.__index = ConsoleReporter

function ConsoleReporter:New()
    local instance = {}
    setmetatable(instance, ConsoleReporter)
end

function ConsoleReporter:bool_Init()
    --no init for console logger needed
    return true
end

function ConsoleReporter:ReportInfo(str_message)
    print("I:"..str_message)
end

function ConsoleReporter:ReportWarning(str_message)
    print("W:"..str_message)
end

function ConsoleReporter:ReportDebug(str_message)
    print("D:"..str_message)
end

function ConsoleReporter:ReportError(str_message)
    print("E:"..str_message)
end
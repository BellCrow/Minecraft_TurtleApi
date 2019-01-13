--implements the API_IActionReporter
ConsoleActionReporter = {}
ConsoleActionReporter.__index = ConsoleActionReporter

function ConsoleActionReporter:New()
    instance = {}
    setemetatable(instance, ConsoleActionReporter)
end

function ConsoleActionReporter:bool_Init()
    --no init for console logger needed
    return true
end

function ConsoleActionReporter:ReportInfo(str_message)
    print("I:"..str_message)
end

function ConsoleActionReporter:ReportWarning(str_message)
    print("W:"..str_message)
end

function ConsoleActionReporter:ReportDebug(str_message)
    print("D:"..str_message)
end

function ConsoleActionReporter:ReportError(str_message)
    print("E:"..str_message)
end
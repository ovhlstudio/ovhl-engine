--[[ @Component: CoreTypes (Shared) ]]
local CoreTypes = {}

export type Logger = {
    Info: (self: Logger, domain: string, msg: string, data: any?) -> (),
    Warn: (self: Logger, domain: string, msg: string, data: any?) -> (),
    Error: (self: Logger, domain: string, msg: string, data: any?) -> ()
}

export type SystemContext = {
    Logger: Logger,
    ConfigLoader: any,
    Network: any,
    [string]: any
}

return CoreTypes

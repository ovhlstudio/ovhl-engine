--[[
OVHL ENGINE V3.0.0 - CORE TYPE DEFINITIONS
Version: 3.0.0
Path: ReplicatedStorage.OVHL.Types.CoreTypes

PURPOSE:
- Centralized type definitions for Luau type checking
- Support for new V3.0.0 systems (Security, Registry, UI)
--]]

export type Logger = {
    Debug: (self: Logger, domain: string, message: string, metadata: any?) -> (),
    Info: (self: Logger, domain: string, message: string, metadata: any?) -> (),
    Warn: (self: Logger, domain: string, message: string, metadata: any?) -> (),
    Error: (self: Logger, domain: string, message: string, metadata: any?) -> (),
    Critical: (self: Logger, domain: string, message: string, metadata: any?) -> (),
    SetModel: (self: Logger, modelName: string) -> boolean,
}

export type SystemRegistry = {
    RegisterSystem: (self: SystemRegistry, name: string, instance: any, deps: {string}?) -> boolean,
    GetSystem: (self: SystemRegistry, name: string) -> any?,
    GetHealthStatus: (self: SystemRegistry) -> {[string]: any},
}

export type OVHL = {
    GetSystem: (self: OVHL, name: string) -> any?,
    GetConfig: (self: OVHL, module: string, key: string?, context: string?) -> any?,
    GetClientConfig: (self: OVHL, module: string, key: string?) -> any?,
    ValidateInput: (self: OVHL, schema: string, data: any) -> (boolean, string?),
    CheckPermission: (self: OVHL, player: Player, node: string) -> (boolean, string?),
    CheckRateLimit: (self: OVHL, player: Player, action: string) -> boolean,
}

-- Security Types
export type InputSchema = {
    type: string,
    fields: {[string]: FieldSchema}?,
    min: number?,
    max: number?,
    pattern: string?
}

export type FieldSchema = {
    type: string,
    optional: boolean?,
    min: number?,
    max: number?
}

-- UI Types
export type UIConfig = {
    Mode: "FUSION" | "NATIVE",
    NativePath: string?,
    FallbackMode: string?
}

return nil

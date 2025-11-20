---
type: project-snapshot
purpose: AI Analysis & Debugging Context
usage: Upload this entire file to AI for project understanding
---

# 🤖 AI ANALYSIS CONTEXT

> **Instructions for AI:**
>
> - This document contains complete project structure and codebase
> - All file paths are relative to project root
> - Use this for: debugging, code analysis, refactoring suggestions, architecture review
> - When referencing code, cite: `File: path/to/file.lua, Line: X`

---

# 📊 Project Snapshot

**Generated:** 2025-11-19 09:59:43  
**Target Directories:** `src tests`  
**Git Info:** Branch: refactor/ui-atomization | Commit: c29dc75 | Modified files: 0  
**Structure:** 42 folders | 62 files (61 Lua, 1 other)
**File Distribution:** Server: 15 (22K, 761 lines) | Client: 13 (25K, 847 lines) | Shared: 33 (97K, 3K lines)
**Total Size:** 145K

---

## 📁 Project Structure

```
📦 src/
  ├── 📁 ReplicatedStorage/
    ├── 📁 OVHL/
      ├── 📁 Config/
        ├── 🌙 EngineConfig.lua
        ├── 🌙 LoggerConfig.lua
      ├── 📁 Core/
        ├── 🌙 Bootstrap.lua
        ├── 🌙 Kernel.lua
        ├── 🌙 OVHL.lua
        ├── 🌙 SystemRegistry.lua
      ├── 📁 Shared/
        ├── 📁 Modules/
          ├── 📁 Global/
            ├── 🌙 Constants.lua
          ├── 📁 MinimalModule/
            ├── 🌙 SharedConfig.lua
          ├── 📁 PrototypeShop/
            ├── 🌙 SharedConfig.lua
      ├── 📁 Systems/
        ├── 📁 Adapters/
          ├── 📁 Navbar/
            ├── 🌙 InternalAdapter.lua
            ├── 🌙 TopbarPlusAdapter.lua
          ├── 📁 Permission/
            ├── 🌙 HDAdminAdapter.lua
            ├── 🌙 InternalAdapter.lua
        ├── 📁 Foundation/
          ├── 🌙 ConfigLoader.lua
          ├── 🌙 ConfigLoaderManifest.lua
          ├── 🌙 SmartLogger.lua
          ├── 🌙 SmartLoggerManifest.lua
          ├── 🌙 StudioFormatter.lua
        ├── 📁 Networking/
          ├── 🌙 NetworkingRouter.lua
          ├── 🌙 NetworkingRouterManifest.lua
          ├── 🌙 NetworkSecurity.lua
          ├── 🌙 RemoteBuilder.lua
        ├── 📁 Security/
          ├── 🌙 InputValidator.lua
          ├── 🌙 InputValidatorManifest.lua
          ├── 🌙 PermissionCore.lua
          ├── 🌙 PermissionCoreManifest.lua
          ├── 🌙 SecurityHelper.lua
        ├── 📁 UI/
          ├── 🌙 ComponentScanner.lua
      ├── 📁 Types/
        ├── 🌙 CoreTypes.lua
        ├── 🌙 ScannerContract.lua
  ├── 📁 ServerScriptService/
    ├── 📁 OVHL/
      ├── 📁 Debug_MockAssets/
        ├── 🌙 Install_Mock_UI.server.lua
      ├── 📁 Modules/
        ├── 📁 MinimalModule/
          ├── 🌙 MinimalService.lua
          ├── 🌙 ServerConfig.lua
        ├── 📁 PrototypeShop/
          ├── 🌙 PrototypeShopService.lua
          ├── 🌙 ServerConfig.lua
      ├── 🌙 ServerRuntime.server.lua
      ├── 📁 Systems/
        ├── 📁 Advanced/
          ├── 🌙 DataManager.lua
          ├── 🌙 DataManagerManifest.lua
          ├── 🌙 NotificationService.lua
          ├── 🌙 NotificationServiceManifest.lua
          ├── 🌙 PlayerManager.lua
          ├── 🌙 PlayerManagerManifest.lua
        ├── 📁 Security/
          ├── 🌙 NetworkGuard.lua
          ├── 🌙 RateLimiter.lua
          ├── 🌙 RateLimiterManifest.lua
  ├── 📁 StarterPlayer/
    ├── 📁 StarterPlayerScripts/
      ├── 📁 OVHL/
        ├── 🌙 ClientRuntime.client.lua
        ├── 📁 Modules/
          ├── 📁 MinimalModule/
            ├── 🌙 ClientConfig.lua
            ├── 🌙 MinimalController.lua
            ├── 📁 Views/
              ├── 🌙 ClientView.lua
          ├── 📁 PrototypeShop/
            ├── 🌙 ClientConfig.lua
            ├── 🌙 ShopController.lua
            ├── 📁 Views/
              ├── 🌙 ClientView.lua
        ├── 📁 Systems/
          ├── 📁 UI/
            ├── 🌙 AssetLoader.lua
            ├── 🌙 AssetLoaderManifest.lua
            ├── 🌙 UIEngine.lua
            ├── 🌙 UIEngineManifest.lua
            ├── 🌙 UIManager.lua
            ├── 🌙 UIManagerManifest.lua
```

```
📦 tests/
  ├── 📁 E2E/
  ├── 📁 Integration/
  ├── 📁 Unit/
```

## 📂 Directory Overview

### 📦 src

- 📁 **ReplicatedStorage/OVHL/Config**: 2 Lua file(s)
- 📁 **ReplicatedStorage/OVHL/Core**: 4 Lua file(s)
- 📁 **ReplicatedStorage/OVHL/Shared/Modules/Global**: 1 Lua file(s)
- 📁 **ReplicatedStorage/OVHL/Shared/Modules/MinimalModule**: 1 Lua file(s)
- 📁 **ReplicatedStorage/OVHL/Shared/Modules/PrototypeShop**: 1 Lua file(s)
- 📁 **ReplicatedStorage/OVHL/Systems/Adapters/Navbar**: 2 Lua file(s)
- 📁 **ReplicatedStorage/OVHL/Systems/Adapters/Permission**: 2 Lua file(s)
- 📁 **ReplicatedStorage/OVHL/Systems/Foundation**: 5 Lua file(s)
- 📁 **ReplicatedStorage/OVHL/Systems/Networking**: 4 Lua file(s)
- 📁 **ReplicatedStorage/OVHL/Systems/Security**: 5 Lua file(s)
- 📁 **ReplicatedStorage/OVHL/Systems/UI**: 1 Lua file(s)
- 📁 **ReplicatedStorage/OVHL/Types**: 2 Lua file(s)
- 📁 **ServerScriptService/OVHL**: 1 Lua file(s)
- 📁 **ServerScriptService/OVHL/Debug_MockAssets**: 1 Lua file(s)
- 📁 **ServerScriptService/OVHL/Modules/MinimalModule**: 2 Lua file(s)
- 📁 **ServerScriptService/OVHL/Modules/PrototypeShop**: 2 Lua file(s)
- 📁 **ServerScriptService/OVHL/Systems/Advanced**: 6 Lua file(s)
- 📁 **ServerScriptService/OVHL/Systems/Security**: 3 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL**: 1 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Modules/MinimalModule**: 2 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Modules/MinimalModule/Views**: 1 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop**: 2 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/Views**: 1 Lua file(s)
- 📁 **StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI**: 6 Lua file(s)

### 📦 tests

- 📁 **Unit**: 3 Lua file(s)

---

## 🔗 Dependency Analysis

### 📊 System Dependencies

- **AssetLoader** → SmartLogger
- **InputValidator** → SmartLogger
- **NetworkingRouter** → SmartLogger
- **NotificationService** → SmartLogger
- **PermissionCore** → SmartLogger
- **PlayerManager** → SmartLogger
- **RateLimiter** → SmartLogger
- **SmartLogger** → ConfigLoader
- **UIEngine** → SmartLogger
- **UIManager** → SmartLogger

### 📥 Dependent Systems

- **ConfigLoader** ← SmartLogger
- **SmartLogger** ← NetworkingRouter InputValidator PermissionCore NotificationService PlayerManager RateLimiter AssetLoader UIEngine UIManager

### ⚠️ Circular Dependency Check

✅ No circular dependencies detected

### 🏁 Race Condition Analysis

✅ No obvious race conditions detected

### 🛡️ Security Analysis

🔓 **Shared Rate Limit:** src/ReplicatedStorage/OVHL/Core/OVHL.lua - Rate limiting in shared code

### 📈 Summary Statistics

#### 📊 Top 10 Largest Files

- `src/ReplicatedStorage/OVHL/Systems/Adapters/Permission/HDAdminAdapter.lua` (324 lines)
- `src/ReplicatedStorage/OVHL/Systems/Networking/RemoteBuilder.lua` (280 lines)
- `src/ReplicatedStorage/OVHL/Config/EngineConfig.lua` (261 lines)
- `src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/AssetLoader.lua` (192 lines)
- `src/ReplicatedStorage/OVHL/Core/SystemRegistry.lua` (192 lines)
- `src/ReplicatedStorage/OVHL/Systems/Security/SecurityHelper.lua` (174 lines)
- `src/ReplicatedStorage/OVHL/Systems/Networking/NetworkingRouter.lua` (174 lines)
- `src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/UIEngine.lua` (160 lines)
- `src/ReplicatedStorage/OVHL/Systems/Foundation/SmartLogger.lua` (155 lines)
- `src/ReplicatedStorage/OVHL/Core/OVHL.lua` (133 lines)

#### 📏 File Size Distribution

- **0-100 lines:** 44 files
- **101-500 lines:** 17 files
- **501-1000 lines:** 0 files
- **1001+ lines:** 0 files

## 📚 Complete Codebase

### 📦 src/

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Config/EngineConfig.lua</strong> (261 lines, 7K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Config/EngineConfig.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: EngineConfig (Module)
   4 | @Path: ReplicatedStorage.OVHL.Config.EngineConfig
   5 | @Purpose: Global engine configuration with adapter selectors and system settings
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | return {
  10 | 	-- ====================================================================
  11 | 	-- ENGINE CORE BEHAVIOR
  12 | 	-- ====================================================================
  13 | 	DebugMode = true,
  14 | 	EnableHotReload = false,
  15 | 	Version = "1.0.0",
  16 |
  17 | 	-- ====================================================================
  18 | 	-- ADAPTER SYSTEM (V1.0.1 - New)
  19 | 	-- ====================================================================
  20 | 	-- Selector untuk adapter implementations
  21 | 	-- Change values untuk switch antara adapter berbeda
  22 | 	Adapters = {
  23 | 		-- Permission adapter: "InternalAdapter" atau "HDAdminAdapter"
  24 | 		-- InternalAdapter: Built-in rank system (fallback)
  25 | 		-- HDAdminAdapter: Bridge ke HD Admin system
  26 | 		Permission = "HDAdminAdapter",
  27 |
  28 | 		-- Navbar adapter: "TopbarPlusAdapter" atau "InternalAdapter"
  29 | 		-- TopbarPlusAdapter: TopbarPlus V3 integration
  30 | 		-- InternalAdapter: Native Fusion UI navbar
  31 | 		Navbar = "TopbarPlusAdapter",
  32 | 	},
  33 |
  34 | 	-- ====================================================================
  35 | 	-- PERMISSION & SECURITY SYSTEM
  36 | 	-- ====================================================================
  37 | 	Security = {
  38 | 		-- Permission checking enabled
  39 | 		PermissionCheckEnabled = true,
  40 |
  41 | 		-- HD Admin integration settings
  42 | 		HDAdmin = {
  43 | 			Enabled = true,
  44 | 			AutoFallback = true, -- Fallback ke Internal jika HD Admin unavailable
  45 | 			CheckInterval = 30, -- Detik, check HD Admin availability
  46 | 		},
  47 |
  48 | 		-- Rate limiting configuration
  49 | 		RateLimiting = {
  50 | 			Enabled = true,
  51 | 			RequestsPerMinute = 100,
  52 | 			CheckInterval = 300, -- Cleanup old data setiap 5 menit
  53 | 		},
  54 |
  55 | 		-- Input validation
  56 | 		InputValidation = {
  57 | 			Enabled = true,
  58 | 			StrictMode = false, -- Jika true, reject data yang tidak match schema
  59 | 		},
  60 | 	},
  61 |
  62 | 	-- ====================================================================
  63 | 	-- UI & NAVBAR SETTINGS
  64 | 	-- ====================================================================
  65 | 	UI = {
  66 | 		-- Default UI rendering mode
  67 | 		DefaultMode = "Auto", -- "Auto" = detect (prefer Fusion), "Fusion", "Native"
  68 | 		EnableAnimations = true,
  69 | 		AnimationDuration = 0.3,
  70 |
  71 | 		-- TopbarPlus settings
  72 | 		Navbar = {
  73 | 			Enabled = true,
  74 | 			Position = "TopLeft", -- "TopLeft", "TopRight", "BottomLeft", "BottomRight"
  75 | 			ShowPerPermission = true, -- Hide button jika user tidak punya permission
  76 | 			SortByOrder = true, -- Sort buttons by Order field di config
  77 | 			MaxButtons = 20, -- Max buttons di navbar
  78 | 		},
  79 |
  80 | 		-- Screen settings
  81 | 		Screens = {
  82 | 			CloseButtonEnabled = true,
  83 | 			FadeOutOnClose = true,
  84 | 			BlockInputWhileAnimating = false,
  85 | 		},
  86 | 	},
  87 |
  88 | 	-- ====================================================================
  89 | 	-- PERFORMANCE SETTINGS
  90 | 	-- ====================================================================
  91 | 	Performance = {
  92 | 		ObjectPoolSize = 50,
  93 | 		MaxNetworkRetries = 3,
  94 | 		NetworkTimeout = 10,
  95 |
  96 | 		-- Data caching
  97 | 		DataCache = {
  98 | 			Enabled = true,
  99 | 			CacheDuration = 300, -- Detik
 100 | 		},
 101 |
 102 | 		-- Memory optimization
 103 | 		EnableMemoryOptimization = true,
 104 | 		GarbageCollectInterval = 600, -- Detik (10 menit)
 105 | 	},
 106 |
 107 | 	-- ====================================================================
 108 | 	-- LOGGING SETTINGS
 109 | 	-- ====================================================================
 110 | 	Logging = {
 111 | 		Model = "DEBUG", -- SILENT, NORMAL, DEBUG, VERBOSE
 112 | 		EnableFileLogging = false,
 113 | 		EnableColors = true,
 114 |
 115 | 		-- Per-domain level override
 116 | 		DomainLevels = {
 117 | 			BOOTSTRAP = "DEBUG",
 118 | 			SYSTEMREGISTRY = "DEBUG",
 119 | 			DATAMANAGER = "DEBUG",
 120 | 			PLAYERMANAGER = "DEBUG",
 121 | 			NETWORK = "DEBUG",
 122 | 			UI = "DEBUG",
 123 | 			PERMISSION = "DEBUG",
 124 | 			BUSINESS = "INFO",
 125 | 		},
 126 |
 127 | 		-- Console output settings
 128 | 		ShowTimestamp = true,
 129 | 		ShowDomain = true,
 130 | 		ShowMetadata = true,
 131 | 		MaxMetadataLength = 100, -- Truncate metadata jika > ini
 132 | 	},
 133 |
 134 | 	-- ====================================================================
 135 | 	-- NETWORK & COMMUNICATION
 136 | 	-- ====================================================================
 137 | 	Network = {
 138 | 		-- Remote events management
 139 | 		RemoteFolder = "OVHL_Remotes",
 140 | 		UseSecureConnection = true,
 141 |
 142 | 		-- Retry policy
 143 | 		RetryPolicy = {
 144 | 			MaxRetries = 3,
 145 | 			RetryDelay = 1,
 146 | 			ExponentialBackoff = true,
 147 | 		},
 148 |
 149 | 		-- Rate limiting per route
 150 | 		RouteRateLimits = {
 151 | 			ClientToServer = 100,
 152 | 			ServerToClient = 50,
 153 | 			RequestResponse = 30,
 154 | 		},
 155 | 	},
 156 |
 157 | 	-- ====================================================================
 158 | 	-- DATA PERSISTENCE
 159 | 	-- ====================================================================
 160 | 	DataStore = {
 161 | 		Enabled = true,
 162 | 		DefaultDataStoreName = "OVHL_PlayerDatav3",
 163 | 		AutoSave = true,
 164 | 		SaveInterval = 60, -- Detik (1 menit)
 165 | 		MaxRetries = 3,
 166 | 		Scope = "global",
 167 | 	},
 168 |
 169 | 	-- ====================================================================
 170 | 	-- BOOTSTRAP & KERNEL SETTINGS
 171 | 	-- ====================================================================
 172 | 	Bootstrap = {
 173 | 		AutoScanModules = true,
 174 | 		ScanInterval = 30,
 175 | 		EnvironmentAware = true, -- V3.2.3: Detect Server/Client context
 176 | 		ValidateManifests = true,
 177 | 		FallbackToLegacy = true, -- Support V3.1.0 systems tanpa manifest
 178 | 	},
 179 |
 180 | 	Kernel = {
 181 | 		AutoScanModules = true,
 182 | 		ScanInterval = 30,
 183 | 		HotReloadModules = false,
 184 | 		ScanDepth = 5, -- Max subfolder depth untuk scan
 185 | 	},
 186 |
 187 | 	-- ====================================================================
 188 | 	-- SYSTEM REGISTRY (4-PHASE LIFECYCLE)
 189 | 	-- ====================================================================
 190 | 	SystemRegistry = {
 191 | 		-- Enable fase 4 (Destroy/Shutdown)
 192 | 		EnableShutdownPhase = true,
 193 |
 194 | 		-- Timeout untuk setiap fase (detik)
 195 | 		InitializeTimeout = 30,
 196 | 		StartTimeout = 30,
 197 | 		DestroyTimeout = 10,
 198 |
 199 | 		-- Log detail level
 200 | 		LogPhaseTransitions = true,
 201 | 	},
 202 |
 203 | 	-- ====================================================================
 204 | 	-- FALLBACK & ERROR HANDLING
 205 | 	-- ====================================================================
 206 | 	Fallback = {
 207 | 		EnableFallbackSystems = true,
 208 | 		FallbackTimeout = 5,
 209 |
 210 | 		-- Fallback strategies
 211 | 		Strategies = {
 212 | 			Permission = "InternalAdapter", -- Fallback untuk permission
 213 | 			Navbar = "InternalAdapter", -- Fallback untuk navbar
 214 | 			Logger = "builtin", -- Fallback untuk logging
 215 | 		},
 216 | 	},
 217 |
 218 | 	-- ====================================================================
 219 | 	-- DEVELOPMENT & DEBUG
 220 | 	-- ====================================================================
 221 | 	Development = {
 222 | 		DebugMode = true,
 223 | 		VerboseLogging = false,
 224 | 		ShowSystemDependencies = false,
 225 | 		ShowBootSequence = true,
 226 | 		TestModeEnabled = false,
 227 |
 228 | 		-- Development shortcuts
 229 | 		SkipPermissionChecks = false, -- DANGER: Jangan pakai di production!
 230 | 		SkipRateLimiting = false, -- DANGER: Jangan pakai di production!
 231 | 	},
 232 |
 233 | 	-- ====================================================================
 234 | 	-- FEATURE FLAGS (untuk testing)
 235 | 	-- ====================================================================
 236 | 	FeatureFlags = {
 237 | 		EnableAdapterPattern = true, -- Use adapter pattern untuk Permission/Navbar
 238 | 		EnablePrototypeShop = false, -- Enable PrototypeShop test module
 239 | 		EnableTestMode = false, -- Enable test-specific behavior
 240 | 	},
 241 |
 242 | 	-- ====================================================================
 243 | 	-- PRODUCTION vs DEVELOPMENT
 244 | 	-- ====================================================================
 245 | 	-- Override berdasarkan environment
 246 | 	-- Buat copy config ini dengan Development = false untuk production
 247 |
 248 | 	-- Production settings (backup):
 249 | 	-- DebugMode = false,
 250 | 	-- Logging.Model = "NORMAL",
 251 | 	-- Development.DebugMode = false,
 252 | 	-- Development.VerboseLogging = false,
 253 | 	-- Fallback.EnableFallbackSystems = true,
 254 | }
 255 |
 256 | --[[
 257 | @End: EngineConfig.lua
 258 | @Version: 1.0.1 (Enhanced with Adapters)
 259 | @LastUpdate: 2025-11-18
 260 | @Maintainer: OVHL Core Team
 261 | --]]
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Config/LoggerConfig.lua</strong> (92 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Config/LoggerConfig.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: LoggerConfig (Module)
   4 | @Path: ReplicatedStorage.OVHL.Config.LoggerConfig
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | --[[
  10 | OVHL ENGINE V3.0.0 - LOGGER CONFIGURATION
  11 | Version: 1.0.1
  12 | Path: ReplicatedStorage.OVHL.Config.LoggerConfig
  13 | --]]
  14 |
  15 | return {
  16 |     -- MAIN MODEL SETTING
  17 |     Model = "DEBUG", -- SILENT, NORMAL, DEBUG, VERBOSE
  18 |
  19 |     -- MODEL-SPECIFIC SETTINGS
  20 |     Models = {
  21 |         SILENT = {
  22 |             Levels = { "CRITICAL" },
  23 |             PerformanceLogging = false,
  24 |             InternalLogging = false,
  25 |             EmojiEnabled = false,
  26 |         },
  27 |         NORMAL = {
  28 |             Levels = { "INFO", "WARN", "ERROR", "CRITICAL" },
  29 |             PerformanceLogging = false,
  30 |             InternalLogging = false,
  31 |             EmojiEnabled = true,
  32 |         },
  33 |         DEBUG = {
  34 |             Levels = { "DEBUG", "INFO", "WARN", "ERROR", "CRITICAL" },
  35 |             PerformanceLogging = false,
  36 |             InternalLogging = false,
  37 |             EmojiEnabled = true,
  38 |         },
  39 |         VERBOSE = {
  40 |             Levels = { "DEBUG", "INFO", "WARN", "ERROR", "CRITICAL" },
  41 |             PerformanceLogging = true,
  42 |             InternalLogging = true,
  43 |             EmojiEnabled = true,
  44 |             AdditionalDomains = { "PERFORMANCE", "INTERNAL", "MEMORY", "TIMING" },
  45 |         },
  46 |     },
  47 |
  48 |     -- EMOJI DOMAIN SYSTEM
  49 |     Domains = {
  50 |         -- Core Sections
  51 |         SERVER = { Emoji = "🚀", Color = Color3.fromRGB(255, 100, 100) },
  52 |         CLIENT = { Emoji = "🎮", Color = Color3.fromRGB(100, 150, 255) },
  53 |         DOMAIN = { Emoji = "🏗️", Color = Color3.fromRGB(100, 200, 100) },
  54 |         DATA = { Emoji = "📊", Color = Color3.fromRGB(200, 150, 50) },
  55 |
  56 |         -- Module-specific domains
  57 |         CONFIG = { Emoji = "⚙️", Color = Color3.fromRGB(150, 150, 150) },
  58 |         SERVICE = { Emoji = "🔧", Color = Color3.fromRGB(200, 120, 50) },
  59 |         CONTROLLER = { Emoji = "🎯", Color = Color3.fromRGB(50, 200, 150) },
  60 |         NETWORK = { Emoji = "🌐", Color = Color3.fromRGB(50, 150, 200) },
  61 |         UI = { Emoji = "📱", Color = Color3.fromRGB(100, 100, 200) },
  62 |         PERMISSION = { Emoji = "🔐", Color = Color3.fromRGB(200, 100, 200) },
  63 |         STATE = { Emoji = "💾", Color = Color3.fromRGB(100, 200, 200) },
  64 |         MODULE = { Emoji = "📦", Color = Color3.fromRGB(200, 200, 100) },
  65 |         PERFORMANCE = { Emoji = "⚡", Color = Color3.fromRGB(255, 200, 50) },
  66 |         DEBUG = { Emoji = "🐛", Color = Color3.fromRGB(150, 150, 150) },
  67 |     },
  68 |
  69 |     -- LEVEL EMOJI MAPPING
  70 |     LevelEmojis = {
  71 |         DEBUG = "🐛",
  72 |         INFO = "ℹ️",
  73 |         WARN = "⚠️",
  74 |         ERROR = "❌",
  75 |         CRITICAL = "💥",
  76 |     },
  77 |
  78 |     -- ENVIRONMENT OVERRIDES
  79 |     EnvironmentOverrides = {
  80 |         Development = "DEBUG",
  81 |         Testing = "NORMAL",
  82 |         Production = "SILENT",
  83 |     },
  84 | }
  85 |
  86 | --[[
  87 | @End: LoggerConfig.lua
  88 | @Version: 1.0.0
  89 | @LastUpdate: 2025-11-18
  90 | @Maintainer: OVHL Core Team
  91 | --]]
  92 |
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Bootstrap.lua</strong> (123 lines, 4K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Bootstrap.lua`

```lua
   1 | --[[
   2 | OVHL FRAMEWORK V.1.1.0
   3 | @Component: Bootstrap (Core Scanner)
   4 | @Path: ReplicatedStorage.OVHL.Core.Bootstrap
   5 | @Purpose: System Bootstrapper & Manifest Scanner (Physical Separation Support)
   6 | @Version: 1.1.0
   7 | --]]
   8 |
   9 | local Bootstrap = {}
  10 | Bootstrap.__index = Bootstrap
  11 |
  12 | -- [V1.1.0] DEFINISI LOKASI
  13 | local RS_SYSTEMS = script.Parent.Parent.Systems
  14 | local SS_SYSTEMS = nil
  15 | local CL_SYSTEMS = nil
  16 |
  17 | if game:GetService("RunService"):IsServer() then
  18 |     SS_SYSTEMS = game:GetService("ServerScriptService").OVHL.Systems
  19 | else
  20 |     -- Client Path: StarterPlayerScripts.OVHL.Systems
  21 |     local playerScripts = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts")
  22 |     CL_SYSTEMS = playerScripts:WaitForChild("OVHL"):WaitForChild("Systems")
  23 | end
  24 |
  25 | function Bootstrap:DetectEnvironment()
  26 |     return game:GetService("RunService"):IsServer() and "Server" or "Client"
  27 | end
  28 |
  29 | function Bootstrap:_ScanFolder(folder, logger, environment, results, manifestCache)
  30 |     if not folder then return end
  31 |
  32 |     -- Pass 1: Index Manifests
  33 |     for _, descendant in ipairs(folder:GetDescendants()) do
  34 |         if descendant:IsA("ModuleScript") and descendant.Name:match("Manifest$") then
  35 |             local systemName = descendant.Name:gsub("Manifest$", "")
  36 |             manifestCache[systemName] = descendant
  37 |         end
  38 |     end
  39 |
  40 |     -- Pass 2: Match Modules
  41 |     for _, descendant in ipairs(folder:GetDescendants()) do
  42 |         if descendant:IsA("ModuleScript") and not descendant.Name:match("Manifest$") then
  43 |             local systemName = descendant.Name
  44 |             local manifestModule = manifestCache[systemName]
  45 |
  46 |             -- Hanya proses jika ada manifest (Strict Mode V1.1.0)
  47 |             if manifestModule then
  48 |                 local success, manifestData = pcall(require, manifestModule)
  49 |                 if success then
  50 |                     if not manifestData.name or not manifestData.dependencies or not manifestData.context then
  51 |                         if logger then logger:Error("BOOTSTRAP", "Manifest Invalid", {file=manifestModule.Name}) end
  52 |                     else
  53 |                         -- [V1.1.0 Logic] Context Validation
  54 |                         -- Shared load di semua, Server di Server, Client di Client
  55 |                         local loadIt = false
  56 |                         if manifestData.context == "Shared" then loadIt = true end
  57 |                         if environment == "Server" and manifestData.context == "Server" then loadIt = true end
  58 |                         if environment == "Client" and manifestData.context == "Client" then loadIt = true end
  59 |
  60 |                         if loadIt then
  61 |                             manifestData.modulePath = descendant
  62 |                             table.insert(results.manifests, manifestData)
  63 |                         end
  64 |                     end
  65 |                 end
  66 |                 manifestCache[systemName] = nil -- Consume cache
  67 |             end
  68 |         end
  69 |     end
  70 | end
  71 |
  72 | function Bootstrap:Initialize()
  73 |     local environment = self:DetectEnvironment()
  74 |     local OVHL = require(script.Parent.OVHL)
  75 |
  76 |     -- 1. Load Logger (Manual - Shared Foundation)
  77 |     local logger
  78 |     local loggerPath = RS_SYSTEMS.Foundation:FindFirstChild("SmartLogger")
  79 |     if loggerPath then
  80 |         local success, result = pcall(function() return require(loggerPath).new() end)
  81 |         if success then logger = result end
  82 |     end
  83 |
  84 |     -- Register Logger
  85 |     if logger then OVHL.RegisterSystem("SmartLogger", logger) end
  86 |
  87 |     -- 2. SystemRegistry
  88 |     local SystemRegistry = require(script.Parent.SystemRegistry).new(OVHL, logger)
  89 |     OVHL.RegisterSystem("SystemRegistry", SystemRegistry)
  90 |
  91 |     if logger then logger:Info("BOOTSTRAP", "Initializing OVHL V.1.1.0 ("..environment..") - Architecture Split") end
  92 |
  93 |     local results = { manifests = {}, errors = {}, unmigrated = {} }
  94 |     local manifestCache = {}
  95 |
  96 |     -- 3. SCAN SHARED (ReplicatedStorage)
  97 |     self:_ScanFolder(RS_SYSTEMS, logger, environment, results, manifestCache)
  98 |
  99 |     -- 4. SCAN SERVER ONLY (ServerScriptService)
 100 |     if environment == "Server" and SS_SYSTEMS then
 101 |         self:_ScanFolder(SS_SYSTEMS, logger, environment, results, manifestCache)
 102 |     end
 103 |
 104 |     -- 5. SCAN CLIENT ONLY (StarterPlayerScripts)
 105 |     if environment == "Client" and CL_SYSTEMS then
 106 |         self:_ScanFolder(CL_SYSTEMS, logger, environment, results, manifestCache)
 107 |     end
 108 |
 109 |     -- 6. Register & Start
 110 |     local allManifests = {}
 111 |     for _, m in ipairs(results.manifests) do allManifests[m.name] = m end
 112 |
 113 |     local started, failed = SystemRegistry:RegisterAndStartFromManifests(allManifests)
 114 |
 115 |     if logger then
 116 |         logger:Info("BOOTSTRAP", "Boot Complete", {started=started, failed=failed})
 117 |     end
 118 |
 119 |     OVHL.MarkInitialized()
 120 |     return OVHL
 121 | end
 122 |
 123 | return Bootstrap
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/Kernel.lua</strong> (127 lines, 4K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/Kernel.lua`

```lua
   1 | --[[
   2 | OVHL FRAMEWORK V.1.0.1
   3 | @Component: Kernel (Core)
   4 | @Path: ReplicatedStorage.OVHL.Core.Kernel
   5 | @Purpose: Core Service/Controller Loader
   6 | @Version: 1.0.1
   7 | --]]
   8 |
   9 | local Kernel = {}
  10 | Kernel.__index = Kernel
  11 |
  12 | function Kernel.new()
  13 |     local self = setmetatable({}, Kernel)
  14 |     self._modules = {}
  15 |     self._services = {}
  16 |     self._controllers = {}
  17 |     self._environment = game:GetService("RunService"):IsServer() and "Server" or "Client"
  18 |     self._logger = nil
  19 |     return self
  20 | end
  21 |
  22 | function Kernel:Initialize(logger)
  23 |     self._logger = logger
  24 |     self._logger:Info("KERNEL", "Kernel V.1.0.1 Initialized")
  25 | end
  26 |
  27 | function Kernel:ScanModules()
  28 |     if not self._logger then error("Kernel not initialized") end
  29 |     local modulesFound = 0
  30 |     if self._environment == "Server" then
  31 |         modulesFound = self:_scanServerModules()
  32 |     else
  33 |         modulesFound = self:_scanClientModules()
  34 |     end
  35 |     self._logger:Info("KERNEL", "Modules Scanned", {count=modulesFound})
  36 |     return modulesFound
  37 | end
  38 |
  39 | function Kernel:_scanServerModules()
  40 |     local success, serverModules = pcall(function() return self:_scanDirectory(game:GetService("ServerScriptService"), "OVHL/Modules") end)
  41 |     if not success then return 0 end
  42 |     local loadedCount = 0
  43 |     for _, ms in ipairs(serverModules) do if self:_loadService(ms) then loadedCount = loadedCount + 1 end end
  44 |     return loadedCount
  45 | end
  46 |
  47 | function Kernel:_scanClientModules()
  48 |     local success, clientModules = pcall(function()
  49 |         local sp = game:GetService("StarterPlayer")
  50 |         local ps = sp:FindFirstChild("StarterPlayerScripts")
  51 |         return ps and self:_scanDirectory(ps, "OVHL/Modules") or {}
  52 |     end)
  53 |     if not success then return 0 end
  54 |     local loadedCount = 0
  55 |     for _, ms in ipairs(clientModules) do if self:_loadController(ms) then loadedCount = loadedCount + 1 end end
  56 |     return loadedCount
  57 | end
  58 |
  59 | function Kernel:_scanDirectory(rootFolder, relativePath)
  60 |     local modules = {}
  61 |     local targetFolder = rootFolder
  62 |     for part in string.gmatch(relativePath, "([^/]+)") do
  63 |         targetFolder = targetFolder:FindFirstChild(part)
  64 |         if not targetFolder then return modules end
  65 |     end
  66 |     local function scanRecursive(folder)
  67 |         for _, item in ipairs(folder:GetChildren()) do
  68 |             if item:IsA("ModuleScript") then
  69 |                 if string.match(item.Name, "Service$") then table.insert(modules, item)
  70 |                 elseif string.match(item.Name, "Controller$") then table.insert(modules, item) end
  71 |             elseif item:IsA("Folder") then scanRecursive(item) end
  72 |         end
  73 |     end
  74 |     if targetFolder then scanRecursive(targetFolder) end
  75 |     return modules
  76 | end
  77 |
  78 | function Kernel:_loadService(moduleScript)
  79 |     if self._environment ~= "Server" then return nil end
  80 |     local success, service = pcall(function() return require(moduleScript) end)
  81 |     if not success then return nil end
  82 |     if service and typeof(service) == "table" and service.Name then
  83 |         self._services[service.Name] = service
  84 |         return service
  85 |     end
  86 |     return nil
  87 | end
  88 |
  89 | function Kernel:_loadController(moduleScript)
  90 |     if self._environment ~= "Client" then return nil end
  91 |     local success, controller = pcall(function() return require(moduleScript) end)
  92 |     if not success then return nil end
  93 |     if controller and typeof(controller) == "table" and controller.Name then
  94 |         self._controllers[controller.Name] = controller
  95 |         return controller
  96 |     end
  97 |     return nil
  98 | end
  99 |
 100 | function Kernel:RegisterKnitServices(knit)
 101 |     local registeredCount = 0
 102 |     if not knit then self._logger:Critical("KERNEL", "Knit instance is nil") return 0 end
 103 |
 104 |     -- Server
 105 |     for serviceName, _ in pairs(self._services) do
 106 |         local success, registeredService = pcall(function() return knit.GetService(serviceName) end)
 107 |         if success and registeredService then
 108 |             registeredCount = registeredCount + 1
 109 |             self._services[serviceName] = registeredService
 110 |         else
 111 |             self._logger:Warn("KERNEL", "Knit Register Failed", {service=serviceName})
 112 |         end
 113 |     end
 114 |
 115 |     -- Client
 116 |     for controllerName, _ in pairs(self._controllers) do
 117 |         local success, registeredController = pcall(function() return knit.GetController(controllerName) end)
 118 |         if success and registeredController then
 119 |             registeredCount = registeredCount + 1
 120 |             self._controllers[controllerName] = registeredController
 121 |         end
 122 |     end
 123 |     return registeredCount
 124 | end
 125 |
 126 | function Kernel:RunVerification() self._logger:Info("KERNEL", "Verification Passed") end
 127 | return Kernel
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/OVHL.lua</strong> (133 lines, 4K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/OVHL.lua`

```lua
   1 | --[[
   2 | OVHL FRAMEWORK V.1.1.0
   3 | @Component: OVHL (Core API Gateway)
   4 | @Path: ReplicatedStorage.OVHL.Core.OVHL
   5 | @Purpose: Central API Gateway (Supports V1.1.0 Split Architecture)
   6 | @Version: 1.1.0
   7 | --]]
   8 |
   9 | local OVHL = {}
  10 | local RunService = game:GetService("RunService")
  11 |
  12 | local _systems = {}
  13 | local _modules = {}
  14 | local _initialized = false
  15 |
  16 | -- [V1.1.0] Helper: Get Search Paths
  17 | local function GetSearchFolders()
  18 |     local paths = {}
  19 |
  20 |     -- 1. Shared (Always)
  21 |     table.insert(paths, game:GetService("ReplicatedStorage").OVHL.Systems)
  22 |
  23 |     -- 2. Server Only
  24 |     if RunService:IsServer() then
  25 |         table.insert(paths, game:GetService("ServerScriptService").OVHL.Systems)
  26 |     end
  27 |
  28 |     -- 3. Client Only
  29 |     if RunService:IsClient() then
  30 |         local ps = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerScripts")
  31 |         if ps then
  32 |             local ovhl = ps:FindFirstChild("OVHL")
  33 |             if ovhl then table.insert(paths, ovhl:FindFirstChild("Systems")) end
  34 |         end
  35 |     end
  36 |
  37 |     return paths
  38 | end
  39 |
  40 | function OVHL.GetSystem(systemName)
  41 |     -- 1. Fast Path: Memory Cache
  42 |     if _systems[systemName] then return _systems[systemName] end
  43 |
  44 |     -- 2. Slow Path: Deep Search (Fallback if not registered yet)
  45 |     local success, system = pcall(function()
  46 |         local folders = GetSearchFolders()
  47 |
  48 |         for _, folder in ipairs(folders) do
  49 |             if folder then
  50 |                 for _, child in ipairs(folder:GetDescendants()) do
  51 |                     if child:IsA("ModuleScript") and child.Name == systemName then
  52 |                         return require(child)
  53 |                     end
  54 |                 end
  55 |             end
  56 |         end
  57 |         return nil
  58 |     end)
  59 |
  60 |     if success and system then
  61 |         return system
  62 |     end
  63 |     return nil
  64 | end
  65 |
  66 | function OVHL.GetService(serviceName)
  67 |     if not _initialized then return nil end
  68 |     local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
  69 |     local success, service = pcall(function() return Knit.GetService(serviceName) end)
  70 |     return success and service or nil
  71 | end
  72 |
  73 | function OVHL.GetController(controllerName)
  74 |     if not _initialized then return nil end
  75 |     local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
  76 |     local success, controller = pcall(function() return Knit.GetController(controllerName) end)
  77 |     return success and controller or nil
  78 | end
  79 |
  80 | function OVHL.GetModule(moduleName) return _modules[moduleName] end
  81 |
  82 | function OVHL.GetConfig(moduleName, key, context)
  83 |     local ConfigLoader = OVHL.GetSystem("ConfigLoader")
  84 |     if ConfigLoader then
  85 |         local config = ConfigLoader:ResolveConfig(moduleName, context or "Server")
  86 |         return key and config[key] or config
  87 |     end
  88 |     return nil
  89 | end
  90 |
  91 | function OVHL.GetClientConfig(moduleName, key)
  92 |     local ConfigLoader = OVHL.GetSystem("ConfigLoader")
  93 |     if ConfigLoader then
  94 |         local config = ConfigLoader:GetClientSafeConfig(moduleName)
  95 |         return key and config[key] or config
  96 |     end
  97 |     return nil
  98 | end
  99 |
 100 | function OVHL.ValidateInput(schemaName, data)
 101 |     local InputValidator = OVHL.GetSystem("InputValidator")
 102 |     if InputValidator then return InputValidator:Validate(schemaName, data) end
 103 |     return true, "InputValidator not available"
 104 | end
 105 |
 106 | function OVHL.CheckPermission(player, permissionNode)
 107 |     local PermissionCore = OVHL.GetSystem("PermissionCore")
 108 |     if PermissionCore then return PermissionCore:Check(player, permissionNode) end
 109 |     return true
 110 | end
 111 |
 112 | function OVHL.CheckRateLimit(player, action)
 113 |     local RateLimiter = OVHL.GetSystem("RateLimiter")
 114 |     if RateLimiter then return RateLimiter:Check(player, action) end
 115 |     return true
 116 | end
 117 |
 118 | function OVHL.RegisterSystem(name, instance) _systems[name] = instance end
 119 | function OVHL.RegisterModule(name, instance) _modules[name] = instance end
 120 | function OVHL.MarkInitialized() _initialized = true end
 121 | function OVHL.IsInitialized() return _initialized end
 122 |
 123 | function OVHL.GetSystemStatus(systemName)
 124 |     local SystemRegistry = OVHL.GetSystem("SystemRegistry")
 125 |     return SystemRegistry and SystemRegistry:GetSystemStatus(systemName) or "SYSTEMREGISTRY_NOT_AVAILABLE"
 126 | end
 127 |
 128 | function OVHL.GetSystemsHealth()
 129 |     local SystemRegistry = OVHL.GetSystem("SystemRegistry")
 130 |     return SystemRegistry and SystemRegistry:GetHealthStatus() or {}
 131 | end
 132 |
 133 | return OVHL
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Core/SystemRegistry.lua</strong> (192 lines, 7K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Core/SystemRegistry.lua`

```lua
   1 | --[[
   2 | OVHL FRAMEWORK V.1.0.1
   3 | @Component: SystemRegistry (Core Orchestrator)
   4 | @Path: ReplicatedStorage.OVHL.Core.SystemRegistry
   5 | @Purpose: Full Lifecycle Orchestrator
   6 | @Version: 1.0.1
   7 | --]]
   8 |
   9 | local SystemRegistry = {}
  10 | SystemRegistry.__index = SystemRegistry
  11 |
  12 | function SystemRegistry.new(ovhl, logger)
  13 |     local self = setmetatable({}, SystemRegistry)
  14 |     self._systems = {}
  15 |     self._manifests = {}
  16 |     self._loadOrder = {}
  17 |     self._status = {}
  18 |     self._ovhl = ovhl
  19 |     self._logger = logger
  20 |     -- [FIX VERSION]
  21 |     self._logger:Info("SYSTEMREGISTRY", "System Registry V.1.0.1 (4-Phase Lifecycle) initialized")
  22 |     return self
  23 | end
  24 |
  25 | function SystemRegistry:RegisterAndStartFromManifests(manifestsMap)
  26 |     self._manifests = manifestsMap
  27 |
  28 |     local success, result = pcall(function() return self:_ResolveLoadOrder() end)
  29 |     if not success then
  30 |         self._logger:Critical("SYSTEMREGISTRY", "FATAL BOOT ERROR: Circular Dependency!", { error = result })
  31 |         return 0, table.getn(self._manifests)
  32 |     end
  33 |     self._loadOrder = result
  34 |
  35 |     local initCount, initFailed = self:_RunInitializationPhase()
  36 |     if initFailed > 0 then
  37 |         self._logger:Critical("SYSTEMREGISTRY", "FATAL BOOT ERROR: Init Failed!", { failed = initFailed })
  38 |         return initCount, initFailed
  39 |     end
  40 |
  41 |     self:_RegisterWithOVHL()
  42 |     local startCount, startFailed = self:_RunStartPhase()
  43 |     return startCount, startFailed
  44 | end
  45 |
  46 | function SystemRegistry:Shutdown()
  47 |     self._logger:Info("SYSTEMREGISTRY", "Memulai Fase 4 (Destroy/Shutdown)...")
  48 |     local success, result = pcall(function() return self:_RunDestroyPhase() end)
  49 |     if not success then
  50 |         self._logger:Critical("SYSTEMREGISTRY", "FATAL SHUTDOWN ERROR!", { error = result })
  51 |     else
  52 |         self._logger:Info("SYSTEMREGISTRY", "Shutdown complete.", { systems = result })
  53 |     end
  54 | end
  55 |
  56 | function SystemRegistry:_ResolveLoadOrder()
  57 |     local visited = {}
  58 |     local tempMarked = {}
  59 |     local order = {}
  60 |     local function visit(systemName)
  61 |         if tempMarked[systemName] then error("Circular Dependency: " .. systemName, 2) end
  62 |         if not visited[systemName] then
  63 |             local manifest = self._manifests[systemName]
  64 |             if not manifest then error("Missing Dependency: " .. systemName, 2) end
  65 |             tempMarked[systemName] = true
  66 |             for _, depName in ipairs(manifest.dependencies or {}) do visit(depName) end
  67 |             tempMarked[systemName] = nil
  68 |             visited[systemName] = true
  69 |             table.insert(order, systemName)
  70 |         end
  71 |     end
  72 |     for systemName, _ in pairs(self._manifests) do visit(systemName) end
  73 |     return order
  74 | end
  75 |
  76 | function SystemRegistry:_RunInitializationPhase()
  77 |     local startedCount = 0
  78 |     local failedCount = 0
  79 |     self._logger:Info("SYSTEMREGISTRY", "Memulai Fase 1 (Initialize)...")
  80 |
  81 |     for _, systemName in ipairs(self._loadOrder) do
  82 |         local manifest = self._manifests[systemName]
  83 |         local success, moduleClass = pcall(require, manifest.modulePath)
  84 |         if not success then
  85 |             self._status[systemName] = "ERROR_LOAD"
  86 |             self._logger:Error("SYSREG", "Startup GAGAL", { system = systemName, error = "Require fail" })
  87 |             failedCount = failedCount + 1
  88 |             continue
  89 |         end
  90 |
  91 |         local success, systemInstance = pcall(moduleClass.new)
  92 |         if not success then
  93 |             self._status[systemName] = "ERROR_NEW"
  94 |             self._logger:Error("SYSREG", "Startup GAGAL", { system = systemName, error = "New fail" })
  95 |             failedCount = failedCount + 1
  96 |             continue
  97 |         end
  98 |
  99 |         if systemInstance.Initialize and type(systemInstance.Initialize) == "function" then
 100 |             local success, errorMsg = pcall(function() systemInstance:Initialize(self._logger) end)
 101 |             if not success then
 102 |                 self._status[systemName] = "ERROR_INIT"
 103 |                 self._logger:Error("SYSREG", "Startup GAGAL", { system = systemName, error = errorMsg })
 104 |                 failedCount = failedCount + 1
 105 |                 continue
 106 |             end
 107 |         end
 108 |
 109 |         self._status[systemName] = "INIT"
 110 |         self._systems[systemName] = systemInstance
 111 |         startedCount = startedCount + 1
 112 |     end
 113 |     return startedCount, failedCount
 114 | end
 115 |
 116 | function SystemRegistry:_RegisterWithOVHL()
 117 |     for systemName, systemInstance in pairs(self._systems) do
 118 |         if self._status[systemName] == "INIT" then
 119 |             -- [CRITICAL KEEP] Phase 5 Fix: Dot Notation
 120 |             self._ovhl.RegisterSystem(systemName, systemInstance)
 121 |         end
 122 |     end
 123 | end
 124 |
 125 | function SystemRegistry:_RunStartPhase()
 126 |     local startedCount = 0
 127 |     local failedCount = 0
 128 |     self._logger:Info("SYSTEMREGISTRY", "Memulai Fase 3 (Start)...")
 129 |
 130 |     for _, systemName in ipairs(self._loadOrder) do
 131 |         local systemInstance = self._systems[systemName]
 132 |         if self._status[systemName] == "INIT" then
 133 |             if systemInstance.Start and type(systemInstance.Start) == "function" then
 134 |                 local success, errorMsg = pcall(function() systemInstance:Start() end)
 135 |                 if not success then
 136 |                     self._status[systemName] = "ERROR_START"
 137 |                     self._logger:Error("SYSREG", "Startup GAGAL", { system = systemName, error = errorMsg })
 138 |                     failedCount = failedCount + 1
 139 |                 else
 140 |                     self._status[systemName] = "READY"
 141 |                     startedCount = startedCount + 1
 142 |                     self._logger:Debug("SYSTEMREGISTRY", "Started (Ready)", { system = systemName })
 143 |                 end
 144 |             else
 145 |                 self._status[systemName] = "READY"
 146 |                 startedCount = startedCount + 1
 147 |                 self._logger:Debug("SYSTEMREGISTRY", "Started (Pasif)", { system = systemName })
 148 |             end
 149 |         end
 150 |     end
 151 |     return startedCount, failedCount
 152 | end
 153 |
 154 | function SystemRegistry:_RunDestroyPhase()
 155 |     local destroyedCount = 0
 156 |     local failedCount = 0
 157 |     self._logger:Info("SYSTEMREGISTRY", "Memulai Fase 4 (Destroy)...")
 158 |
 159 |     for i = #self._loadOrder, 1, -1 do
 160 |         local systemName = self._loadOrder[i]
 161 |         local systemInstance = self._systems[systemName]
 162 |         if self._status[systemName] == "READY" then
 163 |             if systemInstance.Destroy and type(systemInstance.Destroy) == "function" then
 164 |                 local success, errorMsg = pcall(function() systemInstance:Destroy() end)
 165 |                 if not success then
 166 |                     self._status[systemName] = "ERROR_DESTROY"
 167 |                     self._logger:Error("SYSREG", "Shutdown GAGAL", { system = systemName, error = errorMsg })
 168 |                     failedCount = failedCount + 1
 169 |                 else
 170 |                     self._status[systemName] = "DESTROYED"
 171 |                     destroyedCount = destroyedCount + 1
 172 |                 end
 173 |             else
 174 |                 self._status[systemName] = "DESTROYED"
 175 |                 destroyedCount = destroyedCount + 1
 176 |             end
 177 |         end
 178 |     end
 179 |     return destroyedCount, failedCount
 180 | end
 181 |
 182 | function SystemRegistry:GetSystemStatus(systemName) return self._status[systemName] or "NOT_FOUND" end
 183 | function SystemRegistry:GetLoadOrder() return self._loadOrder end
 184 | function SystemRegistry:GetHealthStatus()
 185 |     local health = {}
 186 |     for systemName, manifest in pairs(self._manifests) do
 187 |         health[systemName] = { Status = self._status[systemName] or "REGISTERED", Dependencies = manifest.dependencies or {} }
 188 |     end
 189 |     return health
 190 | end
 191 |
 192 | return SystemRegistry
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Shared/Modules/Global/Constants.lua</strong> (57 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Shared/Modules/Global/Constants.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: Constants (Module)
   4 | @Path: ReplicatedStorage.OVHL.Shared.Modules.Global.Constants
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | --[[
  10 | OVHL ENGINE V3.0.0 - GLOBAL CONSTANTS
  11 | Version: 1.0.1
  12 | Path: ReplicatedStorage.OVHL.Shared.Modules.Global.Constants
  13 | --]]
  14 |
  15 | return {
  16 |     ENGINE = {
  17 |         VERSION = "3.0.0",
  18 |         NAME = "OVHL Engine",
  19 |         AUTHOR = "Omniverse Highland Studio"
  20 |     },
  21 |
  22 |     NETWORKING = {
  23 |         DEFAULT_TIMEOUT = 10,
  24 |         MAX_RETRIES = 3,
  25 |         RETRY_DELAY = 1
  26 |     },
  27 |
  28 |     UI = {
  29 |         DEFAULT_THEME = "Dark",
  30 |         Z_INDEX = {
  31 |             BACKGROUND = 0,
  32 |             CONTENT = 10,
  33 |             HEADER = 20,
  34 |             OVERLAY = 50,
  35 |             TOOLTIP = 100,
  36 |             NOTIFICATION = 1000
  37 |         }
  38 |     },
  39 |
  40 |     LOGGING = {
  41 |         DOMAINS = {
  42 |             SYSTEM = "SYSTEM",
  43 |             GAME = "GAME",
  44 |             NETWORK = "NETWORK",
  45 |             DATA = "DATA",
  46 |             UI = "UI"
  47 |         }
  48 |     }
  49 | }
  50 |
  51 | --[[
  52 | @End: Constants.lua
  53 | @Version: 1.0.0
  54 | @LastUpdate: 2025-11-18
  55 | @Maintainer: OVHL Core Team
  56 | --]]
  57 |
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Shared/Modules/MinimalModule/SharedConfig.lua</strong> (32 lines, 790B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Shared/Modules/MinimalModule/SharedConfig.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.0
   3 |     @Component: SharedConfig
   4 |     @Path: src/ReplicatedStorage/OVHL/Shared/Modules/MinimalModule/SharedConfig.lua
   5 |     @Purpose: Configuration Data for MinimalModule
   6 |     @Created: Wed, Nov 19, 2025 09:10:48
   7 | --]]
   8 |
   9 | return {
  10 |     Identity = { Name = "MinimalModule", Version = "2.0.0" },
  11 |
  12 |     -- UI Configuration
  13 |     UI = {
  14 |         Mode = "FUSION", -- Force Fusion Mode
  15 |     },
  16 |
  17 |     -- Topbar Configuration
  18 |     Topbar = {
  19 |         Enabled = true,
  20 |         Type = "Toggle",
  21 |         Text = "HELLO SOP",
  22 |         Icon = "rbxassetid://112605442047022",
  23 |         Order = 1,
  24 |         Permission = 0 -- Guest Access
  25 |     },
  26 |
  27 |     -- Security Configuration (Minimal)
  28 |     Security = {
  29 |         Schemas = {},
  30 |         RateLimit = { Action = { Max = 5, Window = 10 } }
  31 |     }
  32 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Shared/Modules/PrototypeShop/SharedConfig.lua</strong> (59 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Shared/Modules/PrototypeShop/SharedConfig.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.0
   3 |     @Component: SharedConfig
   4 |     @Path: src/ReplicatedStorage/OVHL/Shared/Modules/PrototypeShop/SharedConfig.lua
   5 |     @Purpose: Complex Config with Schemas & Fallbacks
   6 |     @Created: Wed, Nov 19, 2025 09:10:48
   7 | --]]
   8 |
   9 | return {
  10 |     Identity = { Name = "PrototypeShop", Version = "2.1.0" },
  11 |
  12 |     -- UI CONFIGURATION
  13 |     UI = {
  14 |         Mode = "AUTO", -- Controller akan coba Native dulu, baru Fallback
  15 |         TargetName = "ShopNativeScreen", -- Target untuk Scanner
  16 |
  17 |         -- Component Mapping (Config Driven No Hardcode)
  18 |         Components = {
  19 |             MainFrame = "MainFrame",
  20 |             Title     = "HeaderTitle",
  21 |             BuyButton = "Btn_BuySword",
  22 |             CloseButton = "Btn_Close"
  23 |         }
  24 |     },
  25 |
  26 |     -- TOPBAR CONFIGURATION
  27 |     Topbar = {
  28 |         Enabled = true,
  29 |         Type = "Toggle", -- Simple toggle for now
  30 |         Text = "SHOP COMPLEX",
  31 |         Icon = "rbxassetid://6031225837",
  32 |         Order = 5,
  33 |         Permission = 0 -- Accessible to everyone
  34 |     },
  35 |
  36 |     -- SECURITY CONFIGURATION
  37 |     Security = {
  38 |         -- Validation Schemas (InputValidator)
  39 |         Schemas = {
  40 |             BuyItem = {
  41 |                 type = "table",
  42 |                 fields = {
  43 |                     itemId = { type = "string" },
  44 |                     amount = { type = "number", min = 1, max = 99 }
  45 |                 }
  46 |             }
  47 |         },
  48 |         -- Rate Limiting
  49 |         RateLimits = {
  50 |             BuyItem = { max = 3, window = 10 } -- Anti Spam
  51 |         }
  52 |     },
  53 |
  54 |     -- SERVER PERMISSIONS
  55 |     Permissions = {
  56 |         BuyItem = 0, -- Guest can buy
  57 |         Restock = 3  -- Only Admin can restock (Future Proof)
  58 |     }
  59 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Adapters/Navbar/InternalAdapter.lua</strong> (108 lines, 3K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Adapters/Navbar/InternalAdapter.lua`

```lua
   1 | --[[
   2 | OVHL FRAMEWORK V.1.0.1
   3 | @Component: InternalAdapter (Navbar)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Adapters.Navbar.InternalAdapter
   5 | @Purpose: Native UI Navbar (High Visibility & IDEMPOTENT)
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | local InternalAdapter = {}
  10 | InternalAdapter.__index = InternalAdapter
  11 | local Players = game:GetService("Players")
  12 |
  13 | function InternalAdapter.new()
  14 |     local self = setmetatable({}, InternalAdapter)
  15 |     self._logger = nil
  16 |     self._gui = nil
  17 |     self._container = nil
  18 |     self._buttons = {} -- Cache registry
  19 |     return self
  20 | end
  21 |
  22 | function InternalAdapter:Initialize(logger)
  23 |     self._logger = logger
  24 | end
  25 |
  26 | function InternalAdapter:_ensureGui()
  27 |     local player = Players.LocalPlayer
  28 |     if not player then return end
  29 |     local pg = player:WaitForChild("PlayerGui")
  30 |
  31 |     if self._gui and self._gui.Parent then return end
  32 |
  33 |     -- Destroy old GUI if exists to prevent ghosts
  34 |     local old = pg:FindFirstChild("OVHL_Internal_Navbar")
  35 |     if old then old:Destroy() end
  36 |
  37 |     local sg = Instance.new("ScreenGui")
  38 |     sg.Name = "OVHL_Internal_Navbar"
  39 |     sg.IgnoreGuiInset = true
  40 |     sg.DisplayOrder = 999
  41 |     sg.Parent = pg
  42 |
  43 |     local fr = Instance.new("Frame", sg)
  44 |     fr.Name = "Bar"
  45 |     fr.Size = UDim2.new(1, 0, 0, 44)
  46 |     fr.Position = UDim2.new(0, 0, 0, 0)
  47 |     fr.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
  48 |     fr.BackgroundTransparency = 0.2
  49 |
  50 |     local list = Instance.new("UIListLayout", fr)
  51 |     list.FillDirection = Enum.FillDirection.Horizontal
  52 |     list.Padding = UDim.new(0, 4)
  53 |     list.HorizontalAlignment = Enum.HorizontalAlignment.Left
  54 |
  55 |     local pad = Instance.new("UIPadding", fr)
  56 |     pad.PaddingLeft = UDim.new(0, 100)
  57 |     pad.PaddingTop = UDim.new(0, 4)
  58 |
  59 |     self._gui = sg
  60 |     self._container = fr
  61 | end
  62 |
  63 | function InternalAdapter:AddButton(id, config)
  64 |     self:_ensureGui()
  65 |
  66 |     -- [CRITICAL FIX] CLEANUP OLD BUTTON IF EXISTS
  67 |     if self._buttons[id] then
  68 |         pcall(function() self._buttons[id]:Destroy() end)
  69 |         self._buttons[id] = nil
  70 |     end
  71 |
  72 |     local btn = Instance.new("TextButton")
  73 |     btn.Name = id
  74 |     -- TAMPILKAN ID JIKA TEXT SAMA (DEBUGGING VISUAL)
  75 |     btn.Text = config.Text or id
  76 |     btn.Size = UDim2.new(0, 120, 1, -8)
  77 |     btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
  78 |     btn.TextColor3 = Color3.new(1,1,1)
  79 |     btn.Parent = self._container
  80 |
  81 |     local uc = Instance.new("UICorner", btn); uc.CornerRadius = UDim.new(0,6)
  82 |
  83 |     btn.MouseButton1Click:Connect(function()
  84 |         print("🖱️ INTERNAL NAV CLICKED:", id) -- Debug Print
  85 |         if config.OnClick then
  86 |             local s, e = pcall(config.OnClick)
  87 |             if not s then warn("OnClick Error:", e) end
  88 |         else
  89 |             warn("No OnClick handler for", id)
  90 |         end
  91 |     end)
  92 |
  93 |     self._buttons[id] = btn
  94 |     return true
  95 | end
  96 |
  97 | function InternalAdapter:RemoveButton(id)
  98 |     if self._buttons[id] then
  99 |         self._buttons[id]:Destroy()
 100 |         self._buttons[id] = nil
 101 |     end
 102 |     return true
 103 | end
 104 |
 105 | function InternalAdapter:SetButtonActive(id, active) return true end
 106 |
 107 | return InternalAdapter
 108 | --[[ @End: InternalAdapter.lua ]]
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Adapters/Navbar/TopbarPlusAdapter.lua</strong> (77 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Adapters/Navbar/TopbarPlusAdapter.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.2
   3 |     @Component: TopbarPlusAdapter (Navbar)
   4 |     @Fixes: Sends exact state (Selected=true, Deselected=false)
   5 | --]]
   6 | local TopbarPlusAdapter = {}
   7 | TopbarPlusAdapter.__index = TopbarPlusAdapter
   8 |
   9 | function TopbarPlusAdapter.new()
  10 |     local self = setmetatable({}, TopbarPlusAdapter)
  11 |     self._logger = nil
  12 |     self._topbarplus = nil
  13 |     self._available = false
  14 |     self._buttons = {}
  15 |     self._globalHandler = nil
  16 |     self._initialized = false
  17 |     return self
  18 | end
  19 |
  20 | function TopbarPlusAdapter:Initialize(logger)
  21 |     self._logger = logger
  22 |     if self._initialized then return end
  23 |     self._initialized = true
  24 |     local success, result = pcall(function()
  25 |         local RS = game:GetService("ReplicatedStorage")
  26 |         local module = RS:FindFirstChild("Icon") or
  27 |                        (RS:FindFirstChild("Packages") and RS.Packages:FindFirstChild("Icon")) or
  28 |                        (RS:FindFirstChild("Packages") and RS.Packages:FindFirstChild("TopbarPlus"))
  29 |         if module then return require(module) end
  30 |         return nil
  31 |     end)
  32 |     if success and result then
  33 |         self._topbarplus = result
  34 |         self._available = true
  35 |         if result.IconController then pcall(function() result.IconController:clearIcons() end) end
  36 |         self._logger:Info("NAVBAR", "TopbarPlus Adapter V1.2.2 (State Sync)")
  37 |     else
  38 |         self._logger:Warn("NAVBAR", "TopbarPlus Not Found")
  39 |     end
  40 | end
  41 |
  42 | function TopbarPlusAdapter:SetClickHandler(handler)
  43 |     self._globalHandler = handler
  44 | end
  45 |
  46 | function TopbarPlusAdapter:AddButton(id, config)
  47 |     if not self._available then return false end
  48 |     if self._buttons[id] then pcall(function() self._buttons[id]:destroy() end) self._buttons[id] = nil end
  49 |
  50 |     local IconLib = self._topbarplus
  51 |     local icon = IconLib.new()
  52 |     icon:setName(id)
  53 |     icon:setLabel(config.Text or id)
  54 |     if config.Icon then icon:setImage(config.Icon) end
  55 |     if config.Order then icon:setOrder(config.Order) end
  56 |
  57 |     -- [CRITICAL] Handler menerima State eksplisit
  58 |     local function handleState(selectedIcon, isSelected)
  59 |         if selectedIcon ~= icon then return end -- Strict Check
  60 |         if self._globalHandler then
  61 |             self._globalHandler(id, isSelected) -- Kirim ID dan State
  62 |         end
  63 |     end
  64 |
  65 |     -- Bind dengan state hardcoded
  66 |     icon:bindEvent("selected", function(i) handleState(i, true) end)
  67 |     icon:bindEvent("deselected", function(i) handleState(i, false) end)
  68 |
  69 |     self._buttons[id] = icon
  70 |     return true
  71 | end
  72 |
  73 | function TopbarPlusAdapter:RemoveButton(id)
  74 |     if self._buttons[id] then pcall(function() self._buttons[id]:destroy() end) self._buttons[id] = nil end
  75 |     return true
  76 | end
  77 | return TopbarPlusAdapter
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Adapters/Permission/HDAdminAdapter.lua</strong> (324 lines, 8K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Adapters/Permission/HDAdminAdapter.lua`

```lua
   1 | --[[
   2 | 	OVHL FRAMEWORK V.1.1.2 - HD ADMIN ADAPTER (EVENT LISTENER APPROACH)
   3 | 	@Component: HDAdminAdapter (Permission)
   4 | 	@Purpose: Listen to HD Admin events instead of polling GetRank()
   5 | 	@Strategy:
   6 | 		1. Hook into HD Admin's internal rank change events
   7 | 		2. Listen to RemoteEvent signals
   8 | 		3. Parse player rank from event data
   9 | 		4. Cache and replicate to client
  10 |     @Credit: Solution provided by Claude AI
  11 | --]]
  12 |
  13 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
  14 | local ServerScriptService = game:GetService("ServerScriptService")
  15 | local RunService = game:GetService("RunService")
  16 | local Players = game:GetService("Players")
  17 |
  18 | local HDAdminAdapter = {}
  19 | HDAdminAdapter.__index = HDAdminAdapter
  20 |
  21 | local CONFIG = {
  22 | 	WAIT_FOR_API = 10,
  23 | 	EVENT_LISTEN_TIMEOUT = 15,
  24 | 	FALLBACK_CHECK_INTERVAL = 5,
  25 | }
  26 |
  27 | function HDAdminAdapter.new()
  28 | 	local self = setmetatable({}, HDAdminAdapter)
  29 | 	self._logger = nil
  30 | 	self._isServer = RunService:IsServer()
  31 | 	self._api = nil
  32 | 	self._folderDetected = false
  33 | 	self._playerCache = {}
  34 | 	self._eventConnections = {}
  35 | 	self._rankEventHooked = false
  36 | 	return self
  37 | end
  38 |
  39 | function HDAdminAdapter:Initialize(logger)
  40 | 	self._logger = logger
  41 |
  42 | 	-- [CLIENT]
  43 | 	if not self._isServer then
  44 | 		self._folderDetected = true
  45 | 		self._logger:Info("PERMISSION", "HDAdminAdapter (Client) Listening...")
  46 | 		local p = Players.LocalPlayer
  47 | 		if p then
  48 | 			p:GetAttributeChangedSignal("OVHL_Rank"):Connect(function()
  49 | 				logger:Info("PERMISSION", "[CLIENT] Rank Update Received", {rank = p:GetAttribute("OVHL_Rank")})
  50 | 			end)
  51 | 		end
  52 | 		return
  53 | 	end
  54 |
  55 | 	-- [SERVER]
  56 | 	local hdFolder = ServerScriptService:FindFirstChild("HD Admin")
  57 | 	if hdFolder then
  58 | 		self._folderDetected = true
  59 | 		self._logger:Info("PERMISSION", "HDAdminAdapter: Folder Detected. Initializing Event Listeners...")
  60 | 		task.spawn(function() self:_connectAPI() end)
  61 | 		task.spawn(function() self:_setupEventListeners() end)
  62 | 	else
  63 | 		self._folderDetected = false
  64 | 		self._logger:Warn("PERMISSION", "HDAdminAdapter: Folder NOT FOUND. Using Internal fallback.")
  65 | 	end
  66 | end
  67 |
  68 | function HDAdminAdapter:IsAvailable()
  69 | 	return self._folderDetected
  70 | end
  71 |
  72 | function HDAdminAdapter:_connectAPI()
  73 | 	if self._api then return self._api end
  74 |
  75 | 	local setup = ReplicatedStorage:WaitForChild("HDAdminSetup", 3)
  76 | 	if setup then
  77 | 		pcall(function() require(setup):GetMain() end)
  78 | 	end
  79 |
  80 | 	local startTime = os.clock()
  81 | 	local maxWait = CONFIG.WAIT_FOR_API
  82 |
  83 | 	while (os.clock() - startTime) < maxWait do
  84 | 		if _G.HDAdminMain then
  85 | 			self._api = _G.HDAdminMain
  86 | 			self._logger:Info("PERMISSION", "[OK] HDAdminAdapter: API Connected.")
  87 | 			self:_refreshAllRanks()
  88 | 			return self._api
  89 | 		end
  90 | 		task.wait(0.5)
  91 | 	end
  92 |
  93 | 	self._logger:Warn("PERMISSION", "[TIMEOUT] HD Admin API not ready after " .. maxWait .. "s")
  94 | 	return nil
  95 | end
  96 |
  97 | -- [NEW] Setup event listeners on HD Admin internals
  98 | function HDAdminAdapter:_setupEventListeners()
  99 | 	-- Wait for API to actually connect (not just exist)
 100 | 	local waitStart = os.clock()
 101 | 	while not self._api and (os.clock() - waitStart) < CONFIG.WAIT_FOR_API do
 102 | 		task.wait(0.5)
 103 | 		self:_connectAPI()
 104 | 	end
 105 |
 106 | 	if not self._api then
 107 | 		self._logger:Warn("PERMISSION", "[SETUP] API still not ready, will retry on first GetRank call")
 108 | 		return
 109 | 	end
 110 |
 111 | 	self._logger:Info("PERMISSION", "[SETUP] Scanning for HD Admin RemoteEvents...")
 112 |
 113 | 	-- Strategy 1: Hook rank change events via RemoteEvent
 114 | 	self:_hookRemoteEvents()
 115 |
 116 | 	-- Strategy 2: Listen to player-added in HD Admin
 117 | 	self:_hookPlayerEvents()
 118 |
 119 | 	self._logger:Info("PERMISSION", "[SETUP] Event listeners registered")
 120 | end
 121 |
 122 | -- Listen to RemoteEvents in HD Admin folder
 123 | function HDAdminAdapter:_hookRemoteEvents()
 124 | 	local hdFolder = ServerScriptService:FindFirstChild("HD Admin")
 125 | 	if not hdFolder then return end
 126 |
 127 | 	-- Scan for RemoteEvents that might fire on rank changes
 128 | 	local function scanForRemotes(folder, depth)
 129 | 		if depth > 5 then return end
 130 |
 131 | 		for _, item in ipairs(folder:GetDescendants()) do
 132 | 			if item:IsA("RemoteEvent") then
 133 | 				-- Common HD Admin event names
 134 | 				if string.match(item.Name, "[Rr]ank") or
 135 | 				   string.match(item.Name, "[Pp]erm") or
 136 | 				   string.match(item.Name, "[Aa]dmin") then
 137 |
 138 | 					self._logger:Debug("PERMISSION", "[HOOK] Found RemoteEvent: " .. item.Name)
 139 |
 140 | 					-- Hook OnServerEvent to listen for rank data
 141 | 					local conn = item.OnServerEvent:Connect(function(player, ...)
 142 | 						self:_onRemoteEventFired(player, item.Name, ...)
 143 | 					end)
 144 |
 145 | 					table.insert(self._eventConnections, conn)
 146 | 				end
 147 | 			end
 148 | 		end
 149 | 	end
 150 |
 151 | 	pcall(function() scanForRemotes(hdFolder, 0) end)
 152 | end
 153 |
 154 | -- Listen when players join for HD Admin to assign them ranks
 155 | function HDAdminAdapter:_hookPlayerEvents()
 156 | 	local conn = Players.PlayerAdded:Connect(function(player)
 157 | 		-- Wait for HD Admin to process this player
 158 | 		task.spawn(function()
 159 | 			task.wait(2)  -- Give HD Admin time to load player data
 160 |
 161 | 			-- Try to grab rank now
 162 | 			local rank = self:GetRank(player)
 163 | 			if rank > 0 then
 164 | 				self._logger:Info("PERMISSION", "[HOOK] Player rank captured on join", {
 165 | 					player = player.Name,
 166 | 					rank = rank
 167 | 				})
 168 | 			end
 169 | 		end)
 170 | 	end)
 171 |
 172 | 	table.insert(self._eventConnections, conn)
 173 | end
 174 |
 175 | -- Handle RemoteEvent fires - extract rank data if present
 176 | function HDAdminAdapter:_onRemoteEventFired(player, eventName, ...)
 177 | 	local args = {...}
 178 |
 179 | 	-- Try to find rank data in arguments
 180 | 	for i, arg in ipairs(args) do
 181 | 		if type(arg) == "number" and arg >= 0 and arg <= 255 then
 182 | 			-- Likely a rank number
 183 | 			self._logger:Debug("PERMISSION", "[EVENT] Rank signal detected", {
 184 | 				player = player.Name,
 185 | 				event = eventName,
 186 | 				rank = arg
 187 | 			})
 188 |
 189 | 			self._playerCache[player.UserId] = { rank = arg, time = os.time() }
 190 | 			player:SetAttribute("OVHL_Rank", arg)
 191 | 			return
 192 | 		end
 193 | 	end
 194 | end
 195 |
 196 | function HDAdminAdapter:_refreshAllRanks()
 197 | 	if not self._isServer then return end
 198 | 	for _, p in ipairs(Players:GetPlayers()) do
 199 | 		task.spawn(function()
 200 | 			local rank = self:GetRank(p)
 201 | 			p:SetAttribute("OVHL_Rank", rank)
 202 | 		end)
 203 | 	end
 204 | end
 205 |
 206 | -- [HYBRID] Try GetRank, but with smarter fallback
 207 | function HDAdminAdapter:GetRank(player)
 208 | 	if not self._isServer then
 209 | 		return player:GetAttribute("OVHL_Rank") or 0
 210 | 	end
 211 |
 212 | 	-- Check local cache first
 213 | 	local cacheKey = player.UserId
 214 | 	if self._playerCache[cacheKey] and (os.time() - self._playerCache[cacheKey].time) < 60 then
 215 | 		return self._playerCache[cacheKey].rank
 216 | 	end
 217 |
 218 | 	local api = self:_connectAPI()
 219 | 	if not api then
 220 | 		return self:_getOwnerFallback(player)
 221 | 	end
 222 |
 223 | 	local finalRank = 0
 224 |
 225 | 	-- [ATTEMPT 1] Try cf:GetRank directly
 226 | 	local success, result = pcall(function()
 227 | 		if api.GetModule then
 228 | 			local cf = api:GetModule("cf")
 229 | 			if cf and cf.GetRank then
 230 | 				local r = cf:GetRank(player)
 231 | 				if type(r) == "number" and r > 0 then return r end
 232 | 				if type(r) == "table" and r.Id and r.Id > 0 then return r.Id end
 233 | 			end
 234 | 		end
 235 | 		return 0
 236 | 	end)
 237 |
 238 | 	if success and type(result) == "number" and result > 0 then
 239 | 		finalRank = result
 240 | 		self._logger:Info("PERMISSION", "[OK] Rank from cf:GetRank", {
 241 | 			player = player.Name,
 242 | 			rank = finalRank
 243 | 		})
 244 | 	end
 245 |
 246 | 	-- [ATTEMPT 2] Try legacy API
 247 | 	if finalRank == 0 then
 248 | 		success, result = pcall(function()
 249 | 			if api.GetPlayerRank then
 250 | 				return api:GetPlayerRank(player)
 251 | 			elseif api.GetRank then
 252 | 				return api:GetRank(player)
 253 | 			end
 254 | 			return 0
 255 | 		end)
 256 |
 257 | 		if success and type(result) == "number" and result > 0 then
 258 | 			finalRank = result
 259 | 			self._logger:Info("PERMISSION", "[OK] Rank from legacy API", {
 260 | 				player = player.Name,
 261 | 				rank = finalRank
 262 | 			})
 263 | 		end
 264 | 	end
 265 |
 266 | 	-- [ATTEMPT 3] Check if in cache from RemoteEvent listener
 267 | 	if finalRank == 0 and self._playerCache[cacheKey] then
 268 | 		finalRank = self._playerCache[cacheKey].rank
 269 | 		self._logger:Info("PERMISSION", "[OK] Rank from event cache", {
 270 | 			player = player.Name,
 271 | 			rank = finalRank
 272 | 		})
 273 | 	end
 274 |
 275 | 	-- [LAST RESORT] Owner check only
 276 | 	if finalRank == 0 then
 277 | 		finalRank = self:_getOwnerFallback(player)
 278 | 		if finalRank > 0 then
 279 | 			self._logger:Warn("PERMISSION", "[FALLBACK] Using owner check", {
 280 | 				player = player.Name
 281 | 			})
 282 | 		else
 283 | 			self._logger:Debug("PERMISSION", "[NONE] No rank found - player is regular user", {
 284 | 				player = player.Name
 285 | 			})
 286 | 		end
 287 | 	end
 288 |
 289 | 	-- Cache result
 290 | 	self._playerCache[cacheKey] = { rank = finalRank, time = os.time() }
 291 | 	player:SetAttribute("OVHL_Rank", finalRank)
 292 |
 293 | 	return finalRank
 294 | end
 295 |
 296 | function HDAdminAdapter:_getOwnerFallback(player)
 297 | 	if game.CreatorType == Enum.CreatorType.User and player.UserId == game.CreatorId then
 298 | 		return 5
 299 | 	end
 300 |
 301 | 	if RunService:IsStudio() and player.UserId == game.CreatorId then
 302 | 		return 5
 303 | 	end
 304 |
 305 | 	return 0
 306 | end
 307 |
 308 | function HDAdminAdapter:CheckPermission(player, permissionNode)
 309 | 	return true
 310 | end
 311 |
 312 | function HDAdminAdapter:SetRank(player, rank)
 313 | 	return false
 314 | end
 315 |
 316 | function HDAdminAdapter:Destroy()
 317 | 	for _, conn in ipairs(self._eventConnections) do
 318 | 		pcall(function() conn:Disconnect() end)
 319 | 	end
 320 | 	self._eventConnections = {}
 321 | 	self._logger:Info("PERMISSION", "[OK] HDAdminAdapter destroyed")
 322 | end
 323 |
 324 | return HDAdminAdapter
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Adapters/Permission/InternalAdapter.lua</strong> (121 lines, 3K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Adapters/Permission/InternalAdapter.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: InternalAdapter (Permission)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Adapters.Permission.InternalAdapter
   5 | @Purpose: Internal permission service (fallback when HD Admin unavailable)
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | local InternalAdapter = {}
  10 | InternalAdapter.__index = InternalAdapter
  11 |
  12 | -- Rank system (HD Admin compatible)
  13 | local RANKS = {
  14 |     Owner = 5,
  15 |     SuperAdmin = 4,
  16 |     Admin = 3,
  17 |     Mod = 2,
  18 |     VIP = 1,
  19 |     NonAdmin = 0
  20 | }
  21 |
  22 | function InternalAdapter.new()
  23 |     local self = setmetatable({}, InternalAdapter)
  24 |     self._logger = nil
  25 |     self._playerRanks = {}  -- {userId = rank}
  26 |     return self
  27 | end
  28 |
  29 | function InternalAdapter:Initialize(logger)
  30 |     self._logger = logger
  31 |     self._logger:Info("PERMISSION", "InternalAdapter initialized (fallback)")
  32 | end
  33 |
  34 | function InternalAdapter:GetRank(player)
  35 |     if not player then return RANKS.NonAdmin end
  36 |
  37 |     local userId = player.UserId
  38 |
  39 |     -- Check if player is creator (Owner rank)
  40 |     if userId == game.CreatorId then
  41 |         return RANKS.Owner
  42 |     end
  43 |
  44 |     -- Check stored rank
  45 |     if self._playerRanks[userId] then
  46 |         return self._playerRanks[userId]
  47 |     end
  48 |
  49 |     -- Default to NonAdmin
  50 |     return RANKS.NonAdmin
  51 | end
  52 |
  53 | function InternalAdapter:SetRank(player, rank)
  54 |     if not player then return false end
  55 |
  56 |     local rankValue = rank
  57 |     if type(rank) == "string" then
  58 |         rankValue = RANKS[rank] or RANKS.NonAdmin
  59 |     end
  60 |
  61 |     self._playerRanks[player.UserId] = rankValue
  62 |     self._logger:Debug("PERMISSION", "Set rank", {
  63 |         player = player.Name,
  64 |         rank = rankValue
  65 |     })
  66 |     return true
  67 | end
  68 |
  69 | function InternalAdapter:CheckPermission(player, permissionNode)
  70 |     if not player or not permissionNode then
  71 |         return false, "Invalid parameters"
  72 |     end
  73 |
  74 |     local playerRank = self:GetRank(player)
  75 |
  76 |     -- Parse permission node: "ModuleName.ActionName"
  77 |     local module, action = string.match(permissionNode, "^(%w+)%.(.+)$")
  78 |     if not module or not action then
  79 |         return false, "Invalid permission node format"
  80 |     end
  81 |
  82 |     -- Get required rank from config
  83 |     local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
  84 |     local config = OVHL.GetConfig(module, nil, "Server")
  85 |
  86 |     if not config or not config.Permissions then
  87 |         -- No permission config, allow by default
  88 |         return true
  89 |     end
  90 |
  91 |     local rule = config.Permissions[action]
  92 |     if not rule then
  93 |         -- No specific permission, allow by default
  94 |         return true
  95 |     end
  96 |
  97 |     -- Check rank requirement
  98 |     local requiredRank = rule.Rank or RANKS.NonAdmin
  99 |     if type(requiredRank) == "string" then
 100 |         requiredRank = RANKS[requiredRank] or RANKS.NonAdmin
 101 |     end
 102 |
 103 |     if playerRank >= requiredRank then
 104 |         return true
 105 |     end
 106 |
 107 |     return false, string.format("Rank too low (Need: %d, Have: %d)", requiredRank, playerRank)
 108 | end
 109 |
 110 | function InternalAdapter:GetAllRanks()
 111 |     return RANKS
 112 | end
 113 |
 114 | return InternalAdapter
 115 |
 116 | --[[
 117 | @End: InternalAdapter.lua
 118 | @Version: 1.0.0
 119 | @LastUpdate: 2025-11-18
 120 | @Maintainer: OVHL Core Team
 121 | --]]
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Foundation/ConfigLoader.lua</strong> (73 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Foundation/ConfigLoader.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.0
   3 |     @Component: ConfigLoader (Foundation)
   4 |     @Path: ReplicatedStorage.OVHL.Systems.Foundation.ConfigLoader
   5 |     @Purpose: Secure Deep Merging of Configurations (Anti-Poisoning)
   6 |     @State: Refactor V1.2.0 (Deep Merge Fix)
   7 | --]]
   8 |
   9 | local ConfigLoader = {}
  10 | ConfigLoader.__index = ConfigLoader
  11 |
  12 | function ConfigLoader.new()
  13 |     local self = setmetatable({}, ConfigLoader)
  14 |     self._logger = nil
  15 |     return self
  16 | end
  17 |
  18 | function ConfigLoader:Initialize(logger)
  19 |     self._logger = logger
  20 |     self._logger:Info("CONFIG", "ConfigLoader Ready V1.2.0 (Deep Merge Fixed)")
  21 | end
  22 |
  23 | -- [CRITICAL FIX] Deep Copy Logic
  24 | function ConfigLoader:MergeDeep(target, source)
  25 |     for key, value in pairs(source) do
  26 |         if type(value) == "table" then
  27 |             if type(target[key]) ~= "table" then
  28 |                 target[key] = {}
  29 |             end
  30 |             self:MergeDeep(target[key], value)
  31 |         else
  32 |             target[key] = value
  33 |         end
  34 |     end
  35 | end
  36 |
  37 | function ConfigLoader:ResolveConfig(moduleName, context)
  38 |     local finalConfig = {}
  39 |     local RS = game:GetService("ReplicatedStorage")
  40 |     local SSS = game:GetService("ServerScriptService")
  41 |     local SPS = game:GetService("StarterPlayer").StarterPlayerScripts
  42 |
  43 |     local success, engineCfg = pcall(require, RS.OVHL.Config.EngineConfig)
  44 |     if success then self:MergeDeep(finalConfig, engineCfg) end
  45 |
  46 |     local sPath = RS.OVHL.Shared.Modules:FindFirstChild(moduleName)
  47 |     if sPath and sPath:FindFirstChild("SharedConfig") then
  48 |         local succ, sCfg = pcall(require, sPath.SharedConfig)
  49 |         if succ then self:MergeDeep(finalConfig, sCfg) end
  50 |     end
  51 |
  52 |     if context == "Server" then
  53 |         local srvPath = SSS.OVHL.Modules:FindFirstChild(moduleName)
  54 |         if srvPath and srvPath:FindFirstChild("ServerConfig") then
  55 |             local succ, srvCfg = pcall(require, srvPath.ServerConfig)
  56 |             if succ then self:MergeDeep(finalConfig, srvCfg) end
  57 |         end
  58 |     elseif context == "Client" then
  59 |         local clPath = SPS.OVHL.Modules:FindFirstChild(moduleName)
  60 |         if clPath and clPath:FindFirstChild("ClientConfig") then
  61 |             local succ, clCfg = pcall(require, clPath.ClientConfig)
  62 |             if succ then self:MergeDeep(finalConfig, clCfg) end
  63 |         end
  64 |     end
  65 |
  66 |     return finalConfig
  67 | end
  68 |
  69 | function ConfigLoader:GetClientSafeConfig(moduleName)
  70 |     return self:ResolveConfig(moduleName, "Client")
  71 | end
  72 |
  73 | return ConfigLoader
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Foundation/ConfigLoaderManifest.lua</strong> (22 lines, 430B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Foundation/ConfigLoaderManifest.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: ConfigLoaderManifest (Foundation)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Foundation.ConfigLoaderManifest
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | -- V3.2.3 (HOTFIX): Menambahkan context
  10 | return {
  11 |     name = "ConfigLoader",
  12 |     dependencies = {},
  13 |     context = "Shared"
  14 | }
  15 |
  16 | --[[
  17 | @End: ConfigLoaderManifest.lua
  18 | @Version: 1.0.0
  19 | @LastUpdate: 2025-11-18
  20 | @Maintainer: OVHL Core Team
  21 | --]]
  22 |
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Foundation/SmartLogger.lua</strong> (155 lines, 3K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Foundation/SmartLogger.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: SmartLogger (Foundation)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Foundation.SmartLogger
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | --[[
  10 | OVHL ENGINE V3.0.0 - SMART LOGGER SYSTEM
  11 | Version: 1.0.1
  12 | Path: ReplicatedStorage.OVHL.Systems.Foundation.SmartLogger
  13 |
  14 | FEATURES:
  15 | - 4 Model System: SILENT, NORMAL, DEBUG, VERBOSE
  16 | - Emoji-based domains dengan color coding
  17 | - Structured metadata logging
  18 | - Performance-aware (zero overhead in production)
  19 | --]]
  20 |
  21 | local SmartLogger = {}
  22 | SmartLogger.__index = SmartLogger
  23 |
  24 | -- Private state
  25 | local _currentModel = "DEBUG"
  26 | local _formatter = nil
  27 | local _initialized = false
  28 |
  29 | function SmartLogger.new()
  30 |     local self = setmetatable({}, SmartLogger)
  31 |     self:_initialize()
  32 |     return self
  33 | end
  34 |
  35 | function SmartLogger:_initialize()
  36 |     -- Load config and formatter FIRST without self-calls
  37 |     local config = self:_loadConfig()
  38 |     _currentModel = config.Model or "DEBUG"
  39 |     _formatter = self:_loadFormatter()
  40 |
  41 |     -- Mark as initialized but don't log yet (avoid circular dependency)
  42 |     _initialized = true
  43 |
  44 |     -- Use direct print for initialization message
  45 |     print("🐛 LOGGER - SmartLogger initialized {model=" .. _currentModel .. "}")
  46 | end
  47 |
  48 | function SmartLogger:_loadConfig()
  49 |     local success, config = pcall(function()
  50 |         return require(script.Parent.Parent.Parent.Config.LoggerConfig)
  51 |     end)
  52 |     return success and config or {}
  53 | end
  54 |
  55 | function SmartLogger:_loadFormatter()
  56 |     local success, formatter = pcall(function()
  57 |         return require(script.Parent.Parent.Parent.Systems.Foundation.StudioFormatter)
  58 |     end)
  59 |     return success and formatter.new() or nil
  60 | end
  61 |
  62 | function SmartLogger:_shouldLog(level)
  63 |     if not _initialized then return false end
  64 |
  65 |     local config = self:_loadConfig()
  66 |     local modelConfig = config.Models[_currentModel] or config.Models.DEBUG
  67 |
  68 |     for _, allowedLevel in ipairs(modelConfig.Levels or {}) do
  69 |         if allowedLevel == level then
  70 |             return true
  71 |         end
  72 |     end
  73 |     return false
  74 | end
  75 |
  76 | function SmartLogger:_output(level, domain, message, metadata)
  77 |     if not self:_shouldLog(level) then
  78 |         return
  79 |     end
  80 |
  81 |     local formattedMessage, color = "[FORMATTER_ERROR] " .. message, Color3.new(1, 0, 0)
  82 |
  83 |     if _formatter then
  84 |         formattedMessage, color = _formatter:FormatMessage(level, domain, message, metadata)
  85 |     end
  86 |
  87 |     -- Output dengan color coding
  88 |     if level == "ERROR" or level == "CRITICAL" then
  89 |         warn(formattedMessage)
  90 |     else
  91 |         print(formattedMessage)
  92 |     end
  93 | end
  94 |
  95 | -- PUBLIC API
  96 | function SmartLogger:SetModel(modelName)
  97 |     local config = self:_loadConfig()
  98 |     if config.Models[modelName] then
  99 |         _currentModel = modelName
 100 |         self:Info("LOGGER", "Logger model changed", {model = modelName})
 101 |         return true
 102 |     end
 103 |     return false
 104 | end
 105 |
 106 | function SmartLogger:GetModel()
 107 |     return _currentModel
 108 | end
 109 |
 110 | function SmartLogger:IsModel(modelName)
 111 |     return _currentModel == modelName
 112 | end
 113 |
 114 | function SmartLogger:Initialize(logger)
 115 |     -- For SystemRegistry compatibility
 116 |     self:_initialize()
 117 | end
 118 |
 119 | -- LOGGING METHODS
 120 | function SmartLogger:Debug(domain, message, metadata)
 121 |     self:_output("DEBUG", domain, message, metadata)
 122 | end
 123 |
 124 | function SmartLogger:Info(domain, message, metadata)
 125 |     self:_output("INFO", domain, message, metadata)
 126 | end
 127 |
 128 | function SmartLogger:Warn(domain, message, metadata)
 129 |     self:_output("WARN", domain, message, metadata)
 130 | end
 131 |
 132 | function SmartLogger:Error(domain, message, metadata)
 133 |     self:_output("ERROR", domain, message, metadata)
 134 | end
 135 |
 136 | function SmartLogger:Critical(domain, message, metadata)
 137 |     self:_output("CRITICAL", domain, message, metadata)
 138 | end
 139 |
 140 | -- PERFORMANCE LOGGING (Verbose only)
 141 | function SmartLogger:Performance(domain, message, metadata)
 142 |     if _currentModel == "VERBOSE" then
 143 |         self:_output("DEBUG", "PERFORMANCE", message, metadata)
 144 |     end
 145 | end
 146 |
 147 | return SmartLogger
 148 |
 149 | --[[
 150 | @End: SmartLogger.lua
 151 | @Version: 1.0.0
 152 | @LastUpdate: 2025-11-18
 153 | @Maintainer: OVHL Core Team
 154 | --]]
 155 |
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Foundation/SmartLoggerManifest.lua</strong> (22 lines, 440B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Foundation/SmartLoggerManifest.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: SmartLoggerManifest (Foundation)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Foundation.SmartLoggerManifest
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | -- V3.2.3 (HOTFIX): Menambahkan context
  10 | return {
  11 |     name = "SmartLogger",
  12 |     dependencies = {"ConfigLoader"},
  13 |     context = "Shared"
  14 | }
  15 |
  16 | --[[
  17 | @End: SmartLoggerManifest.lua
  18 | @Version: 1.0.0
  19 | @LastUpdate: 2025-11-18
  20 | @Maintainer: OVHL Core Team
  21 | --]]
  22 |
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Foundation/StudioFormatter.lua</strong> (80 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Foundation/StudioFormatter.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: StudioFormatter (Foundation)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Foundation.StudioFormatter
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | --[[
  10 | OVHL ENGINE V3.0.0 - STUDIO OUTPUT FORMATTER
  11 | Version: 1.0.1
  12 | Path: ReplicatedStorage.OVHL.Systems.Foundation.StudioFormatter
  13 | --]]
  14 |
  15 | local StudioFormatter = {}
  16 | StudioFormatter.__index = StudioFormatter
  17 |
  18 | function StudioFormatter.new()
  19 |     local self = setmetatable({}, StudioFormatter)
  20 |     return self
  21 | end
  22 |
  23 | function StudioFormatter:FormatMessage(level, domain, message, metadata)
  24 |     local loggerConfig = self:GetLoggerConfig()
  25 |     local levelEmoji = loggerConfig.LevelEmojis[level] or "📝"
  26 |     local domainConfig = loggerConfig.Domains[domain] or {Emoji = "📄", Color = Color3.fromRGB(200, 200, 200)}
  27 |
  28 |     -- Format: [EMOJI] [DOMAIN] - Message {metadata}
  29 |     local formattedMessage = string.format(
  30 |         "%s %s - %s",
  31 |         levelEmoji,
  32 |         domain,
  33 |         tostring(message)
  34 |     )
  35 |
  36 |     -- Add metadata if present
  37 |     if metadata and next(metadata) then
  38 |         local metadataStr = ""
  39 |         for k, v in pairs(metadata) do
  40 |             metadataStr = metadataStr .. string.format(" %s=%s", k, tostring(v))
  41 |         end
  42 |         formattedMessage = formattedMessage .. " {" .. metadataStr:sub(2) .. "}"
  43 |     end
  44 |
  45 |     return formattedMessage, domainConfig.Color
  46 | end
  47 |
  48 | function StudioFormatter:GetLoggerConfig()
  49 |     -- Load logger config dengan safe require
  50 |     local success, config = pcall(function()
  51 |         return require(script.Parent.Parent.Parent.Config.LoggerConfig)
  52 |     end)
  53 |
  54 |     if success then
  55 |         return config
  56 |     else
  57 |         -- Fallback config
  58 |         return {
  59 |             LevelEmojis = {
  60 |                 DEBUG = "🐛", INFO = "ℹ️", WARN = "⚠️", ERROR = "❌", CRITICAL = "💥"
  61 |             },
  62 |             Domains = {
  63 |                 SERVER = { Emoji = "🚀", Color = Color3.fromRGB(255, 100, 100) },
  64 |                 CLIENT = { Emoji = "🎮", Color = Color3.fromRGB(100, 150, 255) },
  65 |                 DOMAIN = { Emoji = "🏗️", Color = Color3.fromRGB(100, 200, 100) },
  66 |                 DATA = { Emoji = "📊", Color = Color3.fromRGB(200, 150, 50) }
  67 |             }
  68 |         }
  69 |     end
  70 | end
  71 |
  72 | return StudioFormatter
  73 |
  74 | --[[
  75 | @End: StudioFormatter.lua
  76 | @Version: 1.0.0
  77 | @LastUpdate: 2025-11-18
  78 | @Maintainer: OVHL Core Team
  79 | --]]
  80 |
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Networking/NetworkingRouter.lua</strong> (174 lines, 5K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Networking/NetworkingRouter.lua`

```lua
   1 | --[[
   2 | 	OVHL FRAMEWORK V.1.1.1 - NETWORKING ROUTER
   3 | 	@Component: NetworkingRouter (Core System)
   4 | 	@Path: ReplicatedStorage.OVHL.Systems.Networking.NetworkingRouter
   5 | 	@Purpose: Networking with Middleware Support & Broadcast Capability
   6 | 	@Fixes: Implemented SendToAllClients properly.
   7 | --]]
   8 |
   9 | local Players = game:GetService("Players")
  10 | local NetworkingRouter = {}
  11 | NetworkingRouter.__index = NetworkingRouter
  12 |
  13 | function NetworkingRouter.new()
  14 | 	local self = setmetatable({}, NetworkingRouter)
  15 | 	self._logger = nil
  16 | 	self._remotes = {}
  17 | 	self._handlers = {}
  18 | 	self._middlewares = {}
  19 | 	return self
  20 | end
  21 |
  22 | function NetworkingRouter:Initialize(logger)
  23 | 	self._logger = logger
  24 | end
  25 |
  26 | function NetworkingRouter:Start()
  27 | 	self:_setupRemotes()
  28 | 	self._logger:Info("NETWORKING", "Networking Router Ready (Broadcast Enabled).")
  29 | end
  30 |
  31 | function NetworkingRouter:AddMiddleware(middleware)
  32 | 	table.insert(self._middlewares, middleware)
  33 | 	self._logger:Debug("NETWORKING", "Middleware registered", {name = middleware.name})
  34 | end
  35 |
  36 | function NetworkingRouter:_setupRemotes()
  37 | 	local ReplicatedStorage = game:GetService("ReplicatedStorage")
  38 | 	local RunService = game:GetService("RunService")
  39 | 	local isServer = RunService:IsServer()
  40 |
  41 | 	local remotesFolder = ReplicatedStorage:FindFirstChild("OVHL_Remotes")
  42 | 	if not remotesFolder and isServer then
  43 | 		remotesFolder = Instance.new("Folder")
  44 | 		remotesFolder.Name = "OVHL_Remotes"
  45 | 		remotesFolder.Parent = ReplicatedStorage
  46 | 	elseif not remotesFolder then
  47 | 		remotesFolder = ReplicatedStorage:WaitForChild("OVHL_Remotes", 10)
  48 | 	end
  49 |
  50 | 	if not remotesFolder then
  51 | 		self._logger:Error("NETWORKING", "Gagal menemukan folder OVHL_Remotes!")
  52 | 		return
  53 | 	end
  54 |
  55 | 	if isServer then
  56 | 		self._remotes = {
  57 | 			ClientToServer = self:_getOrCreateRemote(remotesFolder, "RemoteEvent", "OVHL_ClientToServer"),
  58 | 			ServerToClient = self:_getOrCreateRemote(remotesFolder, "RemoteEvent", "OVHL_ServerToClient"),
  59 | 			RequestResponse = self:_getOrCreateRemote(remotesFolder, "RemoteFunction", "OVHL_RequestResponse")
  60 | 		}
  61 |
  62 | 		self._remotes.ClientToServer.OnServerEvent:Connect(function(player, route, data)
  63 | 			self:_handleClientToServer(player, route, data)
  64 | 		end)
  65 |
  66 | 		self._remotes.RequestResponse.OnServerInvoke = function(player, route, data)
  67 | 			return self:_handleRequestResponse(player, route, data)
  68 | 		end
  69 | 	else
  70 | 		-- Client Side
  71 | 		self._remotes = {
  72 | 			ClientToServer = remotesFolder:WaitForChild("OVHL_ClientToServer"),
  73 | 			ServerToClient = remotesFolder:WaitForChild("OVHL_ServerToClient"),
  74 | 			RequestResponse = remotesFolder:WaitForChild("OVHL_RequestResponse")
  75 | 		}
  76 |
  77 | 		self._remotes.ServerToClient.OnClientEvent:Connect(function(route, data)
  78 | 			self:_handleServerToClient(route, data)
  79 | 		end)
  80 | 	end
  81 | end
  82 |
  83 | function NetworkingRouter:_getOrCreateRemote(folder, className, name)
  84 | 	local remote = folder:FindFirstChild(name)
  85 | 	if not remote then
  86 | 		remote = Instance.new(className)
  87 | 		remote.Name = name
  88 | 		remote.Parent = folder
  89 | 	end
  90 | 	return remote
  91 | end
  92 |
  93 | function NetworkingRouter:_runMiddlewares(type, player, route, data)
  94 | 	for _, mw in ipairs(self._middlewares) do
  95 | 		if type == "Receive" and mw.onReceive then
  96 | 			if not mw.onReceive(player, route, data) then return false end
  97 | 		elseif type == "Request" and mw.onRequest then
  98 | 			if not mw.onRequest(player, route, data) then return false end
  99 | 		end
 100 | 	end
 101 | 	return true
 102 | end
 103 |
 104 | function NetworkingRouter:_handleClientToServer(player, route, data)
 105 | 	if not self:_runMiddlewares("Receive", player, route, data) then
 106 | 		self._logger:Warn("NETWORKING", "Request blocked by middleware", {player=player.Name, route=route})
 107 | 		return
 108 | 	end
 109 | 	local handler = self._handlers[route]
 110 | 	if handler then
 111 | 		local success, err = pcall(handler, player, data)
 112 | 		if not success then self._logger:Error("NETWORKING", "Handler Error", {route=route, error=err}) end
 113 | 	else
 114 | 		self._logger:Debug("NETWORKING", "No handler found", {route=route})
 115 | 	end
 116 | end
 117 |
 118 | function NetworkingRouter:_handleRequestResponse(player, route, data)
 119 | 	if not self:_runMiddlewares("Request", player, route, data) then
 120 | 		return {success=false, error="Blocked by middleware"}
 121 | 	end
 122 | 	local handler = self._handlers[route]
 123 | 	if handler then
 124 | 		local success, res = pcall(handler, player, data)
 125 | 		return success and {success=true, data=res} or {success=false, error=res}
 126 | 	end
 127 | 	return {success=false, error="No handler"}
 128 | end
 129 |
 130 | function NetworkingRouter:_handleServerToClient(route, data)
 131 | 	local handler = self._handlers[route]
 132 | 	if handler then pcall(handler, data) end
 133 | end
 134 |
 135 | function NetworkingRouter:RegisterHandler(route, handler)
 136 | 	self._handlers[route] = handler
 137 | end
 138 |
 139 | function NetworkingRouter:SendToServer(route, data)
 140 | 	if not self._remotes.ClientToServer then return end
 141 | 	self._remotes.ClientToServer:FireServer(route, data)
 142 | end
 143 |
 144 | function NetworkingRouter:SendToClient(player, route, data)
 145 | 	if not self._remotes.ServerToClient then return end
 146 | 	self._remotes.ServerToClient:FireClient(player, route, data)
 147 | end
 148 |
 149 | function NetworkingRouter:SendToAllClients(route, data)
 150 | 	if not self._remotes.ServerToClient then return end
 151 |
 152 | 	-- [FIX PRIORITY 3] IMPLEMENTASI BROADCAST
 153 | 	-- Roblox tidak punya FireAllClients bawaan untuk RemoteEvent di beberapa konteks,
 154 | 	-- tapi biasanya ada. Untuk aman, kita pakai FireAllClients.
 155 | 	-- Jika error, fallback ke looping.
 156 |
 157 | 	local success = pcall(function()
 158 | 		self._remotes.ServerToClient:FireAllClients(route, data)
 159 | 	end)
 160 |
 161 | 	if not success then
 162 | 		-- Fallback manual loop
 163 | 		for _, player in ipairs(Players:GetPlayers()) do
 164 | 			self._remotes.ServerToClient:FireClient(player, route, data)
 165 | 		end
 166 | 	end
 167 | end
 168 |
 169 | function NetworkingRouter:RequestServer(route, data)
 170 |     if not self._remotes.RequestResponse then return {success=false} end
 171 |     return self._remotes.RequestResponse:InvokeServer(route, data)
 172 | end
 173 |
 174 | return NetworkingRouter
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Networking/NetworkingRouterManifest.lua</strong> (22 lines, 459B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Networking/NetworkingRouterManifest.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: NetworkingRouterManifest (Networking)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Networking.NetworkingRouterManifest
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | -- V3.2.3 (HOTFIX): Menambahkan context
  10 | return {
  11 |     name = "NetworkingRouter",
  12 |     dependencies = {"SmartLogger"},
  13 |     context = "Shared"
  14 | }
  15 |
  16 | --[[
  17 | @End: NetworkingRouterManifest.lua
  18 | @Version: 1.0.0
  19 | @LastUpdate: 2025-11-18
  20 | @Maintainer: OVHL Core Team
  21 | --]]
  22 |
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Networking/NetworkSecurity.lua</strong> (107 lines, 3K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Networking/NetworkSecurity.lua`

```lua
   1 | --[[
   2 | OVHL FRAMEWORK V.1.0.1
   3 | @Component: NetworkSecurity (Security)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Networking.NetworkSecurity
   5 | @Purpose: Security Middleware (Auto-Integrated)
   6 | --]]
   7 |
   8 | local NetworkSecurity = {}
   9 | NetworkSecurity.__index = NetworkSecurity
  10 |
  11 | function NetworkSecurity.new()
  12 |     local self = setmetatable({}, NetworkSecurity)
  13 |     self._logger = nil
  14 |     self._ovhl = nil
  15 |     self._routeConfigs = {}
  16 |     return self
  17 | end
  18 |
  19 | -- [PHASE 4 FIX] Removed 'ovhl' param, fetch it internally to prevent nil error
  20 | function NetworkSecurity:Initialize(logger)
  21 |     self._logger = logger
  22 |     self._ovhl = require(script.Parent.Parent.Parent.Core.OVHL)
  23 |     self._logger:Info("NETWORKSECURITY", "Network Security initialized")
  24 | end
  25 |
  26 | -- [PHASE 4 FIX] Auto-register to Router on Start
  27 | function NetworkSecurity:Start()
  28 |     local router = self._ovhl.GetSystem("NetworkingRouter")
  29 |     if router and router.AddMiddleware then
  30 |         router:AddMiddleware(self:CreateMiddleware())
  31 |         self._logger:Info("NETWORKSECURITY", "Security Middleware attached to Router")
  32 |     else
  33 |         self._logger:Warn("NETWORKSECURITY", "Failed to attach to NetworkingRouter")
  34 |     end
  35 | end
  36 |
  37 | function NetworkSecurity:CreateMiddleware()
  38 |     return {
  39 |         name = "NetworkSecurity",
  40 |
  41 |         onReceive = function(player, route, data)
  42 |             return self:_onReceive(player, route, data)
  43 |         end,
  44 |
  45 |         onRequest = function(player, route, data)
  46 |             return self:_onRequest(player, route, data)
  47 |         end
  48 |     }
  49 | end
  50 |
  51 | function NetworkSecurity:_onReceive(player, route, data)
  52 |     local config = self._routeConfigs[route]
  53 |     if not config then
  54 |         return true -- No security config, allow
  55 |     end
  56 |
  57 |     -- Input Validation
  58 |     if config.validationSchema then
  59 |         local valid, error = self._ovhl.ValidateInput(config.validationSchema, data)
  60 |         if not valid then
  61 |             self._logger:Warn("NETWORKSECURITY", "Input validation failed", {
  62 |                 player = player.Name,
  63 |                 route = route,
  64 |                 error = error
  65 |             })
  66 |             return false
  67 |         end
  68 |     end
  69 |
  70 |     -- Rate Limiting
  71 |     if config.rateLimit then
  72 |         local allowed = self._ovhl:CheckRateLimit(player, config.rateLimit.action or route)
  73 |         if not allowed then
  74 |             self._logger:Warn("NETWORKSECURITY", "Rate limit exceeded", {
  75 |                 player = player.Name,
  76 |                 route = route
  77 |             })
  78 |             return false
  79 |         end
  80 |     end
  81 |
  82 |     -- Permission Check
  83 |     if config.permission then
  84 |         local hasPermission, error = self._ovhl:CheckPermission(player, config.permission)
  85 |         if not hasPermission then
  86 |             self._logger:Warn("NETWORKSECURITY", "Permission denied", {
  87 |                 player = player.Name,
  88 |                 route = route,
  89 |                 permission = config.permission
  90 |             })
  91 |             return false
  92 |         end
  93 |     end
  94 |
  95 |     return true
  96 | end
  97 |
  98 | function NetworkSecurity:_onRequest(player, route, data)
  99 |     return self:_onReceive(player, route, data)
 100 | end
 101 |
 102 | function NetworkSecurity:ConfigureRoute(route, config)
 103 |     self._routeConfigs[route] = config
 104 |     return true
 105 | end
 106 |
 107 | return NetworkSecurity
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Networking/RemoteBuilder.lua</strong> (280 lines, 7K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Networking/RemoteBuilder.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: RemoteBuilder (Networking)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Networking.RemoteBuilder
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | --[[
  10 | OVHL ENGINE V3.0.0 - REMOTE BUILDER SYSTEM
  11 | Version: 1.0.1
  12 | Path: ReplicatedStorage.OVHL.Systems.Networking.RemoteBuilder
  13 |
  14 | FEATURES:
  15 | - Type-safe remote communication
  16 | - Automatic validation schemas
  17 | - Request batching untuk performance
  18 | - Connection pooling
  19 | --]]
  20 |
  21 | local RemoteBuilder = {}
  22 | RemoteBuilder.__index = RemoteBuilder
  23 |
  24 | function RemoteBuilder.new()
  25 |     local self = setmetatable({}, RemoteBuilder)
  26 |     self._logger = nil
  27 |     self._router = nil
  28 |     self._endpoints = {}
  29 |     self._batchQueue = {}
  30 |     self._batchInterval = 0.1 -- 100ms batching window
  31 |     self._isBatching = false
  32 |     return self
  33 | end
  34 |
  35 | function RemoteBuilder:Initialize(logger, router)
  36 |     self._logger = logger
  37 |     self._router = router
  38 |     self._logger:Info("REMOTEBUILDER", "Remote Builder initialized")
  39 | end
  40 |
  41 | function RemoteBuilder:CreateEndpoint(name, config)
  42 |     config = config or {}
  43 |
  44 |     if self._endpoints[name] then
  45 |         self._logger:Warn("REMOTEBUILDER", "Endpoint already exists", { endpoint = name })
  46 |         return self._endpoints[name]
  47 |     end
  48 |
  49 |     local endpoint = {
  50 |         name = name,
  51 |         route = config.route or name,
  52 |         validationSchema = config.validationSchema,
  53 |         rateLimit = config.rateLimit,
  54 |         permission = config.permission,
  55 |         type = config.type or "Event" -- Event, Request, Response
  56 |     }
  57 |
  58 |     self._endpoints[name] = endpoint
  59 |
  60 |     -- Register with router jika ada handler
  61 |     if config.handler then
  62 |         self._router:RegisterHandler(endpoint.route, config.handler, {
  63 |             type = endpoint.type
  64 |         })
  65 |     end
  66 |
  67 |     self._logger:Debug("REMOTEBUILDER", "Endpoint created", {
  68 |         endpoint = name,
  69 |         route = endpoint.route,
  70 |         type = endpoint.type
  71 |     })
  72 |
  73 |     return endpoint
  74 | end
  75 |
  76 | function RemoteBuilder:CreateEvent(name, config)
  77 |     config = config or {}
  78 |     config.type = "Event"
  79 |     return self:CreateEndpoint(name, config)
  80 | end
  81 |
  82 | function RemoteBuilder:CreateRequest(name, config)
  83 |     config = config or {}
  84 |     config.type = "Request"
  85 |     return self:CreateEndpoint(name, config)
  86 | end
  87 |
  88 | function RemoteBuilder:SendEvent(endpointName, data, target)
  89 |     local endpoint = self._endpoints[endpointName]
  90 |     if not endpoint then
  91 |         self._logger:Error("REMOTEBUILDER", "Unknown endpoint", { endpoint = endpointName })
  92 |         return false
  93 |     end
  94 |
  95 |     -- Validation
  96 |     if endpoint.validationSchema then
  97 |         local valid, error = self:_validateData(data, endpoint.validationSchema)
  98 |         if not valid then
  99 |             self._logger:Error("REMOTEBUILDER", "Event validation failed", {
 100 |                 endpoint = endpointName,
 101 |                 error = error
 102 |             })
 103 |             return false
 104 |         end
 105 |     end
 106 |
 107 |     -- Send based on environment and target
 108 |     if game:GetService("RunService"):IsServer() then
 109 |         if target then
 110 |             return self._router:SendToClient(target, endpoint.route, data)
 111 |         else
 112 |             return self._router:SendToAllClients(endpoint.route, data)
 113 |         end
 114 |     else
 115 |         return self._router:SendToServer(endpoint.route, data)
 116 |     end
 117 | end
 118 |
 119 | function RemoteBuilder:SendRequest(endpointName, data)
 120 |     local endpoint = self._endpoints[endpointName]
 121 |     if not endpoint then
 122 |         self._logger:Error("REMOTEBUILDER", "Unknown endpoint", { endpoint = endpointName })
 123 |         return { success = false, error = "Unknown endpoint: " .. endpointName }
 124 |     end
 125 |
 126 |     -- Validation
 127 |     if endpoint.validationSchema then
 128 |         local valid, error = self:_validateData(data, endpoint.validationSchema)
 129 |         if not valid then
 130 |             self._logger:Error("REMOTEBUILDER", "Request validation failed", {
 131 |                 endpoint = endpointName,
 132 |                 error = error
 133 |             })
 134 |             return { success = false, error = "Validation failed: " .. error }
 135 |         end
 136 |     end
 137 |
 138 |     if game:GetService("RunService"):IsServer() then
 139 |         return { success = false, error = "Cannot send request from server to server" }
 140 |     else
 141 |         return self._router:RequestServer(endpoint.route, data)
 142 |     end
 143 | end
 144 |
 145 | function RemoteBuilder:QueueEvent(endpointName, data)
 146 |     if not self._batchQueue[endpointName] then
 147 |         self._batchQueue[endpointName] = {}
 148 |     end
 149 |
 150 |     table.insert(self._batchQueue[endpointName], data)
 151 |
 152 |     if not self._isBatching then
 153 |         self:_startBatching()
 154 |     end
 155 |
 156 |     return true
 157 | end
 158 |
 159 | function RemoteBuilder:_startBatching()
 160 |     if self._isBatching then
 161 |         return
 162 |     end
 163 |
 164 |     self._isBatching = true
 165 |
 166 |     task.spawn(function()
 167 |         task.wait(self._batchInterval)
 168 |         self:_processBatchQueue()
 169 |         self._isBatching = false
 170 |     end)
 171 | end
 172 |
 173 | function RemoteBuilder:_processBatchQueue()
 174 |     for endpointName, dataList in pairs(self._batchQueue) do
 175 |         if #dataList > 0 then
 176 |             local batchData = {
 177 |                 _batch = true,
 178 |                 count = #dataList,
 179 |                 items = dataList
 180 |             }
 181 |
 182 |             self:SendEvent(endpointName, batchData)
 183 |             self._batchQueue[endpointName] = {}
 184 |
 185 |             self._logger:Debug("REMOTEBUILDER", "Batch processed", {
 186 |                 endpoint = endpointName,
 187 |                 count = #dataList
 188 |             })
 189 |         end
 190 |     end
 191 | end
 192 |
 193 | function RemoteBuilder:_validateData(data, schema)
 194 |     -- Simple validation - bisa di-extend dengan InputValidator
 195 |     if schema.type and typeof(data) ~= schema.type then
 196 |         return false, "Expected type " .. schema.type .. ", got " .. typeof(data)
 197 |     end
 198 |
 199 |     if schema.fields and typeof(data) == "table" then
 200 |         for fieldName, fieldSchema in pairs(schema.fields) do
 201 |             local fieldValue = data[fieldName]
 202 |
 203 |             if not fieldSchema.optional and fieldValue == nil then
 204 |                 return false, "Missing required field: " .. fieldName
 205 |             end
 206 |
 207 |             if fieldValue ~= nil and fieldSchema.type and typeof(fieldValue) ~= fieldSchema.type then
 208 |                 return false, "Field " .. fieldName .. ": expected " .. fieldSchema.type .. ", got " .. typeof(fieldValue)
 209 |             end
 210 |         end
 211 |     end
 212 |
 213 |     return true
 214 | end
 215 |
 216 | function RemoteBuilder:CreateModuleAPI(moduleName, endpoints)
 217 |     local api = {
 218 |         _module = moduleName,
 219 |         _endpoints = {}
 220 |     }
 221 |
 222 |     for endpointName, config in pairs(endpoints) do
 223 |         local fullEndpointName = moduleName .. "." .. endpointName
 224 |         local endpoint = self:CreateEndpoint(fullEndpointName, config)
 225 |
 226 |         -- Add to API
 227 |         api[endpointName] = function(data, target)
 228 |             if config.type == "Request" then
 229 |                 return self:SendRequest(fullEndpointName, data)
 230 |             else
 231 |                 return self:SendEvent(fullEndpointName, data, target)
 232 |             end
 233 |         end
 234 |
 235 |         api._endpoints[endpointName] = endpoint
 236 |     end
 237 |
 238 |     self._logger:Info("REMOTEBUILDER", "Module API created", {
 239 |         module = moduleName,
 240 |         endpoints = table.size(endpoints)
 241 |     })
 242 |
 243 |     return api
 244 | end
 245 |
 246 | function RemoteBuilder:GetEndpoint(name)
 247 |     return self._endpoints[name]
 248 | end
 249 |
 250 | function RemoteBuilder:GetAllEndpoints()
 251 |     return self._endpoints
 252 | end
 253 |
 254 | function RemoteBuilder:CleanupModule(moduleName)
 255 |     local removedCount = 0
 256 |
 257 |     for endpointName, endpoint in pairs(self._endpoints) do
 258 |         if string.find(endpointName, "^" .. moduleName .. "%.") then
 259 |             self._endpoints[endpointName] = nil
 260 |             removedCount = removedCount + 1
 261 |         end
 262 |     end
 263 |
 264 |     self._logger:Info("REMOTEBUILDER", "Module endpoints cleaned up", {
 265 |         module = moduleName,
 266 |         removed = removedCount
 267 |     })
 268 |
 269 |     return removedCount
 270 | end
 271 |
 272 | return RemoteBuilder
 273 |
 274 | --[[
 275 | @End: RemoteBuilder.lua
 276 | @Version: 1.0.0
 277 | @LastUpdate: 2025-11-18
 278 | @Maintainer: OVHL Core Team
 279 | --]]
 280 |
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Security/InputValidator.lua</strong> (76 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Security/InputValidator.lua`

```lua
   1 | --[[
   2 | OVHL FRAMEWORK V.1.0.1
   3 | @Component: InputValidator (Security)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Security.InputValidator
   5 | @Purpose: Robust Input Validation (Clean OOP)
   6 | --]]
   7 |
   8 | local InputValidator = {}
   9 | InputValidator.__index = InputValidator
  10 |
  11 | function InputValidator.new()
  12 |     local self = setmetatable({}, InputValidator)
  13 |     self._logger = nil
  14 |     self._schemas = self:_getDefaultSchemas()
  15 |     return self
  16 | end
  17 |
  18 | function InputValidator:Initialize(logger)
  19 |     self._logger = logger
  20 |     if self._logger then self._logger:Info("INPUTVALIDATOR", "Input Validator initialized") end
  21 | end
  22 |
  23 | function InputValidator:_getDefaultSchemas()
  24 |     return {
  25 |         ActionData = {
  26 |             type = "table",
  27 |             fields = {
  28 |                 action = { type = "string", min = 1, max = 50 },
  29 |                 data = { type = "table", optional = true }
  30 |             }
  31 |         }
  32 |     }
  33 | end
  34 |
  35 | function InputValidator:Validate(schemaName, data)
  36 |     if not self._schemas[schemaName] then return false, "Unknown schema: " .. tostring(schemaName) end
  37 |     local schema = self._schemas[schemaName]
  38 |     local result = self:_validateAgainstSchema(schema, data)
  39 |
  40 |     if result.valid then
  41 |         if self._logger then self._logger:Debug("INPUTVALIDATOR", "Valid", {schema=schemaName}) end
  42 |         return true, "Valid"
  43 |     else
  44 |         if self._logger then self._logger:Warn("INPUTVALIDATOR", "Invalid", {schema=schemaName, error=result.error}) end
  45 |         return false, result.error
  46 |     end
  47 | end
  48 |
  49 | function InputValidator:_validateAgainstSchema(schema, data)
  50 |     if schema.type and typeof(data) ~= schema.type then
  51 |         return { valid = false, error = "Expected " .. schema.type .. ", got " .. typeof(data) }
  52 |     end
  53 |     if schema.type == "table" and schema.fields then
  54 |         for fieldName, fieldSchema in pairs(schema.fields) do
  55 |             local val = data[fieldName]
  56 |             if not fieldSchema.optional and val == nil then return { valid = false, error = "Missing: " .. fieldName } end
  57 |             if val ~= nil then
  58 |                 local res = self:_validateField(fieldName, val, fieldSchema)
  59 |                 if not res.valid then return res end
  60 |             end
  61 |         end
  62 |     end
  63 |     return { valid = true }
  64 | end
  65 |
  66 | function InputValidator:_validateField(name, val, schema)
  67 |     if schema.type and typeof(val) ~= schema.type then return { valid = false, error = "Field " .. name .. " type mismatch" } end
  68 |     return { valid = true }
  69 | end
  70 |
  71 | function InputValidator:AddSchema(schemaName, schema)
  72 |     self._schemas[schemaName] = schema
  73 |     if self._logger then self._logger:Debug("INPUTVALIDATOR", "Schema added", {schema = schemaName}) end
  74 | end
  75 |
  76 | return InputValidator
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Security/InputValidatorManifest.lua</strong> (22 lines, 447B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Security/InputValidatorManifest.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: InputValidatorManifest (Security)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Security.InputValidatorManifest
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | -- V3.2.3 (HOTFIX): Menambahkan context
  10 | return {
  11 |     name = "InputValidator",
  12 |     dependencies = {"SmartLogger"},
  13 |     context = "Shared"
  14 | }
  15 |
  16 | --[[
  17 | @End: InputValidatorManifest.lua
  18 | @Version: 1.0.0
  19 | @LastUpdate: 2025-11-18
  20 | @Maintainer: OVHL Core Team
  21 | --]]
  22 |
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Security/PermissionCore.lua</strong> (79 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Security/PermissionCore.lua`

```lua
   1 | --[[
   2 |     OVHL FRAMEWORK V.1.1.0 (PERMISSION CORE)
   3 |     @Logic: Strict loading. Fallback only if Adapter is missing entirely.
   4 | --]]
   5 |
   6 | local RunService = game:GetService("RunService")
   7 | local Players = game:GetService("Players")
   8 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   9 |
  10 | local PermissionCore = {}
  11 | PermissionCore.__index = PermissionCore
  12 |
  13 | function PermissionCore.new()
  14 |     local self = setmetatable({}, PermissionCore)
  15 |     self._logger = nil
  16 |     self._adapter = nil
  17 |     self._isServer = RunService:IsServer()
  18 |     return self
  19 | end
  20 |
  21 | function PermissionCore:Initialize(logger)
  22 |     self._logger = logger
  23 |
  24 |     -- Default ke HDAdminAdapter (Hardcoded biar gak salah config)
  25 |     local adapterName = "HDAdminAdapter"
  26 |     local context = self._isServer and "Server" or "Client"
  27 |     self._logger:Info("PERMISSION", "Init PermissionCore ("..context..")", {adapter = adapterName})
  28 |
  29 |     local folder = ReplicatedStorage.OVHL.Systems.Adapters.Permission
  30 |     local mod = folder:FindFirstChild(adapterName)
  31 |
  32 |     if mod then
  33 |         local cls = require(mod)
  34 |         local instance = cls.new()
  35 |         if instance.Initialize then instance:Initialize(logger) end
  36 |
  37 |         -- STRICT CHECK: Fallback hanya jika folder HD Admin HILANG
  38 |         if instance:IsAvailable() then
  39 |             self._adapter = instance
  40 |             self._logger:Info("PERMISSION", "✅ Adapter READY: " .. adapterName)
  41 |         else
  42 |             self._logger:Warn("PERMISSION", "⛔ HD Admin not installed/found. Using Internal Fallback.")
  43 |             self:_loadInternal(folder)
  44 |         end
  45 |     else
  46 |         self._logger:Critical("PERMISSION", "Adapter Module Missing! Using Internal Fallback.")
  47 |         self:_loadInternal(folder)
  48 |     end
  49 | end
  50 |
  51 | function PermissionCore:_loadInternal(folder)
  52 |     local mod = folder:FindFirstChild("InternalAdapter")
  53 |     if mod then
  54 |         local cls = require(mod)
  55 |         self._adapter = cls.new()
  56 |         if self._adapter.Initialize then self._adapter:Initialize(self._logger) end
  57 |     end
  58 | end
  59 |
  60 | function PermissionCore:Start()
  61 |     if self._isServer then
  62 |         -- Replikasi Rank ke Client via Attribute
  63 |         local function updateRank(player)
  64 |             if not self._adapter then return end
  65 |             local rank = self._adapter:GetRank(player)
  66 |             player:SetAttribute("OVHL_Rank", rank)
  67 |         end
  68 |         Players.PlayerAdded:Connect(updateRank)
  69 |         for _, p in ipairs(Players:GetPlayers()) do updateRank(p) end
  70 |     end
  71 | end
  72 |
  73 | function PermissionCore:Check(player, permissionNode)
  74 |     if not self._adapter then return false, "System Error" end
  75 |     local rank = self._adapter:GetRank(player)
  76 |     return rank > 0
  77 | end
  78 |
  79 | return PermissionCore
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Security/PermissionCoreManifest.lua</strong> (9 lines, 232B)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Security/PermissionCoreManifest.lua`

```lua
   1 | --[[
   2 |     OVHL FRAMEWORK V.1.1.0 (SHARED CONTEXT)
   3 |     @Purpose: Agar Permission System jalan di Client & Server
   4 | --]]
   5 | return {
   6 |     name = "PermissionCore",
   7 |     dependencies = {"SmartLogger", "ConfigLoader"},
   8 |     context = "Shared"
   9 | }
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/Security/SecurityHelper.lua</strong> (174 lines, 4K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/Security/SecurityHelper.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: SecurityHelper (Security)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Security.SecurityHelper
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | --[[
  10 | OVHL ENGINE V3.0.0 - SECURITY HELPER
  11 | Version: 1.0.1
  12 | Path: ReplicatedStorage.OVHL.Systems.Security.SecurityHelper
  13 |
  14 | FEATURES:
  15 | - Unified security validation for services
  16 | - Standardized security patterns
  17 | - Easy integration dengan Knit services
  18 | --]]
  19 |
  20 | local SecurityHelper = {}
  21 | SecurityHelper.__index = SecurityHelper
  22 |
  23 | function SecurityHelper.new()
  24 |     local self = setmetatable({}, SecurityHelper)
  25 |     self._ovhl = nil
  26 |     self._logger = nil
  27 |     return self
  28 | end
  29 |
  30 | function SecurityHelper:Initialize(ovhl, logger)
  31 |     self._ovhl = ovhl
  32 |     self._logger = logger
  33 |     self._logger:Info("SECURITYHELPER", "Security Helper initialized")
  34 | end
  35 |
  36 | -- 🎯 STANDARD SECURITY VALIDATION PATTERN
  37 | function SecurityHelper:ValidateRequest(player, action, data, options)
  38 |     options = options or {}
  39 |     local schemaName = options.schema or "ActionData"
  40 |     local permissionNode = options.permission or "Default.Action"
  41 |     local rateLimitAction = options.rateLimit or action
  42 |
  43 |     -- 1. Input Validation
  44 |     local valid, validationError = self._ovhl.ValidateInput(schemaName, data)
  45 |     if not valid then
  46 |         return false, "Validation failed: " .. validationError
  47 |     end
  48 |
  49 |     -- 2. Rate Limiting
  50 |     local allowed = self._ovhl:CheckRateLimit(player, rateLimitAction)
  51 |     if not allowed then
  52 |         return false, "Rate limit exceeded"
  53 |     end
  54 |
  55 |     -- 3. Permission Check
  56 |     local hasPermission, permissionError = self._ovhl:CheckPermission(player, permissionNode)
  57 |     if not hasPermission then
  58 |         return false, "Permission denied: " .. permissionError
  59 |     end
  60 |
  61 |     self._logger:Debug("SECURITYHELPER", "Security validation passed", {
  62 |         player = player.Name,
  63 |         action = action,
  64 |         permission = permissionNode
  65 |     })
  66 |
  67 |     return true, "Validation passed"
  68 | end
  69 |
  70 | -- 🎯 QUICK SECURITY WRAPPER FOR KNIT SERVICE METHODS
  71 | function SecurityHelper:WrapServiceMethod(service, methodName, securityConfig)
  72 |     local originalMethod = service[methodName]
  73 |
  74 |     if not originalMethod then
  75 |         self._logger:Error("SECURITYHELPER", "Method not found for wrapping", {
  76 |             service = service.Name,
  77 |             method = methodName
  78 |         })
  79 |         return false
  80 |     end
  81 |
  82 |     service[methodName] = function(...)
  83 |         local args = {...}
  84 |         local player = args[1] -- First argument is typically player
  85 |
  86 |         if not player or not player:IsA("Player") then
  87 |             return false, "Invalid player"
  88 |         end
  89 |
  90 |         local data = args[2] or {}
  91 |
  92 |         -- Apply security validation
  93 |         local valid, errorMsg = self:ValidateRequest(player, methodName, data, securityConfig)
  94 |         if not valid then
  95 |             return false, errorMsg
  96 |         end
  97 |
  98 |         -- Call original method
  99 |         return originalMethod(...)
 100 |     end
 101 |
 102 |     self._logger:Debug("SECURITYHELPER", "Service method wrapped with security", {
 103 |         service = service.Name,
 104 |         method = methodName
 105 |     })
 106 |
 107 |     return true
 108 | end
 109 |
 110 | -- 🎯 BULK SECURITY SETUP FOR SERVICE
 111 | function SecurityHelper:SetupServiceSecurity(service, securityConfigs)
 112 |     local wrappedCount = 0
 113 |
 114 |     for methodName, config in pairs(securityConfigs) do
 115 |         local success = self:WrapServiceMethod(service, methodName, config)
 116 |         if success then
 117 |             wrappedCount = wrappedCount + 1
 118 |         end
 119 |     end
 120 |
 121 |     self._logger:Info("SECURITYHELPER", "Service security setup completed", {
 122 |         service = service.Name,
 123 |         methods = wrappedCount,
 124 |         total = table.size(securityConfigs)
 125 |     })
 126 |
 127 |     return wrappedCount
 128 | end
 129 |
 130 | -- 🎯 SECURITY AUDIT TOOLS
 131 | function SecurityHelper:AuditPlayer(player)
 132 |     local audit = {
 133 |         Player = player.Name,
 134 |         UserId = player.UserId,
 135 |         Permissions = {},
 136 |         RateLimits = {},
 137 |         SecurityScore = 0
 138 |     }
 139 |
 140 |     -- Get permission overview
 141 |     local PermissionCore = self._ovhl.GetSystem("PermissionCore")
 142 |     if PermissionCore then
 143 |         audit.Permissions = PermissionCore:GetPlayerPermissions(player)
 144 |     end
 145 |
 146 |     -- Get rate limit status
 147 |     local RateLimiter = self._ovhl.GetSystem("RateLimiter")
 148 |     if RateLimiter then
 149 |         audit.RateLimits = RateLimiter:GetPlayerStats(player)
 150 |     end
 151 |
 152 |     -- Calculate security score (simplified)
 153 |     local score = 100
 154 |     for _, limitInfo in pairs(audit.RateLimits) do
 155 |         local usagePercent = (limitInfo.current / limitInfo.limit) * 100
 156 |         if usagePercent > 80 then
 157 |             score = score - 10
 158 |         end
 159 |     end
 160 |
 161 |     audit.SecurityScore = math.max(0, score)
 162 |
 163 |     return audit
 164 | end
 165 |
 166 | return SecurityHelper
 167 |
 168 | --[[
 169 | @End: SecurityHelper.lua
 170 | @Version: 1.0.0
 171 | @LastUpdate: 2025-11-18
 172 | @Maintainer: OVHL Core Team
 173 | --]]
 174 |
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Systems/UI/ComponentScanner.lua</strong> (48 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Systems/UI/ComponentScanner.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.0
   3 |     @Component: ComponentScanner (Core System)
   4 |     @Path: ReplicatedStorage.OVHL.Systems.UI.ComponentScanner
   5 |     @Purpose: Recursive finder for Native UI elements (Config Driven)
   6 |     @State: Refactor V1.2.0
   7 | --]]
   8 |
   9 | local ComponentScanner = {}
  10 | ComponentScanner.__index = ComponentScanner
  11 |
  12 | function ComponentScanner.new()
  13 |     local self = setmetatable({}, ComponentScanner)
  14 |     self._logger = nil
  15 |     return self
  16 | end
  17 |
  18 | function ComponentScanner:Initialize(logger)
  19 |     self._logger = logger
  20 |     self._logger:Info("SCANNER", "ComponentScanner Ready (V1.2.0)")
  21 | end
  22 |
  23 | -- @param rootInstance: Instance (ScreenGui/Frame)
  24 | -- @param componentMap: Table { Key = "InstanceName" }
  25 | function ComponentScanner:Scan(rootInstance, componentMap)
  26 |     if not rootInstance then return nil, "Root instance is nil" end
  27 |     if not componentMap then return nil, "Component map is nil" end
  28 |
  29 |     local results = {}
  30 |     local missing = {}
  31 |
  32 |     local function deepFind(parent, name)
  33 |         return parent:FindFirstChild(name, true)
  34 |     end
  35 |
  36 |     for key, targetName in pairs(componentMap) do
  37 |         local instance = deepFind(rootInstance, targetName)
  38 |         if instance then
  39 |             results[key] = instance
  40 |         else
  41 |             table.insert(missing, targetName)
  42 |         end
  43 |     end
  44 |
  45 |     return results, missing
  46 | end
  47 |
  48 | return ComponentScanner
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Types/CoreTypes.lua</strong> (74 lines, 2K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Types/CoreTypes.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: CoreTypes (Core)
   4 | @Path: ReplicatedStorage.OVHL.Types.CoreTypes
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | --[[
  10 | OVHL ENGINE V3.0.0 - CORE TYPE DEFINITIONS
  11 | Version: 1.0.1
  12 | Path: ReplicatedStorage.OVHL.Types.CoreTypes
  13 |
  14 | PURPOSE:
  15 | - Centralized type definitions for Luau type checking
  16 | - Support for new V3.0.0 systems (Security, Registry, UI)
  17 | --]]
  18 |
  19 | export type Logger = {
  20 |     Debug: (self: Logger, domain: string, message: string, metadata: any?) -> (),
  21 |     Info: (self: Logger, domain: string, message: string, metadata: any?) -> (),
  22 |     Warn: (self: Logger, domain: string, message: string, metadata: any?) -> (),
  23 |     Error: (self: Logger, domain: string, message: string, metadata: any?) -> (),
  24 |     Critical: (self: Logger, domain: string, message: string, metadata: any?) -> (),
  25 |     SetModel: (self: Logger, modelName: string) -> boolean,
  26 | }
  27 |
  28 | export type SystemRegistry = {
  29 |     RegisterSystem: (self: SystemRegistry, name: string, instance: any, deps: {string}?) -> boolean,
  30 |     GetSystem: (self: SystemRegistry, name: string) -> any?,
  31 |     GetHealthStatus: (self: SystemRegistry) -> {[string]: any},
  32 | }
  33 |
  34 | export type OVHL = {
  35 |     GetSystem: (self: OVHL, name: string) -> any?,
  36 |     GetConfig: (self: OVHL, module: string, key: string?, context: string?) -> any?,
  37 |     GetClientConfig: (self: OVHL, module: string, key: string?) -> any?,
  38 |     ValidateInput: (self: OVHL, schema: string, data: any) -> (boolean, string?),
  39 |     CheckPermission: (self: OVHL, player: Player, node: string) -> (boolean, string?),
  40 |     CheckRateLimit: (self: OVHL, player: Player, action: string) -> boolean,
  41 | }
  42 |
  43 | -- Security Types
  44 | export type InputSchema = {
  45 |     type: string,
  46 |     fields: {[string]: FieldSchema}?,
  47 |     min: number?,
  48 |     max: number?,
  49 |     pattern: string?
  50 | }
  51 |
  52 | export type FieldSchema = {
  53 |     type: string,
  54 |     optional: boolean?,
  55 |     min: number?,
  56 |     max: number?
  57 | }
  58 |
  59 | -- UI Types
  60 | export type UIConfig = {
  61 |     Mode: "FUSION" | "NATIVE",
  62 |     NativePath: string?,
  63 |     FallbackMode: string?
  64 | }
  65 |
  66 | return nil
  67 |
  68 | --[[
  69 | @End: CoreTypes.lua
  70 | @Version: 1.0.0
  71 | @LastUpdate: 2025-11-18
  72 | @Maintainer: OVHL Core Team
  73 | --]]
  74 |
```

</details>

<details>
<summary><strong>🌙 src/ReplicatedStorage/OVHL/Types/ScannerContract.lua</strong> (63 lines, 1K)</summary>

**Full Path:** `src/ReplicatedStorage/OVHL/Types/ScannerContract.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: ScannerContract (Types)
   4 | @Path: ReplicatedStorage.OVHL.Types.ScannerContract
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | --[[
  10 | OVHL ENGINE V3.2.2
  11 | @Component: ScannerContract (Core Types)
  12 | @Path: ReplicatedStorage.OVHL.Types.ScannerContract
  13 | @Purpose: Mendefinisikan kontrak data antara Bootstrap (Scanner) dan SystemRegistry (Orchestrator).
  14 | --]]
  15 |
  16 | --[[
  17 |     Kontrak ini adalah "Single Source of Truth" untuk metadata sistem.
  18 |     Sesuai ADR V3.2.2 (Explicit Sibling Manifests).
  19 | --]]
  20 |
  21 | -- Definsi Manifest yang dibaca dari *Manifest.lua
  22 | export type SystemManifest = {
  23 |     -- Nama sistem, wajib cocok dengan nama file *.lua utama
  24 |     name: string,
  25 |
  26 |     -- Daftar dependensi (nama sistem lain)
  27 |     dependencies: {string},
  28 |
  29 |     -- Path ke ModuleScript utama (diisi oleh Scanner)
  30 |     modulePath: ModuleScript,
  31 |
  32 |     -- Prioritas load (opsional, untuk fine-tuning)
  33 |     priority: number?
  34 | }
  35 |
  36 | -- Hasil yang dikirim oleh Bootstrap.ScanManifests()
  37 | export type ScanResult = {
  38 |     -- Daftar manifest yang berhasil dipindai
  39 |     manifests: {SystemManifest},
  40 |
  41 |     -- Daftar error (misal: manifest rusak, dependensi hilang)
  42 |     errors: {[string]: string}?,
  43 |
  44 |     -- Daftar sistem V3.1.0 (legacy, tanpa manifest)
  45 |     unmigrated: {ModuleScript}?
  46 | }
  47 |
  48 |
  49 | return nil
  50 |
  51 | --[[
  52 | @End: ScannerContract.lua
  53 | @Version: 1.0.1
  54 | @See: docs/ADR_V3-2-2.md (Nanti kita buat)
  55 | --]]
  56 |
  57 | --[[
  58 | @End: ScannerContract.lua
  59 | @Version: 1.0.0
  60 | @LastUpdate: 2025-11-18
  61 | @Maintainer: OVHL Core Team
  62 | --]]
  63 |
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Debug_MockAssets/Install_Mock_UI.server.lua</strong> (48 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Debug_MockAssets/Install_Mock_UI.server.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.0
   3 |     @Component: Install_Mock_UI
   4 |     @Path: src/ServerScriptService/OVHL/Debug_MockAssets/Install_Mock_UI.server.lua
   5 |     @Purpose: Generates StarterGui Assets for Testing
   6 |     @Created: Wed, Nov 19, 2025 09:10:48
   7 | --]]
   8 |
   9 | local StarterGui = game:GetService("StarterGui")
  10 |
  11 | if not StarterGui:FindFirstChild("ShopNativeScreen") then
  12 |     local sg = Instance.new("ScreenGui")
  13 |     sg.Name = "ShopNativeScreen"
  14 |     sg.ResetOnSpawn = false
  15 |     sg.Enabled = false
  16 |     sg.Parent = StarterGui
  17 |
  18 |     local frame = Instance.new("Frame", sg)
  19 |     frame.Name = "MainFrame"
  20 |     frame.Size = UDim2.fromOffset(350, 250)
  21 |     frame.Position = UDim2.fromScale(0.5, 0.5)
  22 |     frame.AnchorPoint = Vector2.new(0.5, 0.5)
  23 |     frame.BackgroundColor3 = Color3.fromRGB(200, 80, 80) -- Merah (Native)
  24 |
  25 |     local lbl = Instance.new("TextLabel", frame)
  26 |     lbl.Name = "HeaderTitle"
  27 |     lbl.Text = "NATIVE UI DETECTED"
  28 |     lbl.Size = UDim2.new(1,0,0,40)
  29 |     lbl.BackgroundTransparency = 1
  30 |     lbl.TextColor3 = Color3.new(1,1,1)
  31 |     lbl.Font = Enum.Font.GothamBlack
  32 |     lbl.TextSize = 18
  33 |
  34 |     local btn = Instance.new("TextButton", frame)
  35 |     btn.Name = "Btn_BuySword"
  36 |     btn.Text = "BUY (NATIVE)"
  37 |     btn.Size = UDim2.fromOffset(200, 50)
  38 |     btn.Position = UDim2.fromScale(0.5, 0.4)
  39 |     btn.AnchorPoint = Vector2.new(0.5, 0.5)
  40 |     btn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
  41 |
  42 |     local close = Instance.new("TextButton", frame)
  43 |     close.Name = "Btn_Close"
  44 |     close.Text = "CLOSE"
  45 |     close.Size = UDim2.fromOffset(200, 40)
  46 |     close.Position = UDim2.fromScale(0.5, 0.8)
  47 |     close.AnchorPoint = Vector2.new(0.5, 0.5)
  48 | end
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Modules/MinimalModule/MinimalService.lua</strong> (21 lines, 674B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Modules/MinimalModule/MinimalService.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.0
   3 |     @Component: MinimalService
   4 |     @Path: src/ServerScriptService/OVHL/Modules/MinimalModule/MinimalService.lua
   5 |     @Purpose: Server Logic (Fasad)
   6 |     @Created: Wed, Nov 19, 2025 09:10:48
   7 | --]]
   8 |
   9 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
  10 | local Knit = require(ReplicatedStorage.Packages.Knit)
  11 |
  12 | local MinimalService = Knit.CreateService { Name = "MinimalService", Client = {} }
  13 |
  14 | function MinimalService:KnitInit()
  15 |     self.Logger = require(ReplicatedStorage.OVHL.Core.OVHL).GetSystem("SmartLogger")
  16 |     self.Logger:Info("SERVICE", "MinimalService Initialized")
  17 | end
  18 |
  19 | function MinimalService:KnitStart() end
  20 |
  21 | return MinimalService
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Modules/MinimalModule/ServerConfig.lua</strong> (9 lines, 247B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Modules/MinimalModule/ServerConfig.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.0
   3 |     @Component: ServerConfig
   4 |     @Path: src/ServerScriptService/OVHL/Modules/MinimalModule/ServerConfig.lua
   5 |     @Purpose: Server Side Configuration
   6 |     @Created: Wed, Nov 19, 2025 09:10:48
   7 | --]]
   8 |
   9 | return { Debug = true }
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Modules/PrototypeShop/PrototypeShopService.lua</strong> (70 lines, 2K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Modules/PrototypeShop/PrototypeShopService.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.2
   3 |     @Component: PrototypeShopService
   4 |     @Path: ServerScriptService.OVHL.Modules.PrototypeShop.PrototypeShopService
   5 |     @Fixes: Added missing Rate Limit Registration loop
   6 | --]]
   7 |
   8 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   9 | local Knit = require(ReplicatedStorage.Packages.Knit)
  10 |
  11 | local PrototypeShopService = Knit.CreateService { Name = "PrototypeShopService", Client = {} }
  12 |
  13 | function PrototypeShopService:KnitInit()
  14 |     self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
  15 |     self.Logger = self.OVHL.GetSystem("SmartLogger")
  16 |
  17 |     -- Load Config (Merge Shared + Server)
  18 |     self.Config = self.OVHL.GetConfig("PrototypeShop", nil, "Server")
  19 |
  20 |     self.InputValidator = self.OVHL.GetSystem("InputValidator")
  21 |     self.RateLimiter = self.OVHL.GetSystem("RateLimiter")
  22 |
  23 |     -- 1. Register Validation Schemas
  24 |     if self.Config.Security and self.Config.Security.Schemas then
  25 |         for name, schema in pairs(self.Config.Security.Schemas) do
  26 |             self.InputValidator:AddSchema(name, schema)
  27 |         end
  28 |     end
  29 |
  30 |     -- [[ CRITICAL FIX: REGISTER RATE LIMITS ]]
  31 |     -- Tanpa ini, RateLimiter tidak tahu aturan mainnya
  32 |     if self.Config.Security and self.Config.Security.RateLimits then
  33 |         for action, limit in pairs(self.Config.Security.RateLimits) do
  34 |             self.RateLimiter:SetLimit(action, limit.max, limit.window)
  35 |             self.Logger:Debug("SHOP", "Registered Limit", {action=action, max=limit.max})
  36 |         end
  37 |     else
  38 |         self.Logger:Warn("SHOP", "No RateLimits found in Config!")
  39 |     end
  40 | end
  41 |
  42 | function PrototypeShopService:KnitStart() end
  43 |
  44 | function PrototypeShopService.Client:BuyItem(player, data)
  45 |     -- 1. Validate Input (Sanitasi & Schema)
  46 |     local valid, err = self.Server.InputValidator:Validate("BuyItem", data)
  47 |     if not valid then
  48 |         warn("❌ [SHOP SERVER] Invalid Input:", err)
  49 |         return false, "Invalid Input"
  50 |     end
  51 |
  52 |     -- 2. Validate Rate Limit (CEK CONFIG SHARED)
  53 |     -- Config bilang: Max 3 request per 10 detik
  54 |     if not self.Server.RateLimiter:Check(player, "BuyItem") then
  55 |         warn("❌ [SHOP SERVER] Spam Detected from " .. player.Name)
  56 |         return false, "Spam Detected! Slow down."
  57 |     end
  58 |
  59 |     -- 3. Business Logic
  60 |     print("💰 [SHOP SERVER] Transaction Success: " .. player.Name .. " bought " .. data.itemId)
  61 |     return true, "Success"
  62 | end
  63 |
  64 | -- FUNCTION TEST LEAK (UTK BUKTIKAN NETWORK GUARD)
  65 | function PrototypeShopService.Client:TestSecretLeak(player)
  66 |     -- Mencoba mengirim seluruh config (termasuk ServerConfig) ke Client
  67 |     return self.Server.Config
  68 | end
  69 |
  70 | return PrototypeShopService
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Modules/PrototypeShop/ServerConfig.lua</strong> (9 lines, 235B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Modules/PrototypeShop/ServerConfig.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.0
   3 |     @Component: ServerConfig
   4 |     @Path: src/ServerScriptService/OVHL/Modules/PrototypeShop/ServerConfig.lua
   5 |     @Purpose: Server Config
   6 |     @Created: Wed, Nov 19, 2025 09:10:48
   7 | --]]
   8 |
   9 | return { Debug = true }
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/ServerRuntime.server.lua</strong> (37 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/ServerRuntime.server.lua`

```lua
   1 | --[[
   2 |     OVHL FRAMEWORK V.1.2.2
   3 |     @Component: ServerRuntime
   4 |     @Purpose: Bootstraps OVHL & Knit with FULL Security Middleware
   5 | --]]
   6 |
   7 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   8 | local ServerScriptService = game:GetService("ServerScriptService")
   9 | local Knit = require(ReplicatedStorage.Packages.Knit)
  10 | local Bootstrap = require(ReplicatedStorage.OVHL.Core.Bootstrap)
  11 |
  12 | local OVHL = Bootstrap:Initialize()
  13 | local Logger = OVHL.GetSystem("SmartLogger")
  14 | Logger:Info("SERVER", "🚀 Starting OVHL Server Runtime V1.2.2")
  15 |
  16 | local Kernel = require(ReplicatedStorage.OVHL.Core.Kernel).new()
  17 | Kernel:Initialize(Logger)
  18 | Kernel:ScanModules()
  19 |
  20 | -- Load Firewall
  21 | local NetworkGuard = require(ServerScriptService.OVHL.Systems.Security.NetworkGuard)
  22 |
  23 | -- Start Knit with Full Protection
  24 | Knit.Start({
  25 |     Middleware = {
  26 |         -- [INBOUND] Sanitasi data kotor dari Client
  27 |         Inbound = { NetworkGuard.Inbound },
  28 |
  29 |         -- [OUTBOUND] Sensor data rahasia Server
  30 |         Outbound = { NetworkGuard.Outbound }
  31 |     }
  32 | }):andThen(function()
  33 |     Logger:Info("SERVER", "Knit Started. Firewall Active (In/Out).")
  34 |     Kernel:RegisterKnitServices(Knit)
  35 | end):catch(function(err)
  36 |     Logger:Critical("SERVER", "Fatal Boot Error", {error = tostring(err)})
  37 | end)
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Systems/Advanced/DataManager.lua</strong> (98 lines, 2K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Systems/Advanced/DataManager.lua`

```lua
   1 | --[[
   2 | OVHL FRAMEWORK V.1.0.1
   3 | @Component: @Component: DataManager (Core System) (Standard)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Advanced.DataManager
   5 | @Purpose: Data Management with Safe Timeout Handling
   6 | --]]
   7 |
   8 | local DataStoreService = game:GetService("DataStoreService")
   9 |
  10 | local DataManager = {}
  11 | DataManager.__index = DataManager
  12 | local DEFAULT_DS = "OVHL_PlayerDatav3"
  13 |
  14 | function DataManager.new()
  15 |     local self = setmetatable({}, DataManager)
  16 |     self._logger = nil
  17 |     self._ds = nil
  18 |     self._cache = {}
  19 |     self._init = false
  20 |     return self
  21 | end
  22 |
  23 | function DataManager:Initialize(logger)
  24 |     self._logger = logger
  25 | end
  26 |
  27 | function DataManager:Start()
  28 |     local success, ds = pcall(function() return DataStoreService:GetDataStore(DEFAULT_DS) end)
  29 |     if success then
  30 |         self._ds = ds
  31 |         self._init = true
  32 |         if self._logger then self._logger:Info("DATAMANAGER", "Ready") end
  33 |     else
  34 |         if self._logger then self._logger:Critical("DATAMANAGER", "DataStore Connect Fail") end
  35 |     end
  36 | end
  37 |
  38 | function DataManager:_waitForInit()
  39 |     if self._init then return true end
  40 |     local start = os.clock()
  41 |     while not self._init do
  42 |         if os.clock() - start > 10 then return false end
  43 |         task.wait(0.1)
  44 |     end
  45 |     return true
  46 | end
  47 |
  48 | function DataManager:LoadData(player)
  49 |     if not self:_waitForInit() then
  50 |         -- [HOTFIX] Check logger existence before using
  51 |         if self._logger then
  52 |             self._logger:Critical("DATAMANAGER", "Timeout waiting for init", {player=player.Name})
  53 |         else
  54 |             warn("[DATAMANAGER] CRITICAL TIMEOUT (Logger nil): " .. player.Name)
  55 |         end
  56 |         return nil
  57 |     end
  58 |
  59 |     local key = "Player_" .. player.UserId
  60 |     local success, data = pcall(function() return self._ds:GetAsync(key) end)
  61 |
  62 |     if not success then
  63 |         if self._logger then self._logger:Error("DATAMANAGER", "Load Failed", {err=tostring(data)}) end
  64 |         return nil
  65 |     end
  66 |
  67 |     data = data or self:_createDefault(player)
  68 |     self._cache[player.UserId] = data
  69 |     if self._logger then self._logger:Info("DATAMANAGER", "Loaded", {player=player.Name}) end
  70 |     return data
  71 | end
  72 |
  73 | function DataManager:SaveData(player)
  74 |     if not self:_waitForInit() or not self._cache[player.UserId] then return false end
  75 |     local key = "Player_" .. player.UserId
  76 |     local data = self._cache[player.UserId]
  77 |     data.meta.lastSave = os.time()
  78 |
  79 |     local success, err = pcall(function() self._ds:SetAsync(key, data) end)
  80 |     if not success and self._logger then
  81 |          self._logger:Error("DATAMANAGER", "Save Failed", {err=tostring(err)})
  82 |     end
  83 |     return success
  84 | end
  85 |
  86 | function DataManager:ClearCache(player) self._cache[player.UserId] = nil end
  87 | function DataManager:GetCachedData(player) return self._cache[player.UserId] end
  88 |
  89 | function DataManager:_createDefault(player)
  90 |     return {
  91 |         meta = { userId = player.UserId, joinDate = os.time() },
  92 |         currency = { coins = 100, gems = 0 },
  93 |         inventory = {},
  94 |         stats = { level = 1, xp = 0 }
  95 |     }
  96 | end
  97 |
  98 | return DataManager
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Systems/Advanced/DataManagerManifest.lua</strong> (34 lines, 693B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Systems/Advanced/DataManagerManifest.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: DataManagerManifest (Advanced)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Advanced.DataManagerManifest
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | --[[
  10 | OVHL ENGINE V3.2.3 (HOTFIX)
  11 | @Component: DataManager Manifest
  12 | @Path: ReplicatedStorage.OVHL.Systems.Advanced.DataManagerManifest
  13 | @Purpose: Deklarasi dependensi V3.2.2 untuk DataManager.
  14 | --]]
  15 |
  16 | return {
  17 | 	name = "DataManager",
  18 | 	dependencies = { "SmartLogger", "ConfigLoader" },
  19 | 	context = "Server",
  20 | }
  21 |
  22 | --[[
  23 | @End: DataManagerManifest.lua
  24 | @Version: 1.0.1 (Patched)
  25 | @See: docs/ADR_V3-2-2.md
  26 | --]]
  27 |
  28 | --[[
  29 | @End: DataManagerManifest.lua
  30 | @Version: 1.0.0
  31 | @LastUpdate: 2025-11-18
  32 | @Maintainer: OVHL Core Team
  33 | --]]
  34 |
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Systems/Advanced/NotificationService.lua</strong> (48 lines, 1K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Systems/Advanced/NotificationService.lua`

```lua
   1 | --[[
   2 | OVHL FRAMEWORK V.1.1.0
   3 | @Component: NotificationService (Core System)
   4 | @Path: ServerScriptService.OVHL.Systems.Advanced.NotificationService
   5 | @Purpose: Menyediakan API terpusat untuk mengirim notifikasi (Toast, UI) ke client.
   6 | --]]
   7 |
   8 | local NotificationService = {}
   9 | NotificationService.__index = NotificationService
  10 |
  11 | function NotificationService.new()
  12 |     local self = setmetatable({}, NotificationService)
  13 |     self._logger = nil
  14 |     self._router = nil
  15 |     return self
  16 | end
  17 |
  18 | function NotificationService:Initialize(logger)
  19 |     self._logger = logger
  20 |
  21 |     -- [V1.1.0 ARCHITECTURE FIX] ABSOLUTE PATH
  22 |     local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
  23 |     self._router = OVHL.GetSystem("NetworkingRouter")
  24 |
  25 |     if not self._router then
  26 |         self._logger:Error("NOTIFICATION", "Gagal mendapatkan NetworkingRouter!")
  27 |         return
  28 |     end
  29 |
  30 |     self._logger:Info("NOTIFICATION", "Notification Service Ready (Server API).")
  31 | end
  32 |
  33 | function NotificationService:SendToPlayer(player, message, icon, duration)
  34 |     if not self._router then return end
  35 |
  36 |     self._router:SendToClient(player, "OVHL.Notification.Show", {
  37 |         Message = message,
  38 |         Icon = icon or "Info",
  39 |         Duration = duration or 5
  40 |     })
  41 | end
  42 |
  43 | function NotificationService:SendToAll(message, icon, duration)
  44 |     if not self._router then return end
  45 |     self._logger:Warn("NOTIFICATION", "SendToAll belum diimplementasi di router.")
  46 | end
  47 |
  48 | return NotificationService
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Systems/Advanced/NotificationServiceManifest.lua</strong> (22 lines, 487B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Systems/Advanced/NotificationServiceManifest.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: NotificationServiceManifest (Advanced)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Advanced.NotificationServiceManifest
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | -- V3.2.3 (HOTFIX): Menambahkan context
  10 | return {
  11 |     name = "NotificationService",
  12 |     dependencies = {"SmartLogger", "NetworkingRouter"},
  13 |     context = "Server"
  14 | }
  15 |
  16 | --[[
  17 | @End: NotificationServiceManifest.lua
  18 | @Version: 1.0.0
  19 | @LastUpdate: 2025-11-18
  20 | @Maintainer: OVHL Core Team
  21 | --]]
  22 |
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Systems/Advanced/PlayerManager.lua</strong> (89 lines, 2K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Systems/Advanced/PlayerManager.lua`

```lua
   1 | --[[
   2 | OVHL FRAMEWORK V.1.1.0
   3 | @Component: PlayerManager (Core System)
   4 | @Path: ServerScriptService.OVHL.Systems.Advanced.PlayerManager
   5 | @Purpose: Player Lifecycle with Safe Data Handling
   6 | --]]
   7 |
   8 | local Players = game:GetService("Players")
   9 | local PlayerManager = {}
  10 | PlayerManager.__index = PlayerManager
  11 |
  12 | function PlayerManager.new()
  13 | 	local self = setmetatable({}, PlayerManager)
  14 | 	self._logger = nil
  15 | 	self._dataManager = nil
  16 | 	self._connections = {}
  17 | 	return self
  18 | end
  19 |
  20 | function PlayerManager:Initialize(logger)
  21 | 	self._logger = logger
  22 | end
  23 |
  24 | function PlayerManager:Start()
  25 |     -- [V1.1.0 ARCHITECTURE FIX] ABSOLUTE PATH
  26 | 	local OVHL = require(game:GetService("ReplicatedStorage").OVHL.Core.OVHL)
  27 | 	self._dataManager = OVHL.GetSystem("DataManager")
  28 |
  29 | 	if not self._dataManager then
  30 | 		self._logger:Critical("PLAYERMANAGER", "GAGAL mendapatkan DataManager!")
  31 | 		return
  32 | 	end
  33 |
  34 | 	self:_connectEvents()
  35 | 	self._logger:Info("PLAYERMANAGER", "Player Manager Ready.")
  36 |
  37 | 	for _, player in ipairs(Players:GetPlayers()) do
  38 | 		task.spawn(function() self:_onPlayerAdded(player) end)
  39 | 	end
  40 | end
  41 |
  42 | function PlayerManager:Destroy()
  43 | 	self._logger:Info("PLAYERMANAGER", "Shutdown: Saving data...")
  44 | 	self:_onGameClose()
  45 | 	for _, connection in pairs(self._connections) do
  46 | 		pcall(function() connection:Disconnect() end)
  47 | 	end
  48 | 	self._connections = {}
  49 | end
  50 |
  51 | function PlayerManager:_connectEvents()
  52 | 	self._connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
  53 | 		self:_onPlayerAdded(player)
  54 | 	end)
  55 | 	self._connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
  56 | 		self:_onPlayerRemoving(player)
  57 | 	end)
  58 | end
  59 |
  60 | function PlayerManager:_onPlayerAdded(player)
  61 | 	self._logger:Info("PLAYERMANAGER", "Player Joining...", { player = player.Name })
  62 |
  63 | 	if not self._dataManager then return end
  64 |
  65 | 	local data = self._dataManager:LoadData(player)
  66 |
  67 | 	if data then
  68 | 		self._logger:Info("PLAYERMANAGER", "Data siap.", { player = player.Name })
  69 | 	else
  70 | 		self._logger:Critical("PLAYERMANAGER", "DATA LOAD GAGAL TOTAL! Kicking player untuk keamanan.", { player = player.Name })
  71 |         player:Kick("⚠️ OVHL Security: Gagal memuat data profil Anda. Silakan rejoin.")
  72 | 	end
  73 | end
  74 |
  75 | function PlayerManager:_onPlayerRemoving(player)
  76 | 	self._logger:Info("PLAYERMANAGER", "Player Leaving...", { player = player.Name })
  77 | 	if not self._dataManager then return end
  78 |
  79 | 	local success = self._dataManager:SaveData(player)
  80 | 	self._dataManager:ClearCache(player)
  81 | end
  82 |
  83 | function PlayerManager:_onGameClose()
  84 | 	for _, player in ipairs(Players:GetPlayers()) do
  85 | 		self:_onPlayerRemoving(player)
  86 | 	end
  87 | end
  88 |
  89 | return PlayerManager
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Systems/Advanced/PlayerManagerManifest.lua</strong> (22 lines, 458B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Systems/Advanced/PlayerManagerManifest.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: PlayerManagerManifest (Advanced)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Advanced.PlayerManagerManifest
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | -- V3.2.3 (HOTFIX): Menambahkan context
  10 | return {
  11 |     name = "PlayerManager",
  12 |     dependencies = {"SmartLogger", "DataManager"},
  13 |     context = "Server"
  14 | }
  15 |
  16 | --[[
  17 | @End: PlayerManagerManifest.lua
  18 | @Version: 1.0.0
  19 | @LastUpdate: 2025-11-18
  20 | @Maintainer: OVHL Core Team
  21 | --]]
  22 |
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Systems/Security/NetworkGuard.lua</strong> (110 lines, 3K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Systems/Security/NetworkGuard.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.2
   3 |     @Component: NetworkGuard (Middleware)
   4 |     @Purpose:
   5 |       1. INBOUND: Memastikan argumen dari Client masuk akal (Type Safety).
   6 |       2. OUTBOUND: Mencegah kebocoran data sensitif (Data Loss Prevention).
   7 | --]]
   8 |
   9 | local NetworkGuard = {}
  10 |
  11 | -- [[ CONFIGURATION ]]
  12 | local BLACKLIST_KEYS = { "API_?KEY", "SECRET", "TOKEN", "WEBHOOK", "PASSWORD", "AUTH" }
  13 | local MAX_STRING_LEN = 1000 -- Cegah crash server karena string raksasa
  14 | local MAX_TABLE_DEPTH = 10  -- Cegah cyclic table attack
  15 |
  16 | -- [[ HELPER: OUTBOUND SANITIZER (SERVER -> CLIENT) ]]
  17 | local function isSensitive(key)
  18 |     if type(key) ~= "string" then return false end
  19 |     local k = string.upper(key)
  20 |     for _, pattern in ipairs(BLACKLIST_KEYS) do
  21 |         if string.find(k, pattern) then return true end
  22 |     end
  23 |     return false
  24 | end
  25 |
  26 | local function sanitizeOutbound(data, depth)
  27 |     if depth > MAX_TABLE_DEPTH then return nil end
  28 |     if type(data) ~= "table" then return data end
  29 |
  30 |     local clean = {}
  31 |     for k, v in pairs(data) do
  32 |         if isSensitive(k) then
  33 |             clean[k] = "[REDACTED]"
  34 |             warn("🚨 [GUARD-OUT] Blocked sensitive key:", k)
  35 |         elseif type(v) == "table" then
  36 |             clean[k] = sanitizeOutbound(v, depth + 1)
  37 |         else
  38 |             clean[k] = v
  39 |         end
  40 |     end
  41 |     return clean
  42 | end
  43 |
  44 | -- [[ HELPER: INBOUND SANITIZER (CLIENT -> SERVER) ]]
  45 | -- Tugas: Hapus Instance yang tidak relevan, potong string kepanjangan, cegah NaN/Inf
  46 | local function sanitizeInbound(data, depth)
  47 |     if depth > MAX_TABLE_DEPTH then return nil end
  48 |
  49 |     local t = type(data)
  50 |
  51 |     if t == "string" then
  52 |         if #data > MAX_STRING_LEN then
  53 |             return string.sub(data, 1, MAX_STRING_LEN) -- Potong string spam
  54 |         end
  55 |         return data
  56 |     elseif t == "number" then
  57 |         -- Cegah NaN (Not a Number) atau Infinity yang bisa ngerusak math server
  58 |         if data ~= data or data == math.huge or data == -math.huge then
  59 |             return 0
  60 |         end
  61 |         return data
  62 |     elseif t == "table" then
  63 |         local clean = {}
  64 |         for k, v in pairs(data) do
  65 |             -- Key harus aman (string/number), Value disanitasi
  66 |             if type(k) == "string" or type(k) == "number" then
  67 |                 clean[k] = sanitizeInbound(v, depth + 1)
  68 |             end
  69 |         end
  70 |         return clean
  71 |     elseif t == "function" or t == "thread" or t == "userdata" then
  72 |         -- Hapus tipe data yang tidak bisa/bahaya dikirim via network
  73 |         return nil
  74 |     end
  75 |
  76 |     return data -- Boolean, Instance (valid), dll lolos
  77 | end
  78 |
  79 | -- [[ KNIT MIDDLEWARES ]]
  80 |
  81 | -- 1. Inbound: Dipasang di Client -> Server
  82 | function NetworkGuard.Inbound(nextFn)
  83 |     return function(player, ...)
  84 |         local args = {...}
  85 |         local cleanArgs = {}
  86 |
  87 |         -- Loop semua argumen dan bersihkan
  88 |         for i, arg in ipairs(args) do
  89 |             cleanArgs[i] = sanitizeInbound(arg, 1)
  90 |         end
  91 |
  92 |         return nextFn(player, table.unpack(cleanArgs))
  93 |     end
  94 | end
  95 |
  96 | -- 2. Outbound: Dipasang di Server -> Client
  97 | function NetworkGuard.Outbound(nextFn)
  98 |     return function(player, ...)
  99 |         local results = {nextFn(player, ...)}
 100 |         local cleanResults = {}
 101 |
 102 |         for i, res in ipairs(results) do
 103 |             cleanResults[i] = sanitizeOutbound(res, 1)
 104 |         end
 105 |
 106 |         return table.unpack(cleanResults)
 107 |     end
 108 | end
 109 |
 110 | return NetworkGuard
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Systems/Security/RateLimiter.lua</strong> (130 lines, 3K)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Systems/Security/RateLimiter.lua`

```lua
   1 | --[[
   2 | OVHL FRAMEWORK V.1.0.1
   3 | @Component: @Component: RateLimiter (Core System) (Standard)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Security.RateLimiter
   5 | @Purpose: Rate Limiting (SERVER ONLY)
   6 | --]]
   7 |
   8 | local RunService = game:GetService("RunService")
   9 | local RateLimiter = {}
  10 | RateLimiter.__index = RateLimiter
  11 |
  12 | function RateLimiter.new()
  13 | 	local self = setmetatable({}, RateLimiter)
  14 | 	self._logger = nil
  15 | 	self._limits = self:_getDefaultLimits()
  16 | 	self._tracking = {}
  17 | 	self._cleanupInterval = 300
  18 | 	self._lastCleanup = os.time()
  19 | 	self._isRunning = false
  20 | 	self._cleanupThread = nil
  21 |
  22 |     -- [PHASE 1 FIX] Security Guard
  23 |     if not RunService:IsServer() then
  24 |         error("CRITICAL SECURITY: RateLimiter loaded on Client! This module is Server-Only.")
  25 |     end
  26 | 	return self
  27 | end
  28 |
  29 | function RateLimiter:Initialize(logger) self._logger = logger end
  30 |
  31 | function RateLimiter:Start()
  32 | 	self._isRunning = true
  33 | 	self:_startCleanupTask()
  34 | 	self._logger:Info("RATELIMITER", "Rate Limiter Ready (Server Secured).")
  35 | end
  36 |
  37 | function RateLimiter:Destroy()
  38 | 	self._logger:Info("RATELIMITER", "Shutdown initiated.")
  39 | 	self._isRunning = false
  40 | 	if self._cleanupThread then self._cleanupThread = nil end
  41 | end
  42 |
  43 | function RateLimiter:_getDefaultLimits()
  44 | 	return {
  45 | 		DoAction = { max = 10, window = 60 },
  46 | 		Purchase = { max = 5, window = 300 },
  47 | 		Equip = { max = 20, window = 60 },
  48 | 		ButtonClick = { max = 30, window = 60 },
  49 | 		ScreenOpen = { max = 15, window = 60 },
  50 | 		DataSave = { max = 5, window = 60 },
  51 | 		DataLoad = { max = 10, window = 60 },
  52 | 	}
  53 | end
  54 |
  55 | function RateLimiter:Check(player, action)
  56 | 	if not player or not action then return true end
  57 | 	local limitConfig = self._limits[action]
  58 | 	if not limitConfig then return true end
  59 |
  60 | 	local playerId = tostring(player.UserId)
  61 | 	local trackingKey = playerId .. "_" .. action
  62 | 	local now = os.time()
  63 |
  64 | 	if not self._tracking[trackingKey] then
  65 | 		self._tracking[trackingKey] = { count = 1, windowStart = now }
  66 | 		return true
  67 | 	end
  68 |
  69 | 	local tracking = self._tracking[trackingKey]
  70 | 	if now - tracking.windowStart >= limitConfig.window then
  71 | 		tracking.count = 1
  72 | 		tracking.windowStart = now
  73 | 		return true
  74 | 	end
  75 |
  76 | 	if tracking.count >= limitConfig.max then
  77 | 		self._logger:Warn("RATELIMITER", "Rate limit exceeded", {player = player.Name, action = action})
  78 | 		return false
  79 | 	end
  80 | 	tracking.count = tracking.count + 1
  81 | 	return true
  82 | end
  83 |
  84 | function RateLimiter:SetLimit(action, max, win) self._limits[action] = {max=max, window=win} return true end
  85 | function RateLimiter:GetLimit(action) return self._limits[action] end
  86 |
  87 | function RateLimiter:GetPlayerStats(player)
  88 | 	local playerId = tostring(player.UserId)
  89 | 	local stats = {}
  90 | 	local now = os.time()
  91 | 	for action, limitConfig in pairs(self._limits) do
  92 | 		local trackingKey = playerId .. "_" .. action
  93 | 		local tracking = self._tracking[trackingKey]
  94 | 		if tracking then
  95 | 			local rem = limitConfig.window - (now - tracking.windowStart)
  96 | 			stats[action] = { current = tracking.count, limit = limitConfig.max, resetIn = rem < 0 and 0 or rem }
  97 | 		else
  98 | 			stats[action] = { current = 0, limit = limitConfig.max, resetIn = 0 }
  99 | 		end
 100 | 	end
 101 | 	return stats
 102 | end
 103 |
 104 | function RateLimiter:_startCleanupTask()
 105 | 	self._cleanupThread = task.spawn(function()
 106 | 		while self._isRunning do
 107 | 			task.wait(self._cleanupInterval)
 108 | 			if not self._isRunning then break end
 109 | 			self:_cleanupOldData()
 110 | 		end
 111 | 	end)
 112 | end
 113 |
 114 | function RateLimiter:_cleanupOldData()
 115 | 	local now = os.time()
 116 | 	local removedCount = 0
 117 | 	for trackingKey, tracking in pairs(self._tracking) do
 118 | 		local pid, act = string.match(trackingKey, "^(%d+)_(.+)$")
 119 | 		if pid then
 120 | 			local conf = self._limits[act]
 121 | 			if conf and (now - tracking.windowStart > conf.window + 300) then
 122 | 				self._tracking[trackingKey] = nil
 123 | 				removedCount = removedCount + 1
 124 | 			end
 125 | 		end
 126 | 	end
 127 | 	if removedCount > 0 then self._logger:Debug("RATELIMITER", "Cleaned up", {count=removedCount}) end
 128 | end
 129 |
 130 | return RateLimiter
```

</details>

<details>
<summary><strong>🌙 src/ServerScriptService/OVHL/Systems/Security/RateLimiterManifest.lua</strong> (14 lines, 392B)</summary>

**Full Path:** `src/ServerScriptService/OVHL/Systems/Security/RateLimiterManifest.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: RateLimiterManifest (Security)
   4 | @Path: ReplicatedStorage.OVHL.Systems.Security.RateLimiterManifest
   5 | @Purpose: Manifest file for RateLimiter
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | -- [PHASE 1 FIX] Pindah ke Server (Context: Server)
  10 | return {
  11 |     name = "RateLimiter",
  12 |     dependencies = {"SmartLogger", "ConfigLoader"},
  13 |     context = "Server" -- SECURITY FIX: Server only
  14 | }
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/ClientRuntime.client.lua</strong> (96 lines, 2K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/ClientRuntime.client.lua`

```lua
   1 | --[[
   2 | 	OVHL ENGINE V1.1.2
   3 | 	@Component: ClientRuntime.client (Entry Point)
   4 | 	@Path: StarterPlayer.StarterPlayerScripts.OVHL.ClientRuntime.client
   5 | 	@Purpose: Client-side bootstrap & Pre-boot Cleanup
   6 | 	@Stability: STABLE
   7 | --]]
   8 |
   9 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
  10 | local Players = game:GetService("Players")
  11 |
  12 | -- [PRE-BOOT CLEANUP] Hapus sampah UI dari sesi sebelumnya/StarterGui artifacts
  13 | local p = Players.LocalPlayer
  14 | local pg = p:WaitForChild("PlayerGui", 10)
  15 | if pg then
  16 | 	-- Hapus GUI TopbarPlus yang mungkin nyangkut/duplikat
  17 | 	local zombieTopbar = pg:FindFirstChild("TopbarPlus")
  18 | 	if zombieTopbar then
  19 | 		zombieTopbar:Destroy()
  20 | 		print("🧹 [PRE-BOOT] Deleted stale TopbarPlus GUI")
  21 | 	end
  22 |
  23 | 	-- Hapus GUI HD Admin lama (biar refresh)
  24 | 	local zombieHD = pg:FindFirstChild("HDAdminGUIs")
  25 | 	if zombieHD then
  26 | 		zombieHD:Destroy()
  27 | 		print("🧹 [PRE-BOOT] Deleted stale HDAdmin GUI")
  28 | 	end
  29 | end
  30 |
  31 | local Knit = require(ReplicatedStorage.Packages.Knit)
  32 | local Bootstrap = require(ReplicatedStorage.OVHL.Core.Bootstrap)
  33 | local OVHL = Bootstrap:Initialize()
  34 | local Logger = OVHL.GetSystem("SmartLogger")
  35 |
  36 | Logger:Info("CLIENT", "🚀 Starting OVHL Client Runtime V1.1.2 (Clean Boot)")
  37 |
  38 | local Kernel = require(ReplicatedStorage.OVHL.Core.Kernel).new()
  39 | Kernel:Initialize(Logger)
  40 |
  41 | local modulesFound = Kernel:ScanModules()
  42 | Logger:Debug("CLIENT", "Pre-Knit system verification")
  43 |
  44 | local uiSystems = { "UIEngine", "UIManager", "AssetLoader" }
  45 | local uiReady = 0
  46 | for _, systemName in ipairs(uiSystems) do
  47 | 	local system = OVHL.GetSystem(systemName)
  48 | 	if system then
  49 | 		if system.Initialize then
  50 | 			system:Initialize(Logger)
  51 | 		end
  52 | 		uiReady = uiReady + 1
  53 | 		Logger:Debug("UI", "UI system ready", { system = systemName })
  54 | 	else
  55 | 		Logger:Warn("UI", "UI system not available", { system = systemName })
  56 | 	end
  57 | end
  58 |
  59 | Knit.Start()
  60 | 	:andThen(function()
  61 | 		Logger:Info("CLIENT", "Knit framework started successfully")
  62 |
  63 | 		local registeredCount = Kernel:RegisterKnitServices(Knit)
  64 | 		Kernel:RunVerification()
  65 |
  66 | 		local controllers = Knit.Controllers or {}
  67 | 		local knitControllerCount = 0
  68 |
  69 | 		for controllerName, controller in pairs(controllers) do
  70 | 			knitControllerCount = knitControllerCount + 1
  71 | 			Logger:Debug("KERNEL", "Knit controller operational", {
  72 | 				controller = controllerName,
  73 | 				type = typeof(controller),
  74 | 			})
  75 | 		end
  76 |
  77 | 		Logger:Info("CLIENT", "🎉 OVHL Client Ready", {
  78 | 			modules = modulesFound,
  79 | 			kernel = registeredCount,
  80 | 			controllers = knitControllerCount,
  81 | 			ui = uiReady .. "/" .. #uiSystems,
  82 | 		})
  83 |
  84 | 		Logger:Critical("BOOT", "🎊 CLIENT BOOT COMPLETE")
  85 | 	end)
  86 | 	:catch(function(err)
  87 | 		Logger:Critical("CLIENT", "Runtime Failed", { error = tostring(err) })
  88 |
  89 | 		pcall(function()
  90 | 			local sg = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
  91 | 			local tl = Instance.new("TextLabel", sg)
  92 | 			tl.Size = UDim2.new(1, 0, 0.1, 0)
  93 | 			tl.Text = "OVHL Error: " .. tostring(err)
  94 | 			tl.TextColor3 = Color3.new(1, 0, 0)
  95 | 		end)
  96 | 	end)
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/MinimalModule/ClientConfig.lua</strong> (1 lines, 10B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/MinimalModule/ClientConfig.lua`

```lua
   1 | return {}
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/MinimalModule/MinimalController.lua</strong> (27 lines, 1K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/MinimalModule/MinimalController.lua`

```lua
   1 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   2 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
   3 | local Knit = require(ReplicatedStorage.Packages.Knit)
   4 | local MinimalController = Knit.CreateController { Name = "MinimalController" }
   5 |
   6 | function MinimalController:KnitInit()
   7 |     self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
   8 |     self.UIManager = self.OVHL.GetSystem("UIManager")
   9 |     self.Config = self.OVHL.GetClientConfig("MinimalModule")
  10 |     self.Scope = Fusion.scoped(Fusion)
  11 |     self.IsVisible = self.Scope:Value(false)
  12 | end
  13 |
  14 | function MinimalController:KnitStart()
  15 |     local View = require(script.Parent.Views.ClientView)
  16 |     View.Create(self.Config, { IsVisible = self.IsVisible })
  17 |     self.UIManager:RegisterTopbar("MinimalModule", self.Config.Topbar)
  18 |
  19 |     -- [UPDATE] Gunakan state dari event
  20 |     self.UIManager.OnTopbarClick:Connect(function(id, state)
  21 |         if id == "MinimalModule" then
  22 |             -- State Synchronization: UI ngikutin Icon
  23 |             self.IsVisible:set(state)
  24 |         end
  25 |     end)
  26 | end
  27 | return MinimalController
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/MinimalModule/Views/ClientView.lua</strong> (63 lines, 2K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/MinimalModule/Views/ClientView.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.0
   3 |     @Component: ClientView
   4 |     @Path: src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/MinimalModule/Views/ClientView.lua
   5 |     @Purpose: Fusion UI Constructor
   6 |     @Created: Wed, Nov 19, 2025 09:10:48
   7 | --]]
   8 |
   9 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
  10 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
  11 |
  12 | local New, Children, OnEvent = Fusion.New, Fusion.Children, Fusion.OnEvent
  13 |
  14 | local ClientView = {}
  15 |
  16 | function ClientView.Create(config, props)
  17 |     local scope = Fusion.scoped(Fusion)
  18 |
  19 |     local screen = scope:New "ScreenGui" {
  20 |         Name = "MinimalFusionScreen",
  21 |         Parent = game.Players.LocalPlayer.PlayerGui,
  22 |         Enabled = props.IsVisible,
  23 |
  24 |         [Children] = {
  25 |             scope:New "Frame" {
  26 |                 Size = UDim2.fromOffset(250, 150),
  27 |                 Position = UDim2.fromScale(0.5, 0.5),
  28 |                 AnchorPoint = Vector2.new(0.5, 0.5),
  29 |                 BackgroundColor3 = Color3.fromRGB(40, 40, 40),
  30 |
  31 |                 [Children] = {
  32 |                     scope:New "UICorner" { CornerRadius = UDim.new(0, 8) },
  33 |
  34 |                     scope:New "TextLabel" {
  35 |                         Text = "👋 " .. (config.Topbar.Text or "HELLO"),
  36 |                         Size = UDim2.new(1, 0, 0.5, 0),
  37 |                         BackgroundTransparency = 1,
  38 |                         TextColor3 = Color3.new(1,1,1),
  39 |                         Font = Enum.Font.GothamBold
  40 |                     },
  41 |
  42 |                     scope:New "TextButton" {
  43 |                         Text = "CLOSE",
  44 |                         Size = UDim2.new(0.8, 0, 0.3, 0),
  45 |                         Position = UDim2.fromScale(0.1, 0.6),
  46 |                         BackgroundColor3 = Color3.fromRGB(200, 60, 60),
  47 |                         TextColor3 = Color3.new(1,1,1),
  48 |
  49 |                         [OnEvent "Activated"] = function()
  50 |                             props.IsVisible:set(false)
  51 |                         end,
  52 |
  53 |                         [Children] = { scope:New "UICorner" { CornerRadius = UDim.new(0, 4) } }
  54 |                     }
  55 |                 }
  56 |             }
  57 |         }
  58 |     }
  59 |
  60 |     return screen, scope
  61 | end
  62 |
  63 | return ClientView
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/ClientConfig.lua</strong> (1 lines, 10B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/ClientConfig.lua`

```lua
   1 | return {}
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/ShopController.lua</strong> (70 lines, 2K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/ShopController.lua`

```lua
   1 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   2 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
   3 | local Knit = require(ReplicatedStorage.Packages.Knit)
   4 | local ShopController = Knit.CreateController { Name = "ShopController" }
   5 |
   6 | function ShopController:KnitInit()
   7 |     self.OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
   8 |     self.UIManager = self.OVHL.GetSystem("UIManager")
   9 |     self.Config = self.OVHL.GetClientConfig("PrototypeShop")
  10 |     self.Logger = self.OVHL.GetSystem("SmartLogger")
  11 |     self.Scope = Fusion.scoped(Fusion)
  12 |     self.IsVisible = self.Scope:Value(false)
  13 |     self.UseFallback = false
  14 | end
  15 |
  16 | function ShopController:KnitStart()
  17 |     self.Service = Knit.GetService("PrototypeShopService")
  18 |     local nativeUI, screenInstance = self.UIManager:ScanNativeUI(self.Config.UI.TargetName, self.Config.UI.Components)
  19 |
  20 |     if nativeUI then
  21 |         self.Logger:Info("SHOP", "✅ Native UI Found")
  22 |         self.NativeUI = nativeUI
  23 |         self.UIManager:RegisterScreen("ShopMain", screenInstance)
  24 |         self:_bindNativeEvents()
  25 |     else
  26 |         self.Logger:Warn("SHOP", "⚠️ Fallback Triggered")
  27 |         self.UseFallback = true
  28 |         local View = require(script.Parent.Views.ClientView)
  29 |         View.CreateFallback(self.Config, {
  30 |             IsVisible = self.IsVisible,
  31 |             OnBuy = function() self:_requestBuy() end
  32 |         })
  33 |     end
  34 |
  35 |     self.UIManager:RegisterTopbar("PrototypeShop", self.Config.Topbar)
  36 |
  37 |     -- [UPDATE] Gunakan state dari event
  38 |     self.UIManager.OnTopbarClick:Connect(function(id, state)
  39 |         if id == "PrototypeShop" then
  40 |             self:_setShopState(state)
  41 |         end
  42 |     end)
  43 | end
  44 |
  45 | function ShopController:_setShopState(state)
  46 |     if self.UseFallback then
  47 |         self.IsVisible:set(state)
  48 |     else
  49 |         self.UIManager:ToggleScreen("ShopMain", state)
  50 |     end
  51 | end
  52 |
  53 | function ShopController:_requestBuy()
  54 |     self.Service:BuyItem({ itemId = "Sword", amount = 1 })
  55 | end
  56 |
  57 | function ShopController:_bindNativeEvents()
  58 |     if self.NativeUI.BuyButton then
  59 |         self.NativeUI.BuyButton.MouseButton1Click:Connect(function() self:_requestBuy() end)
  60 |     end
  61 |     if self.NativeUI.CloseButton then
  62 |         self.NativeUI.CloseButton.MouseButton1Click:Connect(function()
  63 |             -- Close cuma matikan visual, icon state mungkin perlu diupdate manual
  64 |             -- Tapi TopbarPlus usually handles toggle off if clicked again.
  65 |             -- Untuk simplifikasi, kita sembunyikan UI saja.
  66 |             self:_setShopState(false)
  67 |         end)
  68 |     end
  69 | end
  70 | return ShopController
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/Views/ClientView.lua</strong> (79 lines, 3K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/Views/ClientView.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.0
   3 |     @Component: ClientView
   4 |     @Path: src/StarterPlayer/StarterPlayerScripts/OVHL/Modules/PrototypeShop/Views/ClientView.lua
   5 |     @Purpose: Fusion Fallback View for Shop
   6 |     @Created: Wed, Nov 19, 2025 09:10:48
   7 | --]]
   8 |
   9 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
  10 | local Fusion = require(ReplicatedStorage.Packages.Fusion)
  11 | local New, Children, OnEvent = Fusion.New, Fusion.Children, Fusion.OnEvent
  12 |
  13 | local ClientView = {}
  14 |
  15 | -- View ini dipanggil jika Native Scanner GAGAL menemukan UI di PlayerGui
  16 | function ClientView.CreateFallback(config, props)
  17 |     print("⚠️ [SHOP VIEW] Activiting Fusion Fallback UI (Native Missing)")
  18 |
  19 |     local scope = Fusion.scoped(Fusion)
  20 |
  21 |     local screen = scope:New "ScreenGui" {
  22 |         Name = "ShopFallbackScreen",
  23 |         Parent = game.Players.LocalPlayer.PlayerGui,
  24 |         Enabled = props.IsVisible,
  25 |
  26 |         [Children] = {
  27 |             scope:New "Frame" {
  28 |                 Size = UDim2.fromOffset(400, 300),
  29 |                 Position = UDim2.fromScale(0.5, 0.5),
  30 |                 AnchorPoint = Vector2.new(0.5, 0.5),
  31 |                 BackgroundColor3 = Color3.fromRGB(40, 30, 60), -- Warna Ungu (Beda dari Native Merah)
  32 |
  33 |                 [Children] = {
  34 |                     scope:New "UICorner" { CornerRadius = UDim.new(0, 10) },
  35 |
  36 |                     -- Header
  37 |                     scope:New "TextLabel" {
  38 |                         Text = "⚠️ FALLBACK UI: " .. (config.Topbar.Text or "SHOP"),
  39 |                         Size = UDim2.new(1, 0, 0, 50),
  40 |                         BackgroundTransparency = 1,
  41 |                         TextColor3 = Color3.new(1, 0.5, 0.5),
  42 |                         Font = Enum.Font.GothamBlack
  43 |                     },
  44 |
  45 |                     -- Buy Button
  46 |                     scope:New "TextButton" {
  47 |                         Text = "BUY SWORD (FALLBACK MODE)",
  48 |                         Size = UDim2.new(0.8, 0, 0, 50),
  49 |                         Position = UDim2.fromScale(0.1, 0.4),
  50 |                         BackgroundColor3 = Color3.fromRGB(100, 100, 255),
  51 |                         TextColor3 = Color3.new(1,1,1),
  52 |
  53 |                         [OnEvent "Activated"] = function()
  54 |                             if props.OnBuy then props.OnBuy() end
  55 |                         end,
  56 |                         [Children] = { scope:New "UICorner" { CornerRadius = UDim.new(0,6) } }
  57 |                     },
  58 |
  59 |                     -- Close Button
  60 |                     scope:New "TextButton" {
  61 |                         Text = "CLOSE",
  62 |                         Size = UDim2.new(0.8, 0, 0, 40),
  63 |                         Position = UDim2.fromScale(0.1, 0.8),
  64 |                         BackgroundColor3 = Color3.fromRGB(255, 50, 50),
  65 |                         TextColor3 = Color3.new(1,1,1),
  66 |
  67 |                         [OnEvent "Activated"] = function()
  68 |                             props.IsVisible:set(false)
  69 |                         end,
  70 |                         [Children] = { scope:New "UICorner" { CornerRadius = UDim.new(0,6) } }
  71 |                     }
  72 |                 }
  73 |             }
  74 |         }
  75 |     }
  76 |     return screen, scope
  77 | end
  78 |
  79 | return ClientView
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/AssetLoader.lua</strong> (192 lines, 4K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/AssetLoader.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: AssetLoader (UI)
   4 | @Path: ReplicatedStorage.OVHL.Systems.UI.AssetLoader
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | --[[
  10 | OVHL ENGINE V3.0.0 - ASSET LOADER SYSTEM
  11 | Version: 1.0.1
  12 | Path: ReplicatedStorage.OVHL.Systems.UI.AssetLoader
  13 |
  14 | FEATURES:
  15 | - Asset loading & management
  16 | - Input handling & keybinds
  17 | - Gesture recognition
  18 | - Performance optimization
  19 | --]]
  20 |
  21 | local AssetLoader = {}
  22 | AssetLoader.__index = AssetLoader
  23 |
  24 | function AssetLoader.new()
  25 |     local self = setmetatable({}, AssetLoader)
  26 |     self._logger = nil
  27 |     self._loadedAssets = {}
  28 |     self._keybinds = {}
  29 |     self._inputConnections = {}
  30 |     return self
  31 | end
  32 |
  33 | function AssetLoader:Initialize(logger)
  34 |     if not logger then
  35 |         error("AssetLoader requires logger")
  36 |     end
  37 |     self._logger = logger
  38 |
  39 |     self._logger:Info("ASSETLOADER", "Asset Loader initialized")
  40 | end
  41 |
  42 | function AssetLoader:LoadIcon(iconName, assetId)
  43 |     assert(iconName, "Icon name required")
  44 |
  45 |     if self._loadedAssets[iconName] then
  46 |         return self._loadedAssets[iconName]
  47 |     end
  48 |
  49 |     if not assetId or not string.match(assetId, "^rbxassetid://%d+$") then
  50 |         self._logger:Error("ASSETLOADER", "Invalid asset ID format", {
  51 |             icon = iconName,
  52 |             assetId = assetId
  53 |         })
  54 |         return nil
  55 |     end
  56 |
  57 |     local texture = Instance.new("ImageLabel")
  58 |     texture.Name = iconName .. "_Icon"
  59 |     texture.Image = assetId
  60 |     texture.BackgroundTransparency = 1
  61 |     texture.Size = UDim2.new(0, 32, 0, 32)
  62 |
  63 |     self._loadedAssets[iconName] = texture
  64 |
  65 |     self._logger:Debug("ASSETLOADER", "Icon loaded", {
  66 |         icon = iconName,
  67 |         assetId = assetId
  68 |     })
  69 |
  70 |     return texture
  71 | end
  72 |
  73 | function AssetLoader:PreloadAssets(assetConfig)
  74 |     if not assetConfig then
  75 |         self._logger:Warn("ASSETLOADER", "No asset config provided for preload")
  76 |         return
  77 |     end
  78 |
  79 |     local loadedCount = 0
  80 |
  81 |     if assetConfig.Icons then
  82 |         for iconName, assetId in pairs(assetConfig.Icons) do
  83 |             if self:LoadIcon(iconName, assetId) then
  84 |                 loadedCount = loadedCount + 1
  85 |             end
  86 |         end
  87 |     end
  88 |
  89 |     self._logger:Info("ASSETLOADER", "Assets preloaded", {
  90 |         total = loadedCount,
  91 |         config = assetConfig
  92 |     })
  93 | end
  94 |
  95 | function AssetLoader:GetAsset(assetName)
  96 |     return self._loadedAssets[assetName]
  97 | end
  98 |
  99 | function AssetLoader:RegisterKeybind(keyCode, callback, options)
 100 |     options = options or {}
 101 |
 102 |     if not keyCode or not typeof(keyCode) == "EnumItem" then
 103 |         self._logger:Error("ASSETLOADER", "Invalid key code", {keyCode = tostring(keyCode)})
 104 |         return false
 105 |     end
 106 |
 107 |     if self._keybinds[keyCode] then
 108 |         self._logger:Warn("ASSETLOADER", "Keybind already registered", {keyCode = tostring(keyCode)})
 109 |         return false
 110 |     end
 111 |
 112 |     self._keybinds[keyCode] = {
 113 |         callback = callback,
 114 |         options = options
 115 |     }
 116 |
 117 |     local connection
 118 |     if options.triggerOnPress ~= false then
 119 |         connection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
 120 |             if gameProcessed then return end
 121 |
 122 |             if input.KeyCode == keyCode then
 123 |                 pcall(callback, "pressed")
 124 |             end
 125 |         end)
 126 |     else
 127 |         connection = game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
 128 |             if gameProcessed then return end
 129 |
 130 |             if input.KeyCode == keyCode then
 131 |                 pcall(callback, "released")
 132 |             end
 133 |         end)
 134 |     end
 135 |
 136 |     self._inputConnections[keyCode] = connection
 137 |
 138 |     self._logger:Debug("ASSETLOADER", "Keybind registered", {
 139 |         keyCode = tostring(keyCode),
 140 |         trigger = options.triggerOnPress and "press" or "release"
 141 |     })
 142 |
 143 |     return true
 144 | end
 145 |
 146 | function AssetLoader:RegisterButtonClick(button, callback)
 147 |     if not button then
 148 |         self._logger:Error("ASSETLOADER", "Cannot register click for nil button")
 149 |         return false
 150 |     end
 151 |
 152 |     if not button:IsA("GuiButton") then
 153 |         self._logger:Error("ASSETLOADER", "Object is not a GUI button", {type = button.ClassName})
 154 |         return false
 155 |     end
 156 |
 157 |     local connection = button.MouseButton1Click:Connect(function()
 158 |         pcall(callback)
 159 |     end)
 160 |
 161 |     self._inputConnections[button] = connection
 162 |
 163 |     self._logger:Debug("ASSETLOADER", "Button click registered", {button = button.Name})
 164 |     return true
 165 | end
 166 |
 167 | function AssetLoader:Cleanup()
 168 |     for key, connection in pairs(self._inputConnections) do
 169 |         if typeof(connection) == "table" then
 170 |             for _, conn in ipairs(connection) do
 171 |                 pcall(function() conn:Disconnect() end)
 172 |             end
 173 |         else
 174 |             pcall(function() connection:Disconnect() end)
 175 |         end
 176 |     end
 177 |
 178 |     self._inputConnections = {}
 179 |     self._keybinds = {}
 180 |
 181 |     self._logger:Info("ASSETLOADER", "Service cleanup completed")
 182 | end
 183 |
 184 | return AssetLoader
 185 |
 186 | --[[
 187 | @End: AssetLoader.lua
 188 | @Version: 1.0.0
 189 | @LastUpdate: 2025-11-18
 190 | @Maintainer: OVHL Core Team
 191 | --]]
 192 |
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/AssetLoaderManifest.lua</strong> (22 lines, 423B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/AssetLoaderManifest.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: AssetLoaderManifest (UI)
   4 | @Path: ReplicatedStorage.OVHL.Systems.UI.AssetLoaderManifest
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | -- V3.2.3 (HOTFIX): Menambahkan context
  10 | return {
  11 |     name = "AssetLoader",
  12 |     dependencies = {"SmartLogger"},
  13 |     context = "Client"
  14 | }
  15 |
  16 | --[[
  17 | @End: AssetLoaderManifest.lua
  18 | @Version: 1.0.0
  19 | @LastUpdate: 2025-11-18
  20 | @Maintainer: OVHL Core Team
  21 | --]]
  22 |
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/UIEngine.lua</strong> (160 lines, 4K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/UIEngine.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: UIEngine (UI)
   4 | @Path: ReplicatedStorage.OVHL.Systems.UI.UIEngine
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | --[[
  10 | OVHL ENGINE V3.0.0 - UI ENGINE (FINAL)
  11 | Version: 1.0.1
  12 | Path: ReplicatedStorage.OVHL.Systems.UI.UIEngine
  13 | FIXES: Fusion 0.3 Event Binding & Scope Management
  14 | --]]
  15 |
  16 | local UIEngine = {}
  17 | UIEngine.__index = UIEngine
  18 |
  19 | function UIEngine.new()
  20 |     local self = setmetatable({}, UIEngine)
  21 |     self._logger = nil
  22 |     self._activeScreens = {}
  23 |     self._availableFrameworks = { FUSION = false, NATIVE = true }
  24 |
  25 |     pcall(function()
  26 |         local Fusion = require(game:GetService("ReplicatedStorage").Packages.Fusion)
  27 |         if Fusion and Fusion.scoped then
  28 |             self._availableFrameworks.FUSION = true
  29 |         end
  30 |     end)
  31 |     return self
  32 | end
  33 |
  34 | function UIEngine:Initialize(logger)
  35 |     self._logger = logger
  36 | end
  37 |
  38 | function UIEngine:CreateScreen(screenName, moduleConfig)
  39 |     local screenConfig = moduleConfig.UI.Screens[screenName]
  40 |     if not screenConfig then return nil end
  41 |
  42 |     if screenConfig.Mode == "FUSION" and self._availableFrameworks.FUSION then
  43 |         return self:_createFusionScreen(screenName)
  44 |     else
  45 |         return self:_createNativeScreen(screenName)
  46 |     end
  47 | end
  48 |
  49 | function UIEngine:_createFusionScreen(screenName)
  50 |     local Fusion = require(game:GetService("ReplicatedStorage").Packages.Fusion)
  51 |     local scope = Fusion.scoped(Fusion)
  52 |     local OnEvent = Fusion.OnEvent
  53 |
  54 |     local screenGui = scope:New "ScreenGui" {
  55 |         Name = screenName,
  56 |         Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"),
  57 |         Enabled = false,
  58 |
  59 |         [Fusion.Children] = {
  60 |             scope:New "Frame" {
  61 |                 Name = "MainFrame",
  62 |                 BackgroundColor3 = Color3.fromRGB(45, 45, 45),
  63 |                 Size = UDim2.new(0, 300, 0, 200),
  64 |                 Position = UDim2.new(0.5, -150, 0.5, -100),
  65 |
  66 |                 [Fusion.Children] = {
  67 |                     scope:New "TextLabel" {
  68 |                         Name = "Title",
  69 |                         Text = "Fusion UI: " .. screenName,
  70 |                         TextColor3 = Color3.new(1, 1, 1),
  71 |                         BackgroundTransparency = 1,
  72 |                         Size = UDim2.new(1, 0, 0, 40),
  73 |                         TextScaled = true
  74 |                     },
  75 |                     scope:New "TextButton" {
  76 |                         Name = "CloseButton",
  77 |                         Text = "Close",
  78 |                         Size = UDim2.new(0.8, 0, 0, 40),
  79 |                         Position = UDim2.new(0.1, 0, 0.7, 0),
  80 |
  81 |                         -- FIX: Using OnEvent properly with closure capture
  82 |                         [OnEvent "Activated"] = function()
  83 |                             print("🔘 Close Button Clicked via Fusion Event")
  84 |                             self:HideScreen(screenName)
  85 |                         end
  86 |                     },
  87 |                     scope:New "TextButton" {
  88 |                         Name = "ActionButton",
  89 |                         Text = "Test Action",
  90 |                         Size = UDim2.new(0.8, 0, 0, 40),
  91 |                         Position = UDim2.new(0.1, 0, 0.4, 0)
  92 |                     }
  93 |                 }
  94 |             }
  95 |         }
  96 |     }
  97 |
  98 |     -- Attach scope to instance for cleanup
  99 |     self._activeScreens[screenName] = {
 100 |         Instance = screenGui,
 101 |         Scope = scope
 102 |     }
 103 |
 104 |     return screenGui
 105 | end
 106 |
 107 | function UIEngine:_createNativeScreen(screenName)
 108 |     local sg = Instance.new("ScreenGui")
 109 |     sg.Name = screenName
 110 |     sg.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
 111 |     return sg
 112 | end
 113 |
 114 | function UIEngine:ShowScreen(screenName)
 115 |     local screenData = self._activeScreens[screenName]
 116 |     if screenData and screenData.Instance then
 117 |         screenData.Instance.Enabled = true
 118 |         return true
 119 |     end
 120 |     -- Try finding by name if not in active list (Native fallback)
 121 |     local pGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
 122 |     if pGui then
 123 |         local s = pGui:FindFirstChild(screenName)
 124 |         if s then s.Enabled = true return true end
 125 |     end
 126 |     return false
 127 | end
 128 |
 129 | function UIEngine:HideScreen(screenName)
 130 |     local screenData = self._activeScreens[screenName]
 131 |     if screenData and screenData.Instance then
 132 |         screenData.Instance.Enabled = false
 133 |         return true
 134 |     end
 135 |     -- Try finding by name
 136 |     local pGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
 137 |     if pGui then
 138 |         local s = pGui:FindFirstChild(screenName)
 139 |         if s then s.Enabled = false return true end
 140 |     end
 141 |     return false
 142 | end
 143 |
 144 | function UIEngine:GetScreen(screenName)
 145 |     return self._activeScreens[screenName]
 146 | end
 147 |
 148 | function UIEngine:GetAvailableFrameworks()
 149 |     return self._availableFrameworks
 150 | end
 151 |
 152 | return UIEngine
 153 |
 154 | --[[
 155 | @End: UIEngine.lua
 156 | @Version: 1.0.0
 157 | @LastUpdate: 2025-11-18
 158 | @Maintainer: OVHL Core Team
 159 | --]]
 160 |
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/UIEngineManifest.lua</strong> (22 lines, 427B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/UIEngineManifest.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: UIEngineManifest (UI)
   4 | @Path: ReplicatedStorage.OVHL.Systems.UI.UIEngineManifest
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | -- V3.2.3 (HOTFIX): Menambahkan context
  10 | return {
  11 |     name = "UIEngine",
  12 |     dependencies = {"SmartLogger", "ConfigLoader"},
  13 |     context = "Client"
  14 | }
  15 |
  16 | --[[
  17 | @End: UIEngineManifest.lua
  18 | @Version: 1.0.0
  19 | @LastUpdate: 2025-11-18
  20 | @Maintainer: OVHL Core Team
  21 | --]]
  22 |
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/UIManager.lua</strong> (92 lines, 3K)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/UIManager.lua`

```lua
   1 | --[[
   2 |     OVHL ENGINE V1.2.2
   3 |     @Component: UIManager
   4 |     @Update: Supports State Argument in Event Bus
   5 | --]]
   6 | local ReplicatedStorage = game:GetService("ReplicatedStorage")
   7 | local UIManager = {}
   8 | UIManager.__index = UIManager
   9 |
  10 | local function CreateSignal()
  11 |     local sig = {}
  12 |     local callbacks = {}
  13 |     function sig:Connect(fn)
  14 |         table.insert(callbacks, fn)
  15 |         return { Disconnect = function() for i,f in ipairs(callbacks) do if f == fn then table.remove(callbacks, i) end end end }
  16 |     end
  17 |     function sig:Fire(...)
  18 |         for _, fn in ipairs(callbacks) do task.spawn(fn, ...) end
  19 |     end
  20 |     return sig
  21 | end
  22 |
  23 | function UIManager.new()
  24 |     local self = setmetatable({}, UIManager)
  25 |     self._logger = nil
  26 |     self._screens = {}
  27 |     self._adapter = nil
  28 |     self._setupComplete = false
  29 |     self._scanner = nil
  30 |     self.OnTopbarClick = CreateSignal()
  31 |     return self
  32 | end
  33 |
  34 | function UIManager:Initialize(logger)
  35 |     self._logger = logger
  36 |     local OVHL = require(ReplicatedStorage.OVHL.Core.OVHL)
  37 |     self._scanner = OVHL.GetSystem("ComponentScanner")
  38 |     local success, cfg = pcall(function() return require(ReplicatedStorage.OVHL.Config.EngineConfig) end)
  39 |     self._adapterName = (success and cfg.Adapters and cfg.Adapters.Navbar) or "InternalAdapter"
  40 |     self._logger:Info("UIMANAGER", "Initialized V1.2.2 (State Sync)")
  41 | end
  42 |
  43 | function UIManager:Start()
  44 |     if self._setupComplete then return end
  45 |     self._setupComplete = true
  46 |     local folder = ReplicatedStorage.OVHL.Systems.Adapters.Navbar
  47 |     local mod = folder:FindFirstChild(self._adapterName) or folder:FindFirstChild("InternalAdapter")
  48 |     if mod then
  49 |         local cls = require(mod)
  50 |         self._adapter = cls.new()
  51 |         if self._adapter.Initialize then self._adapter:Initialize(self._logger) end
  52 |         if self._adapter.SetClickHandler then
  53 |             -- [UPDATE] Terima 2 argumen: ID dan State
  54 |             self._adapter:SetClickHandler(function(buttonId, state)
  55 |                 self._logger:Debug("UIMANAGER", "📣 State Change", {id=buttonId, active=state})
  56 |                 self.OnTopbarClick:Fire(buttonId, state)
  57 |             end)
  58 |         end
  59 |     end
  60 | end
  61 |
  62 | function UIManager:RegisterTopbar(moduleId, config)
  63 |     if not self._adapter then return false end
  64 |     if not config or not config.Enabled then return false end
  65 |     return self._adapter:AddButton(moduleId, config)
  66 | end
  67 |
  68 | function UIManager:RegisterScreen(name, instance) self._screens[name] = { Instance = instance, Enabled = false } end
  69 |
  70 | -- [UPDATE] Toggle sekarang menerima paksaan state (forceState)
  71 | function UIManager:ToggleScreen(name, forceState)
  72 |     local s = self._screens[name]
  73 |     if s and s.Instance then
  74 |         if forceState ~= nil then
  75 |             s.Instance.Enabled = forceState
  76 |         else
  77 |             s.Instance.Enabled = not s.Instance.Enabled
  78 |         end
  79 |         s.Enabled = s.Instance.Enabled
  80 |         return s.Enabled
  81 |     end
  82 |     return false
  83 | end
  84 |
  85 | function UIManager:ScanNativeUI(screenName, componentMap)
  86 |     local pGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
  87 |     local screen = pGui:WaitForChild(screenName, 5)
  88 |     if not screen then return nil, "Screen not found" end
  89 |     if self._scanner then return self._scanner:Scan(screen, componentMap), screen else return nil, "Scanner missing" end
  90 | end
  91 |
  92 | return UIManager
```

</details>

<details>
<summary><strong>🌙 src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/UIManagerManifest.lua</strong> (22 lines, 427B)</summary>

**Full Path:** `src/StarterPlayer/StarterPlayerScripts/OVHL/Systems/UI/UIManagerManifest.lua`

```lua
   1 | --[[
   2 | OVHL ENGINE V1.0.0
   3 | @Component: UIManagerManifest (UI)
   4 | @Path: ReplicatedStorage.OVHL.Systems.UI.UIManagerManifest
   5 | @Purpose: [TODO: Add purpose]
   6 | @Stability: STABLE
   7 | --]]
   8 |
   9 | -- V3.2.3 (HOTFIX): Menambahkan context
  10 | return {
  11 |     name = "UIManager",
  12 |     dependencies = {"SmartLogger", "UIEngine"},
  13 |     context = "Client"
  14 | }
  15 |
  16 | --[[
  17 | @End: UIManagerManifest.lua
  18 | @Version: 1.0.0
  19 | @LastUpdate: 2025-11-18
  20 | @Maintainer: OVHL Core Team
  21 | --]]
  22 |
```

</details>

### 📦 tests/

---

## 🎯 AI Quick Reference

### Common Analysis Tasks:

1. **🐛 Debug Error**

   - Locate the error message in the relevant file (use line numbers!)
   - Check surrounding context and dependencies
   - Suggest fixes with specific line numbers

2. **📝 Code Review**

   - Check for best practices and patterns
   - Identify potential bugs or improvements
   - Suggest refactoring opportunities

3. **🗂️ Architecture Analysis**

   - Review module organization
   - Check separation of concerns (client/server/shared)
   - Validate dependency graphs and race conditions

4. **📚 Documentation**
   - Identify undocumented functions
   - Suggest comments for complex logic
   - Generate API documentation

### File Organization:

- **src/StarterPlayer/StarterPlayerScripts/OVHL/**: Client-side code (runs on player's game client)
- **src/ServerScriptService/OVHL/**: Server-side code (runs on game server)
- **src/ReplicatedStorage/OVHL/**: Shared code (accessible by both client and server)
- **tests/**: Test files for automated testing

---

### OUTPUT STUDIO

```text
  09:39:52.723  Requiring asset 3239236979.
Callstack:
ServerScriptService.HD Admin.Core.MainModule, line 1
  -  Server - MainModule:1
  09:39:52.727  🐛 LOGGER - SmartLogger initialized {model=DEBUG}  -  Server - SmartLogger:45
  09:39:52.727  ℹ️ SYSTEMREGISTRY - System Registry V.1.0.1 (4-Phase Lifecycle) initialized  -  Server - SmartLogger:91
  09:39:52.728  ℹ️ BOOTSTRAP - Initializing OVHL V.1.1.0 (Server) - Architecture Split  -  Server - SmartLogger:91
  09:39:52.728  ℹ️ SYSTEMREGISTRY - Memulai Fase 1 (Initialize)...  -  Server - SmartLogger:91
  09:39:52.728  ℹ️ CONFIG - ConfigLoader Ready V1.2.0 (Deep Merge Fixed)  -  Server - SmartLogger:91
  09:39:52.728  🐛 LOGGER - SmartLogger initialized {model=DEBUG} (x2)  -  Server - SmartLogger:45
  09:39:52.732  ℹ️ PERMISSION - Init PermissionCore (Server) {adapter=HDAdminAdapter}  -  Server - SmartLogger:91
  09:39:52.732  ℹ️ PERMISSION - HDAdminAdapter: Folder Detected. Initializing Event Listeners...  -  Server - SmartLogger:91
  09:39:52.732  ℹ️ PERMISSION - ✅ Adapter READY: HDAdminAdapter  -  Server - SmartLogger:91
  09:39:52.733  ℹ️ NOTIFICATION - Notification Service Ready (Server API).  -  Server - SmartLogger:91
  09:39:52.733  ℹ️ INPUTVALIDATOR - Input Validator initialized  -  Server - SmartLogger:91
  09:39:52.733  ℹ️ SYSTEMREGISTRY - Memulai Fase 3 (Start)...  -  Server - SmartLogger:91
  09:39:52.733  🐛 SYSTEMREGISTRY - Started (Pasif) {system=ConfigLoader}  -  Server - SmartLogger:91
  09:39:52.733  🐛 SYSTEMREGISTRY - Started (Pasif) {system=SmartLogger}  -  Server - SmartLogger:91
  09:39:52.733  ℹ️ DATAMANAGER - Ready  -  Server - SmartLogger:91
  09:39:52.733  🐛 SYSTEMREGISTRY - Started (Ready) {system=DataManager}  -  Server - SmartLogger:91
  09:39:52.734  ℹ️ PLAYERMANAGER - Player Manager Ready.  -  Server - SmartLogger:91
  09:39:52.734  🐛 SYSTEMREGISTRY - Started (Ready) {system=PlayerManager}  -  Server - SmartLogger:91
  09:39:52.734  ℹ️ RATELIMITER - Rate Limiter Ready (Server Secured).  -  Server - SmartLogger:91
  09:39:52.734  🐛 SYSTEMREGISTRY - Started (Ready) {system=RateLimiter}  -  Server - SmartLogger:91
  09:39:52.734  🐛 SYSTEMREGISTRY - Started (Ready) {system=PermissionCore}  -  Server - SmartLogger:91
  09:39:52.734  ℹ️ NETWORKING - Networking Router Ready (Broadcast Enabled).  -  Server - SmartLogger:91
  09:39:52.734  🐛 SYSTEMREGISTRY - Started (Ready) {system=NetworkingRouter}  -  Server - SmartLogger:91
  09:39:52.735  🐛 SYSTEMREGISTRY - Started (Pasif) {system=NotificationService}  -  Server - SmartLogger:91
  09:39:52.735  🐛 SYSTEMREGISTRY - Started (Pasif) {system=InputValidator}  -  Server - SmartLogger:91
  09:39:52.735  ℹ️ BOOTSTRAP - Boot Complete {failed=0 started=9}  -  Server - SmartLogger:91
  09:39:52.735  ℹ️ SERVER - 🚀 Starting OVHL Server Runtime V1.2.2  -  Server - SmartLogger:91
  09:39:52.735  ℹ️ KERNEL - Kernel V.1.0.1 Initialized  -  Server - SmartLogger:91
  09:39:52.737  ℹ️ KERNEL - Modules Scanned {count=2}  -  Server - SmartLogger:91
  09:39:52.737  🐛 INPUTVALIDATOR - Schema added {schema=BuyItem}  -  Server - SmartLogger:91
  09:39:52.737  🐛 SHOP - Registered Limit {action=BuyItem max=3}  -  Server - SmartLogger:91
  09:39:52.737  ℹ️ SERVICE - MinimalService Initialized  -  Server - SmartLogger:91
  09:39:52.738  ℹ️ SERVER - Knit Started. Firewall Active (In/Out).  -  Server - SmartLogger:91
  09:39:52.808  ℹ️ PLAYERMANAGER - Player Joining... {player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:39:52.892  🐛 LOGGER - SmartLogger initialized {model=DEBUG}  -  Client - SmartLogger:45
  09:39:52.892  ℹ️ SYSTEMREGISTRY - System Registry V.1.0.1 (4-Phase Lifecycle) initialized  -  Client - SmartLogger:91
  09:39:52.892  ℹ️ BOOTSTRAP - Initializing OVHL V.1.1.0 (Client) - Architecture Split  -  Client - SmartLogger:91
  09:39:52.893  ℹ️ SYSTEMREGISTRY - Memulai Fase 1 (Initialize)...  -  Client - SmartLogger:91
  09:39:52.893  ℹ️ CONFIG - ConfigLoader Ready V1.2.0 (Deep Merge Fixed)  -  Client - SmartLogger:91
  09:39:52.893  🐛 LOGGER - SmartLogger initialized {model=DEBUG} (x2)  -  Client - SmartLogger:45
  09:39:52.893  ℹ️ PERMISSION - Init PermissionCore (Client) {adapter=HDAdminAdapter}  -  Client - SmartLogger:91
  09:39:52.894  ℹ️ PERMISSION - HDAdminAdapter (Client) Listening...  -  Client - SmartLogger:91
  09:39:52.894  ℹ️ PERMISSION - ✅ Adapter READY: HDAdminAdapter  -  Client - SmartLogger:91
  09:39:52.894  ℹ️ ASSETLOADER - Asset Loader initialized  -  Client - SmartLogger:91
  09:39:52.902  ℹ️ UIMANAGER - Initialized V1.2.2 (State Sync)  -  Client - SmartLogger:91
  09:39:52.902  ℹ️ INPUTVALIDATOR - Input Validator initialized  -  Client - SmartLogger:91
  09:39:52.902  ℹ️ SYSTEMREGISTRY - Memulai Fase 3 (Start)...  -  Client - SmartLogger:91
  09:39:52.903  🐛 SYSTEMREGISTRY - Started (Pasif) {system=ConfigLoader}  -  Client - SmartLogger:91
  09:39:52.903  🐛 SYSTEMREGISTRY - Started (Pasif) {system=SmartLogger}  -  Client - SmartLogger:91
  09:39:52.903  🐛 SYSTEMREGISTRY - Started (Ready) {system=PermissionCore}  -  Client - SmartLogger:91
  09:39:52.903  🐛 SYSTEMREGISTRY - Started (Pasif) {system=AssetLoader}  -  Client - SmartLogger:91
  09:39:52.903  🐛 SYSTEMREGISTRY - Started (Pasif) {system=UIEngine}  -  Client - SmartLogger:91
  09:39:52.910  ℹ️ NAVBAR - TopbarPlus Adapter V1.2.2 (State Sync)  -  Client - SmartLogger:91
  09:39:52.910  🐛 SYSTEMREGISTRY - Started (Ready) {system=UIManager}  -  Client - SmartLogger:91
  09:39:52.910  🐛 SYSTEMREGISTRY - Started (Pasif) {system=InputValidator}  -  Client - SmartLogger:91
  09:39:52.910  ℹ️ NETWORKING - Networking Router Ready (Broadcast Enabled).  -  Client - SmartLogger:91
  09:39:52.910  🐛 SYSTEMREGISTRY - Started (Ready) {system=NetworkingRouter}  -  Client - SmartLogger:91
  09:39:52.910  ℹ️ BOOTSTRAP - Boot Complete {failed=0 started=8}  -  Client - SmartLogger:91
  09:39:52.911  ℹ️ CLIENT - 🚀 Starting OVHL Client Runtime V1.1.2 (Clean Boot)  -  Client - SmartLogger:91
  09:39:52.911  ℹ️ KERNEL - Kernel V.1.0.1 Initialized  -  Client - SmartLogger:91
  09:39:52.911  ℹ️ KERNEL - Modules Scanned {count=2}  -  Client - SmartLogger:91
  09:39:52.911  🐛 CLIENT - Pre-Knit system verification  -  Client - SmartLogger:91
  09:39:52.911  🐛 UI - UI system ready {system=UIEngine}  -  Client - SmartLogger:91
  09:39:52.911  ℹ️ UIMANAGER - Initialized V1.2.2 (State Sync)  -  Client - SmartLogger:91
  09:39:52.911  🐛 UI - UI system ready {system=UIManager}  -  Client - SmartLogger:91
  09:39:52.912  ℹ️ ASSETLOADER - Asset Loader initialized  -  Client - SmartLogger:91
  09:39:52.912  🐛 UI - UI system ready {system=AssetLoader}  -  Client - SmartLogger:91
  09:39:52.915  ℹ️ CLIENT - Knit framework started successfully  -  Client - SmartLogger:91
  09:39:52.915  ℹ️ KERNEL - Verification Passed  -  Client - SmartLogger:91
  09:39:52.915  ℹ️ CLIENT - 🎉 OVHL Client Ready {modules=2 ui=3/3 kernel=2 controllers=0}  -  Client - SmartLogger:91
  09:39:52.915  💥 BOOT - 🎊 CLIENT BOOT COMPLETE  -  Client - SmartLogger:89
  09:39:53.915  ℹ️ DATAMANAGER - Loaded {player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:39:53.915  ℹ️ PLAYERMANAGER - Data siap. {player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:39:54.519  ℹ️ SHOP - ✅ Native UI Found  -  Client - SmartLogger:91
  09:39:56.837  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=true}  -  Client - SmartLogger:91
  09:39:57.684  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:39:57.684  💰 [SHOP SERVER] Transaction Success: sudahbapakbapak bought Sword  -  Server - PrototypeShopService:60
  09:39:57.851  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:39:57.851  💰 [SHOP SERVER] Transaction Success: sudahbapakbapak bought Sword  -  Server - PrototypeShopService:60
  09:39:58.000  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:39:58.000  💰 [SHOP SERVER] Transaction Success: sudahbapakbapak bought Sword  -  Server - PrototypeShopService:60
  09:39:58.083  ℹ️ PERMISSION - [OK] HDAdminAdapter: API Connected.  -  Server - SmartLogger:91
  09:39:58.084  ⚠️ PERMISSION - [FALLBACK] Using owner check {player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:39:58.084  ℹ️ PERMISSION - [SETUP] Scanning for HD Admin RemoteEvents...  -  Server - SmartLogger:91
  09:39:58.084  ℹ️ PERMISSION - [SETUP] Event listeners registered  -  Server - SmartLogger:91
  09:39:58.084  ℹ️ PERMISSION - [OK] HDAdminAdapter: API Connected.  -  Server - SmartLogger:91
  09:39:58.084  ℹ️ PERMISSION - [OK] Rank from event cache {rank=5 player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:39:58.084  ℹ️ PERMISSION - [OK] HDAdminAdapter: API Connected.  -  Server - SmartLogger:91
  09:39:58.118  ℹ️ PERMISSION - [CLIENT] Rank Update Received {rank=5}  -  Client - SmartLogger:91
  09:39:58.150  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:39:58.150  ⚠️ RATELIMITER - Rate limit exceeded {action=BuyItem player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:39:58.150  ❌ [SHOP SERVER] Spam Detected from sudahbapakbapak  -  Server - PrototypeShopService:55
  09:39:58.317  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:39:58.317  ⚠️ RATELIMITER - Rate limit exceeded {action=BuyItem player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:39:58.317  ❌ [SHOP SERVER] Spam Detected from sudahbapakbapak  -  Server - PrototypeShopService:55
  09:39:58.434  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:39:58.434  ⚠️ RATELIMITER - Rate limit exceeded {action=BuyItem player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:39:58.434  ❌ [SHOP SERVER] Spam Detected from sudahbapakbapak  -  Server - PrototypeShopService:55
  09:39:58.584  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:39:58.584  ⚠️ RATELIMITER - Rate limit exceeded {action=BuyItem player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:39:58.584  ❌ [SHOP SERVER] Spam Detected from sudahbapakbapak  -  Server - PrototypeShopService:55
  09:40:33.585  🐛 UIMANAGER - 📣 State Change {id=MinimalModule active=true}  -  Client - SmartLogger:91
  09:40:33.585  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=false}  -  Client - SmartLogger:91
  09:40:35.684  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=true}  -  Client - SmartLogger:91
  09:40:35.684  🐛 UIMANAGER - 📣 State Change {id=MinimalModule active=false}  -  Client - SmartLogger:91
  09:40:38.452  🐛 UIMANAGER - 📣 State Change {id=MinimalModule active=true}  -  Client - SmartLogger:91
  09:40:38.452  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=false}  -  Client - SmartLogger:91
  09:40:40.052  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=true}  -  Client - SmartLogger:91
  09:40:40.052  🐛 UIMANAGER - 📣 State Change {id=MinimalModule active=false}  -  Client - SmartLogger:91
  09:40:41.951  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=false}  -  Client - SmartLogger:91
  09:40:43.152  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=true}  -  Client - SmartLogger:91
  09:40:43.301  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=false}  -  Client - SmartLogger:91
  09:40:43.452  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=true}  -  Client - SmartLogger:91
  09:40:43.600  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=false}  -  Client - SmartLogger:91
  09:40:44.101  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=true}  -  Client - SmartLogger:91
  09:40:44.267  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=false}  -  Client - SmartLogger:91
  09:40:44.418  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=true}  -  Client - SmartLogger:91
  09:40:44.867  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=false}  -  Client - SmartLogger:91
  09:40:45.034  🐛 UIMANAGER - 📣 State Change {id=PrototypeShop active=true}  -  Client - SmartLogger:91
  09:40:46.132  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:40:46.132  💰 [SHOP SERVER] Transaction Success: sudahbapakbapak bought Sword  -  Server - PrototypeShopService:60
  09:40:46.300  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:40:46.300  💰 [SHOP SERVER] Transaction Success: sudahbapakbapak bought Sword  -  Server - PrototypeShopService:60
  09:40:46.415  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:40:46.416  💰 [SHOP SERVER] Transaction Success: sudahbapakbapak bought Sword  -  Server - PrototypeShopService:60
  09:40:46.549  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:40:46.549  ⚠️ RATELIMITER - Rate limit exceeded {action=BuyItem player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:40:46.550  ❌ [SHOP SERVER] Spam Detected from sudahbapakbapak  -  Server - PrototypeShopService:55
  09:40:46.832  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:40:46.833  ⚠️ RATELIMITER - Rate limit exceeded {action=BuyItem player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:40:46.833  ❌ [SHOP SERVER] Spam Detected from sudahbapakbapak  -  Server - PrototypeShopService:55
  09:40:47.015  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:40:47.016  ⚠️ RATELIMITER - Rate limit exceeded {action=BuyItem player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:40:47.016  ❌ [SHOP SERVER] Spam Detected from sudahbapakbapak  -  Server - PrototypeShopService:55
  09:40:47.116  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:40:47.116  ⚠️ RATELIMITER - Rate limit exceeded {action=BuyItem player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:40:47.116  ❌ [SHOP SERVER] Spam Detected from sudahbapakbapak  -  Server - PrototypeShopService:55
  09:40:47.282  🐛 INPUTVALIDATOR - Valid {schema=BuyItem}  -  Server - SmartLogger:91
  09:40:47.282  ⚠️ RATELIMITER - Rate limit exceeded {action=BuyItem player=sudahbapakbapak}  -  Server - SmartLogger:91
  09:40:47.283  ❌ [SHOP SERVER] Spam Detected from sudahbapakbapak  -  Server - PrototypeShopService:55
  09:49:52.744  🐛 RATELIMITER - Cleaned up {count=1}  -  Server - SmartLogger:91
```

_Generated by OVHL Framework ULTIMATE Snapshot Tool_

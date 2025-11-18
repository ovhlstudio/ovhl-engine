--[[
OVHL ENGINE V1.0.0
@Component: EngineConfig (Module)
@Path: ReplicatedStorage.OVHL.Config.EngineConfig
@Purpose: Global engine configuration with adapter selectors and system settings
@Stability: STABLE
--]]

return {
	-- ====================================================================
	-- ENGINE CORE BEHAVIOR
	-- ====================================================================
	DebugMode = true,
	EnableHotReload = false,
	Version = "1.0.0",

	-- ====================================================================
	-- ADAPTER SYSTEM (V1.0.1 - New)
	-- ====================================================================
	-- Selector untuk adapter implementations
	-- Change values untuk switch antara adapter berbeda
	Adapters = {
		-- Permission adapter: "InternalAdapter" atau "HDAdminAdapter"
		-- InternalAdapter: Built-in rank system (fallback)
		-- HDAdminAdapter: Bridge ke HD Admin system
		Permission = "HDAdminAdapter",

		-- Navbar adapter: "TopbarPlusAdapter" atau "InternalAdapter"
		-- TopbarPlusAdapter: TopbarPlus V3 integration
		-- InternalAdapter: Native Fusion UI navbar
		Navbar = "TopbarPlusAdapter",
	},

	-- ====================================================================
	-- PERMISSION & SECURITY SYSTEM
	-- ====================================================================
	Security = {
		-- Permission checking enabled
		PermissionCheckEnabled = true,

		-- HD Admin integration settings
		HDAdmin = {
			Enabled = true,
			AutoFallback = true, -- Fallback ke Internal jika HD Admin unavailable
			CheckInterval = 30, -- Detik, check HD Admin availability
		},

		-- Rate limiting configuration
		RateLimiting = {
			Enabled = true,
			RequestsPerMinute = 100,
			CheckInterval = 300, -- Cleanup old data setiap 5 menit
		},

		-- Input validation
		InputValidation = {
			Enabled = true,
			StrictMode = false, -- Jika true, reject data yang tidak match schema
		},
	},

	-- ====================================================================
	-- UI & NAVBAR SETTINGS
	-- ====================================================================
	UI = {
		-- Default UI rendering mode
		DefaultMode = "Auto", -- "Auto" = detect (prefer Fusion), "Fusion", "Native"
		EnableAnimations = true,
		AnimationDuration = 0.3,

		-- TopbarPlus settings
		Navbar = {
			Enabled = true,
			Position = "TopLeft", -- "TopLeft", "TopRight", "BottomLeft", "BottomRight"
			ShowPerPermission = true, -- Hide button jika user tidak punya permission
			SortByOrder = true, -- Sort buttons by Order field di config
			MaxButtons = 20, -- Max buttons di navbar
		},

		-- Screen settings
		Screens = {
			CloseButtonEnabled = true,
			FadeOutOnClose = true,
			BlockInputWhileAnimating = false,
		},
	},

	-- ====================================================================
	-- PERFORMANCE SETTINGS
	-- ====================================================================
	Performance = {
		ObjectPoolSize = 50,
		MaxNetworkRetries = 3,
		NetworkTimeout = 10,

		-- Data caching
		DataCache = {
			Enabled = true,
			CacheDuration = 300, -- Detik
		},

		-- Memory optimization
		EnableMemoryOptimization = true,
		GarbageCollectInterval = 600, -- Detik (10 menit)
	},

	-- ====================================================================
	-- LOGGING SETTINGS
	-- ====================================================================
	Logging = {
		Model = "DEBUG", -- SILENT, NORMAL, DEBUG, VERBOSE
		EnableFileLogging = false,
		EnableColors = true,

		-- Per-domain level override
		DomainLevels = {
			BOOTSTRAP = "DEBUG",
			SYSTEMREGISTRY = "DEBUG",
			DATAMANAGER = "DEBUG",
			PLAYERMANAGER = "DEBUG",
			NETWORK = "DEBUG",
			UI = "DEBUG",
			PERMISSION = "DEBUG",
			BUSINESS = "INFO",
		},

		-- Console output settings
		ShowTimestamp = true,
		ShowDomain = true,
		ShowMetadata = true,
		MaxMetadataLength = 100, -- Truncate metadata jika > ini
	},

	-- ====================================================================
	-- NETWORK & COMMUNICATION
	-- ====================================================================
	Network = {
		-- Remote events management
		RemoteFolder = "OVHL_Remotes",
		UseSecureConnection = true,

		-- Retry policy
		RetryPolicy = {
			MaxRetries = 3,
			RetryDelay = 1,
			ExponentialBackoff = true,
		},

		-- Rate limiting per route
		RouteRateLimits = {
			ClientToServer = 100,
			ServerToClient = 50,
			RequestResponse = 30,
		},
	},

	-- ====================================================================
	-- DATA PERSISTENCE
	-- ====================================================================
	DataStore = {
		Enabled = true,
		DefaultDataStoreName = "OVHL_PlayerDatav3",
		AutoSave = true,
		SaveInterval = 60, -- Detik (1 menit)
		MaxRetries = 3,
		Scope = "global",
	},

	-- ====================================================================
	-- BOOTSTRAP & KERNEL SETTINGS
	-- ====================================================================
	Bootstrap = {
		AutoScanModules = true,
		ScanInterval = 30,
		EnvironmentAware = true, -- V3.2.3: Detect Server/Client context
		ValidateManifests = true,
		FallbackToLegacy = true, -- Support V3.1.0 systems tanpa manifest
	},

	Kernel = {
		AutoScanModules = true,
		ScanInterval = 30,
		HotReloadModules = false,
		ScanDepth = 5, -- Max subfolder depth untuk scan
	},

	-- ====================================================================
	-- SYSTEM REGISTRY (4-PHASE LIFECYCLE)
	-- ====================================================================
	SystemRegistry = {
		-- Enable fase 4 (Destroy/Shutdown)
		EnableShutdownPhase = true,

		-- Timeout untuk setiap fase (detik)
		InitializeTimeout = 30,
		StartTimeout = 30,
		DestroyTimeout = 10,

		-- Log detail level
		LogPhaseTransitions = true,
	},

	-- ====================================================================
	-- FALLBACK & ERROR HANDLING
	-- ====================================================================
	Fallback = {
		EnableFallbackSystems = true,
		FallbackTimeout = 5,

		-- Fallback strategies
		Strategies = {
			Permission = "InternalAdapter", -- Fallback untuk permission
			Navbar = "InternalAdapter", -- Fallback untuk navbar
			Logger = "builtin", -- Fallback untuk logging
		},
	},

	-- ====================================================================
	-- DEVELOPMENT & DEBUG
	-- ====================================================================
	Development = {
		DebugMode = true,
		VerboseLogging = false,
		ShowSystemDependencies = false,
		ShowBootSequence = true,
		TestModeEnabled = false,

		-- Development shortcuts
		SkipPermissionChecks = false, -- DANGER: Jangan pakai di production!
		SkipRateLimiting = false, -- DANGER: Jangan pakai di production!
	},

	-- ====================================================================
	-- FEATURE FLAGS (untuk testing)
	-- ====================================================================
	FeatureFlags = {
		EnableAdapterPattern = true, -- Use adapter pattern untuk Permission/Navbar
		EnablePrototypeShop = false, -- Enable PrototypeShop test module
		EnableTestMode = false, -- Enable test-specific behavior
	},

	-- ====================================================================
	-- PRODUCTION vs DEVELOPMENT
	-- ====================================================================
	-- Override berdasarkan environment
	-- Buat copy config ini dengan Development = false untuk production

	-- Production settings (backup):
	-- DebugMode = false,
	-- Logging.Model = "NORMAL",
	-- Development.DebugMode = false,
	-- Development.VerboseLogging = false,
	-- Fallback.EnableFallbackSystems = true,
}

--[[
@End: EngineConfig.lua
@Version: 1.0.1 (Enhanced with Adapters)
@LastUpdate: 2025-11-18
@Maintainer: OVHL Core Team
--]]

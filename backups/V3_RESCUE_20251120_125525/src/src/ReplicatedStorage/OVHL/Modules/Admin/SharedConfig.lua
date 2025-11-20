return {
    Meta = { Name = "Admin", Type = "System", Version = "1.0.0" },
    Topbar = { Enabled = false }, -- Handled manually by Controller
    
    Network = {
        Route = "Admin",
        Requests = {
            SearchPlayers = { Args = {"string"}, RateLimit = {Max=10, Interval=2} },
            SetPlayerRank = { Args = {"number", "number"}, RateLimit = {Max=5, Interval=5} },
            GetOnlinePlayers = { Args = {}, RateLimit = {Max=5, Interval=10} }
        }
    }
}

--[[ @Component: PerformanceMonitor ]]
local PerformanceMonitor = {}
local stats = {}

function PerformanceMonitor.Start(label)
    stats[label] = { start = os.clock() }
end

function PerformanceMonitor.Stop(label)
    if not stats[label] then return end
    local dur = os.clock() - stats[label].start
    stats[label].duration = dur
    return dur
end

function PerformanceMonitor.Log(logger)
    local report = {}
    for k, v in pairs(stats) do
        if v.duration then
            table.insert(report, string.format("%s: %.4fms", k, v.duration * 1000))
        end
    end
    logger:Info("PERF", "Startup Metrics:\n" .. table.concat(report, "\n"))
end

return PerformanceMonitor

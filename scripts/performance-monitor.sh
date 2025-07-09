#!/bin/bash

# 🔍 Minecraft Modded Server Performance Monitor
# For 32-mod NeoForge 1.21.1 setup

echo "🚀 Starting Minecraft Modded Server Performance Monitor..."
echo "📊 Monitoring Docker container: minecraft-neoforge-modded"
echo "----------------------------------------"

# Check if container is running
if ! docker ps | grep -q "minecraft-neoforge-modded"; then
    echo "❌ Container minecraft-neoforge-modded is not running!"
    echo "💡 Start with: docker-compose up -d"
    exit 1
fi

# Create log directory
mkdir -p logs/monitoring

# Performance monitoring function
monitor_performance() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local logfile="logs/monitoring/performance-$(date '+%Y%m%d').log"
    
    # Get container stats
    local stats=$(docker stats minecraft-neoforge-modded --no-stream --format "table {{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}")
    
    echo "[$timestamp] Container Stats:" >> "$logfile"
    echo "$stats" >> "$logfile"
    echo "" >> "$logfile"
    
    # Memory usage alert
    local mem_percent=$(echo "$stats" | tail -n 1 | awk '{print $3}' | sed 's/%//')
    if (( $(echo "$mem_percent > 85" | bc -l) )); then
        echo "⚠️  [$timestamp] HIGH MEMORY WARNING: ${mem_percent}%" | tee -a "$logfile"
    fi
    
    # Check for errors in minecraft logs
    local errors=$(docker logs minecraft-neoforge-modded --since 1m 2>&1 | grep -iE "(error|exception|fatal|crash)" | wc -l)
    if [ "$errors" -gt 0 ]; then
        echo "🚨 [$timestamp] Found $errors error(s) in last minute!" | tee -a "$logfile"
        docker logs minecraft-neoforge-modded --since 1m 2>&1 | grep -iE "(error|exception|fatal|crash)" | tail -5 >> "$logfile"
    fi
}

# Check for problematic mods
check_mod_conflicts() {
    echo "🔍 Checking for mod conflicts..."
    local conflicts_log="logs/monitoring/conflicts-$(date '+%Y%m%d').log"
    
    # Look for specific conflict patterns
    docker logs minecraft-neoforge-modded 2>&1 | grep -iE "(scalable.*cats|mixin.*conflict|duplicate.*mod)" > "$conflicts_log" 2>/dev/null
    
    if [ -s "$conflicts_log" ]; then
        echo "⚠️  Potential mod conflicts detected! Check: $conflicts_log"
    else
        echo "✅ No obvious mod conflicts found"
    fi
}

# Monitor TPS and server performance
check_server_health() {
    echo "💓 Checking server health..."
    
    # Check if server is responding
    if docker exec minecraft-neoforge-modded mc-health &>/dev/null; then
        echo "✅ Server health check: PASS"
    else
        echo "❌ Server health check: FAIL"
        echo "🔧 Consider restarting: docker-compose restart"
    fi
}

# Main monitoring loop
if [ "$1" = "--watch" ]; then
    echo "👁️  Starting continuous monitoring (Ctrl+C to stop)..."
    while true; do
        clear
        echo "🎯 Minecraft Modded Server Monitor - $(date)"
        echo "========================================"
        
        monitor_performance
        check_mod_conflicts
        check_server_health
        
        echo ""
        echo "📊 Current Status:"
        docker stats minecraft-neoforge-modded --no-stream --format "CPU: {{.CPUPerc}} | Memory: {{.MemUsage}} ({{.MemPerc}})"
        
        echo ""
        echo "⏱️  Next check in 30 seconds... (Ctrl+C to stop)"
        sleep 30
    done
else
    # Single check
    monitor_performance
    check_mod_conflicts
    check_server_health
    echo ""
    echo "✅ Monitoring complete. Use --watch for continuous monitoring."
    echo "📁 Logs saved to: logs/monitoring/"
fi

# Memory optimization suggestions
echo ""
echo "💡 Memory Optimization Tips:"
echo "   - Current allocation: 6-10GB (Good for 32 mods)"
echo "   - Monitor usage: docker stats minecraft-neoforge-modded"
echo "   - If >90% usage: Consider disabling Mekanism radiation"
echo "   - For lag: Check /tps command in-game" 
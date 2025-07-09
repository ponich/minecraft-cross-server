#!/bin/bash

# Minecraft NeoForge Modded Server Start Script
# Optimized for servers with 32 mods

echo "Starting NeoForge Modded Minecraft Server..."
echo "Server with 32 mods loading..."

# Memory settings
MEMORY=${MEMORY:-4G}
MAX_MEMORY=${MAX_MEMORY:-6G}
INIT_MEMORY=${INIT_MEMORY:-2G}

# JVM Optimization flags for modded servers
JVM_OPTS=${JVM_OPTS:-"-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"}

# Additional mod-specific optimizations
MOD_OPTS="-Dfile.encoding=UTF-8 -Djava.security.egd=file:/dev/./urandom -Dfml.earlyprogresswindow=false"

# Debugging options (uncomment if needed)
# DEBUG_OPTS="-XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:gc.log"

echo "Memory Settings:"
echo "  Initial Memory: $INIT_MEMORY"
echo "  Max Memory: $MAX_MEMORY"
echo "  Target Memory: $MEMORY"

echo "JVM Options: $JVM_OPTS"
echo "Mod Options: $MOD_OPTS"

# Start the server
exec java -Xms$INIT_MEMORY -Xmx$MAX_MEMORY $JVM_OPTS $MOD_OPTS -jar /opt/minecraft/server.jar nogui

echo "Server stopped." 
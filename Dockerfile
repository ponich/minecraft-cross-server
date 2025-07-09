FROM itzg/minecraft-server:java21

# Set maintainer information
LABEL maintainer="minecraft-modded-server"
LABEL description="NeoForge Minecraft Server with 32 custom mods"

# Set environment variables for NeoForge
ENV TYPE=NEOFORGE \
    VERSION=1.21.1 \
    NEOFORGE_VERSION=21.1.169 \
    EULA=TRUE \
    MEMORY=4G \
    MAX_MEMORY=6G \
    INIT_MEMORY=2G

# Create mods directory
RUN mkdir -p /data/mods /data/config

# Copy mods (will be mounted as volume in production)
COPY mods/*.jar /data/mods/

# Copy configuration files if they exist
COPY config/ /data/config/

# Copy custom scripts
COPY scripts/ /scripts/

# Make scripts executable
RUN find /scripts -name "*.sh" -exec chmod +x {} \;

# Set proper permissions
RUN chown -R minecraft:minecraft /data /scripts

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD mc-health

# Expose Minecraft port
EXPOSE 25565

# Switch to minecraft user
USER minecraft

# Set working directory
WORKDIR /data 
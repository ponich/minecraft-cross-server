# NeoForge Modded Minecraft Server

A fully containerized Minecraft server running **NeoForge 1.21.1** with **35 carefully selected mods** for an enhanced gaming experience.

## 🎮 Server Features

- **NeoForge 1.21.1** (build 21.1.169)
- **35 Performance & Content Mods** pre-installed
- **Optimized JVM settings** for modded servers
- **Docker Compose** for easy deployment
- **Persistent data** with Docker volumes
- **Health checks** and automatic restarts
- **Performance monitoring** ready

## 📦 Installed Mods

The server includes 35 mods across different categories:

### 🔧 Core & Performance
- **NeoForge** - Mod loader framework
- **FerriteCore** - Memory optimization
- **Lithium** - Server performance optimization
- **Modern Fix** - Compatibility and performance fixes
- **ServerCore** - Server-side optimizations
- **Sodium** & **Sodium Extra** - Rendering optimizations

### ⚡ Technology & Machinery
- **Mekanism** (Core + Additions + Generators + Tools + Extras) - Advanced machinery and automation
- **Industrial Foregoing** - Automated farming and processing
- **Additional Enchanted Miner** - Advanced mining equipment

### 🌟 Adventure & Magic
- **Aether** - New dimension with floating islands
- **Iron's Spells 'n Spellbooks** - Magic system and spells
- **ScalableCatsForce** - Pet system enhancements

### 🎯 Quality of Life
- **JEI (Just Enough Items)** - Recipe viewer and item management
- **JER (Just Enough Resources)** - Resource information
- **Jade** - Advanced tooltips (WAILA/HWYLA successor)
- **Xaero's Minimap** & **World Map** - Navigation tools
- **Supplementaries** - Decorative blocks and utilities
- **Disenchanting Table** - Remove enchantments from items
- **Bed Respawn** - Improved bed respawn mechanics

### 🎨 Visual & UI
- **Curios** & **Accessories** - Equipment slots system
- **GeckoLib** - Animation library
- **Player Animation Lib** - Enhanced player animations
- **Cloth Config** - Configuration API

### 🔌 Library & Compatibility
- **Forgified Fabric API** - Fabric mod compatibility
- **OWO Lib** - Library for modern UI
- **Moonlight** - Utility library
- **Titanium** - Framework library
- **MonoLib** - Shared library for multiple mods

## 🚀 Quick Start

### Prerequisites
- **Docker** & **Docker Compose** installed
- **At least 6GB RAM** available for the server
- **Port 25565** available


### 1. Build and Start
```bash
# Build the server image
docker-compose build

# Start the server
docker-compose up -d

# View logs
docker-compose logs -f minecraft-server
```

### 2. First Time Setup
The server will automatically:
- Download NeoForge 1.21.1
- Load all 32 mods
- Generate world data
- Create configuration files

**First startup takes 3-5 minutes** due to mod initialization.

### 3. Connect to Server
- **Server Address**: `localhost:25565` (or your server's IP)
- **Version**: Minecraft 1.21.1 with NeoForge
- **Required Client Mods**: Install the same mods on your client

## ⚙️ Configuration

### Memory Settings
Edit `docker-compose.yml` to adjust memory allocation:
```yaml
environment:
  - MEMORY=4G        # Target memory
  - MAX_MEMORY=6G    # Maximum memory limit
  - INIT_MEMORY=2G   # Initial memory
```

### Server Properties
Modify `server.properties` for game settings:
- `max-players=20` - Maximum players
- `difficulty=2` - Game difficulty (0-3)
- `view-distance=10` - Render distance
- `pvp=true` - PvP enabled/disabled

### Advanced JVM Tuning
Custom JVM flags in `docker-compose.yml`:
```yaml
- JVM_OPTS=-XX:+UseG1GC -XX:MaxGCPauseMillis=200 [...]
```

## 🗂️ Directory Structure

```
repo/
├── docker-compose.yml    # Main compose file
├── Dockerfile           # Custom server image
├── server.properties    # Server configuration
├── eula.txt            # EULA agreement
├── mods/               # Server mods (35 files) - NOT tracked in Git
├── config/             # Mod configurations
├── world/              # World data (persistent) - NOT tracked in Git
├── logs/               # Server logs - NOT tracked in Git
├── scripts/            # Startup scripts
├── .gitignore          # Git ignore rules (excludes mods, world, logs)
├── .gitattributes      # Git attributes for proper file handling
├── .dockerignore       # Docker ignore rules
├── README.md           # This documentation
└── MODS_SETUP.md       # Detailed mod setup instructions
```

### 📝 Git Configuration

The project includes proper Git configuration:

- **`.gitignore`**: Excludes large binary files (mods), runtime data (world, logs), and temporary files
- **`.gitattributes`**: Ensures proper handling of text vs binary files and line endings
- **Mods not tracked**: The `mods/` directory with 35 jar files is excluded from Git - see `MODS_SETUP.md`

## 🔧 Management Commands

### Server Control
```bash
# Start server
docker-compose up -d

# Stop server
docker-compose down

# Restart server
docker-compose restart

# View real-time logs
docker-compose logs -f minecraft-server

# Execute server commands
docker-compose exec minecraft-server rcon-cli
```

### Backup & Restore
```bash
# Backup world data
tar -czf world-backup-$(date +%Y%m%d).tar.gz world/

# Backup full server
tar -czf server-backup-$(date +%Y%m%d).tar.gz world/ config/ logs/
```

### Updates
```bash
# Rebuild with new mods/configs
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Server Wipe
```bash
# Interactive mode (asks for confirmation)
./scripts/wipe-server.sh

# Force mode (no questions, cleans logs automatically)
./scripts/wipe-server.sh --force
./scripts/wipe-server.sh --yes
./scripts/wipe-server.sh -f

# Force mode but keep logs
./scripts/wipe-server.sh --force --no-logs

# Show help
./scripts/wipe-server.sh --help
```

**What it does:**
- Stops the running server container
- Deletes ALL world data (world/, world_nether/, world_the_end/)
- Cleans server-side world directories
- Sets proper permissions (777) on world, config, logs directories
- Optional: Clean server logs (interactive) or automatic (force mode)

**⚠️ Warning**: The wipe script will completely destroy your world! Always backup before running.

### Automatic Backups
```bash
# Start backup service (included in docker-compose)
docker-compose up -d backup

# Manual backup trigger
docker-compose exec backup backup now

# Check backup logs
docker-compose logs backup
```

**Backup Features:**
- **Automatic schedule**: Every 12 hours (06:00 and 18:00)
- **Safe coordination**: Uses RCON to pause server during backup
- **Retention**: Keeps backups for 14 days (configurable)
- **Compression**: tar.gz format for space efficiency
- **Location**: `./backups/` directory

### RCON Web Admin
Access the web-based server administration interface:

**URL**: http://localhost:4326  
**Username**: admin  
**Password**: Set in `.env` file (`MINECRAFT_WEB_ADMIN_PASSWORD`)

**Features:**
- Execute server commands remotely
- View server console output
- Real-time command execution
- Secure web interface

## 📊 Performance Monitoring

### Health Checks
The server includes automatic health monitoring:
- **Startup grace period**: 5 minutes
- **Check interval**: 5 seconds
- **Failure threshold**: 3 retries

### Resource Monitoring
```bash
# Monitor container resources
docker stats minecraft-neoforge-modded

# Check Java heap usage
docker-compose exec minecraft-server jmap -heap 1
```

## 📊 Stability Analysis

### Overall Rating: **7.5/10** ⭐⭐⭐⭐⭐⭐⭐⭐

This modpack has been **professionally analyzed** for stability and performance. See `STABILITY_REPORT.md` for detailed analysis.

#### ✅ **Strengths**
- **Optimized memory allocation**: 6-10GB configuration
- **Performance mods**: ModernFix, FerriteCore, Lithium stack
- **Version compatibility**: All mods tested with NeoForge 21.1.169
- **Professional containerization** with health checks

#### ⚠️ **Watch Points**
- **ScalableCatsForce** (16MB) - monitor for stability issues
- **Magic mod conflicts** - Iron's Spellbooks vs Aether systems
- **Memory usage** - 35 mods require careful monitoring
- **Mekanism radiation** - can impact performance (configurable)

#### 🔧 **Performance Monitoring**
Use the included monitoring script:
```bash
# Single check
./scripts/performance-monitor.sh

# Continuous monitoring
./scripts/performance-monitor.sh --watch
```

#### 📈 **Expected Performance**
- **TPS**: 18-20 (excellent)
- **Memory**: 60-80% utilization
- **Players**: 15-20 concurrent
- **Startup**: ~2 minutes

## 🚨 Troubleshooting

### Common Issues

**Server won't start:**
- Check available memory (need 6GB+)
- Verify port 25565 is available
- Review logs: `docker-compose logs minecraft-server`

**Mods not loading:**
- Ensure all mods are NeoForge 1.21.1 compatible
- Check for mod conflicts in logs
- Verify mod files are not corrupted

**Connection issues:**
- Check firewall settings (port 25565)
- Verify clients have same mod versions
- Confirm server is fully started (check logs)

**Performance problems:**
- Increase memory allocation
- Tune JVM flags for your hardware
- Monitor with `docker stats`

### Log Analysis
```bash
# Search for errors
docker-compose logs minecraft-server | grep ERROR

# Monitor mod loading
docker-compose logs minecraft-server | grep "Loading mod"

# Check performance warnings
docker-compose logs minecraft-server | grep "Can't keep up"
```

## 🔒 Security Notes

- Server runs in **online mode** by default (authentication required)
- **Whitelist disabled** - enable in `server.properties` if needed
- **RCON disabled** - enable with strong password if remote admin needed
- **Regular backups recommended** for world data

## 🤝 Support

For issues with:
- **Server setup**: Check this README and logs
- **Mod conflicts**: Review mod compatibility
- **Performance**: Adjust memory and JVM settings
- **Updates**: Rebuild container with new versions

## 📄 License

This server configuration is provided as-is for educational and personal use. Please respect individual mod licenses and Minecraft EULA.

---

**Happy crafting! 🎮⛏️** 
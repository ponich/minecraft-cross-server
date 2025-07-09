# NeoForge Modded Minecraft Server

A fully containerized Minecraft server running **NeoForge 1.21.1** with **32 carefully selected mods** for an enhanced gaming experience.

## 🎮 Server Features

- **NeoForge 1.21.1** (build 21.1.169)
- **32 Performance & Content Mods** pre-installed
- **Optimized JVM settings** for modded servers
- **Docker Compose** for easy deployment
- **Persistent data** with Docker volumes
- **Health checks** and automatic restarts
- **Performance monitoring** ready

## 📦 Installed Mods

The server includes 32 mods across different categories:

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

## 🚀 Quick Start

### Prerequisites
- **Docker** & **Docker Compose** installed
- **At least 6GB RAM** available for the server
- **Port 25565** available

### 1. Clone and Setup Mods
```bash
# Navigate to project directory
cd repo

# ⚠️ IMPORTANT: Add mods (not tracked in Git)
# Copy 32 mod files to mods/ directory
cp "../моды на сервер"/*.jar mods/

# Verify all mods are present
ls mods/*.jar | wc -l  # Should be 32

# See MODS_SETUP.md for detailed instructions
```

### 2. Build and Start
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
├── mods/               # Server mods (32 files) - NOT tracked in Git
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
- **Mods not tracked**: The `mods/` directory with 32 jar files is excluded from Git - see `MODS_SETUP.md`

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
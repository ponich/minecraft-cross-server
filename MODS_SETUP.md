# Mods Setup Instructions

Since mods are large binary files (*.jar), they are excluded from Git tracking via `.gitignore`. Follow these instructions to set up mods for development and deployment.

## 📦 Required Mods (32 total)

The server requires exactly 32 mods for **NeoForge 1.21.1**. All mods must be compatible with **NeoForge build 21.1.169**.

### 🔧 Core & Performance Mods
- `accessories-neoforge-1.1.0-beta.43+1.21.1.jar`
- `ferritecore-7.0.2-neoforge.jar`
- `lithium-neoforge-0.15.0+mc1.21.1.jar`
- `modernfix-neoforge-5.24.1+mc1.21.1.jar`
- `servercore-neoforge-1.5.10+1.21.1.jar`
- `sodium-neoforge-0.6.13+mc1.21.1.jar`
- `sodium-extra-neoforge-0.6.0+mc1.21.1.jar`

### ⚡ Technology & Machinery
- `Mekanism-1.21.1-10.7.14.79.jar`
- `MekanismAdditions-1.21.1-10.7.14.79.jar`
- `MekanismGenerators-1.21.1-10.7.14.79.jar`
- `MekanismTools-1.21.1-10.7.14.79.jar`
- `mekanism_extras-1.21.1-1.2.2.jar`
- `industrialforegoing-1.21-3.6.34.jar`
- `AdditionalEnchantedMiner-1.21.1-neoforge-21.1.130.jar`

### 🌟 Adventure & Magic
- `aether-1.21.1-1.5.8-neoforge.jar`
- `irons_spellbooks-1.21.1-3.13.0.jar`
- `ScalableCatsForce-NeoForge-3.7.1-build-11-with-library.jar`

### 🎯 Quality of Life
- `jei-1.21.1-neoforge-19.21.2.313.jar`
- `JustEnoughResources-NeoForge-1.21.1-1.6.0.17.jar`
- `JustEnoughMekanismMultiblocks-1.21.1-7.7.jar`
- `Jade-1.21.1-NeoForge-15.10.2.jar`
- `Xaeros_Minimap_25.2.6_NeoForge_1.21.jar`
- `XaerosWorldMap_1.39.9_NeoForge_1.21.jar`
- `supplementaries-1.21-3.3.4-neoforge.jar`

### 🎨 Visual & UI
- `curios-neoforge-9.0.15+1.21.1.jar`
- `geckolib-neoforge-1.21.1-4.7.6.jar`
- `player-animation-lib-forge-2.0.1+1.21.1.jar`
- `cloth-config-15.0.140-neoforge-1.21.1.jar`

### 🔌 Libraries & Compatibility
- `forgified-fabric-api-0.115.6+2.1.1+1.21.1.jar`
- `owo-lib-neoforge-0.12.15.1-beta.6+1.21.jar`
- `moonlight-1.21-2.19.5-neoforge.jar`
- `titanium-1.21-4.0.37.jar`

## 🚀 Setup Instructions

### For Development

1. **Create mods directory** (if not exists):
   ```bash
   mkdir -p mods/
   ```

2. **Copy mods from source**:
   ```bash
   # From parent directory with mod files
   cp "../моды на сервер"/*.jar mods/
   
   # Or manually download and place 32 jar files in mods/
   ```

3. **Verify mod count**:
   ```bash
   ls mods/*.jar | wc -l
   # Should output: 32
   ```

### For Production/CI

Create a script or use Docker build args to fetch mods:

```dockerfile
# Example: Download from mod repository
RUN wget -O mods/mod1.jar "https://your-mod-repo/mod1.jar"
# ... repeat for all mods
```

### For Docker Compose

Mods are copied during image build. Make sure they exist in `mods/` before running:

```bash
docker-compose build --no-cache
docker-compose up -d
```

## ⚠️ Important Notes

- **Version Compatibility**: All mods MUST be compatible with NeoForge 1.21.1 build 21.1.130
- **File Integrity**: Verify jar files are not corrupted before use
- **Licensing**: Respect individual mod licenses and terms
- **Updates**: Check for mod updates regularly for security and compatibility

## 🔍 Verification

After adding mods, verify the setup:

```bash
# Check mod count
ls -1 mods/*.jar | wc -l

# Check for any non-jar files
ls mods/ | grep -v "\.jar$" || echo "All files are jar files - OK"

# Build test
docker-compose build
```

## 📁 Alternative: Mod Pack Distribution

For team development, consider creating a mod pack:

```bash
# Create mod archive
tar -czf minecraft-mods-v1.0.tar.gz mods/

# Team members can extract:
tar -xzf minecraft-mods-v1.0.tar.gz
```

## 🆘 Troubleshooting

**Missing mods error**: Ensure all 32 jar files are in `mods/` directory  
**Build fails**: Check mod file integrity and NeoForge compatibility  
**Server crashes**: Review logs for mod conflicts or missing dependencies 
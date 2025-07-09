# Changelog

All notable changes to this Minecraft NeoForge server project will be documented in this file.

## [Fixed] - 2025-07-09

### 🔧 Fixed
- **Critical:** Updated NeoForge from 21.1.130 to 21.1.169 to fix mod compatibility issues
- **Fixed:** Mekanism and Forgified Fabric API now work correctly together
- **Fixed:** All 32 mods now load without version conflicts
- **Fixed:** Server starts successfully without crashes

### 📝 Updated
- Updated README.md with correct NeoForge version information
- Updated MODS_SETUP.md with compatibility requirements
- Improved Git configuration with .gitignore and .gitattributes

### 🚀 Initial Release

### ✅ Features
- **Docker Compose** setup for easy deployment
- **NeoForge 1.21.1** (build 21.1.169) server
- **32 carefully selected mods** including:
  - Performance mods (Lithium, Sodium, FerriteCore, ModernFix)
  - Technology mods (Mekanism suite, Industrial Foregoing)
  - Adventure mods (The Aether, Iron's Spells 'n Spellbooks)
  - Quality of life mods (JEI, Jade, Xaero's maps)
- **Optimized JVM settings** for modded server performance
- **Persistent data volumes** for world, configs, and logs
- **Health checks** and automatic restart policies
- **Comprehensive documentation** and setup guides

### 📦 Infrastructure
- Git repository with proper .gitignore (mods excluded from version control)
- Dockerfile with optimized layering and caching
- Development-friendly scripts and configuration
- Detailed README with setup and usage instructions

### 🛠️ Technical Specifications
- **Java 21** runtime environment
- **Memory allocation:** 2G initial, 6G maximum
- **Networking:** Port 25565 exposed
- **Storage:** Docker volumes for persistence
- **Performance:** G1GC with optimized flags for large mod packs 
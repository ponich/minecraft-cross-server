#!/bin/bash

# Minecraft NeoForge Server Wipe Script
# This script will:
# - Stop the running server container
# - Clean the world directory
# - Set proper permissions (777) on world, config, and logs directories
#
# Usage:
#   ./wipe-server.sh           # Interactive mode (asks for confirmation)
#   ./wipe-server.sh --force   # Force mode (no questions)
#   ./wipe-server.sh --yes     # Auto-confirm mode (no questions)

set -e

# Parse command line arguments
FORCE_MODE=false
AUTO_CLEAN_LOGS=false

for arg in "$@"; do
    case $arg in
        --force|--yes|-f|-y)
            FORCE_MODE=true
            AUTO_CLEAN_LOGS=true
            ;;
        --no-logs)
            AUTO_CLEAN_LOGS=false
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --force, --yes, -f, -y    Skip all confirmations"
            echo "  --no-logs                 Don't clean logs (only with --force)"
            echo "  --help, -h                Show this help"
            echo ""
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}Minecraft NeoForge Server Wipe Script${NC}"
echo "======================================"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Confirmation prompt
if [ "$FORCE_MODE" = false ]; then
    echo -e "${RED}WARNING: This will completely wipe your Minecraft world!${NC}"
    echo "This action will:"
    echo "  - Stop the running server"
    echo "  - Delete ALL world data (world/, world_nether/, world_the_end/)"
    echo "  - Reset permissions on world, config, and logs directories"
    echo ""
    read -p "Are you sure you want to continue? (type 'YES' to confirm): " confirm

    if [ "$confirm" != "YES" ]; then
        print_warning "Wipe cancelled by user"
        exit 0
    fi
    echo ""
else
    print_status "Running in force mode - skipping confirmation"
fi

# Check if we're in the right directory
if [ ! -f "$PROJECT_DIR/docker-compose.yml" ]; then
    print_error "docker-compose.yml not found. Please run this script from the project root or scripts directory."
    exit 1
fi

# Change to project directory
cd "$PROJECT_DIR"

# Step 1: Stop the server container
print_status "Stopping Minecraft server container..."
if docker compose ps -q minecraft-server >/dev/null 2>&1; then
    if [ -n "$(docker compose ps -q minecraft-server)" ]; then
        docker compose stop minecraft-server
        print_status "Server container stopped successfully"
    else
        print_warning "Server container is not running"
    fi
else
    print_warning "Could not check container status, continuing anyway..."
fi

# Wait a moment for container to fully stop
sleep 2

# Step 2: Clean world directories
print_status "Cleaning world directories..."

# Remove world directories if they exist
for world_dir in "world" "world_nether" "world_the_end"; do
    if [ -d "$world_dir" ]; then
        print_status "Removing $world_dir directory..."
        rm -rf "$world_dir"
        print_status "$world_dir directory cleaned"
    else
        print_warning "$world_dir directory not found, skipping..."
    fi
done

# Recreate world directory
mkdir -p world
print_status "Created new empty world directory"

# Step 3: Set permissions on directories
print_status "Setting permissions on directories..."

# Set permissions 777 on required directories
for dir in "world" "config" "logs"; do
    if [ -d "$dir" ]; then
        chmod -R 777 "$dir"
        print_status "Set 777 permissions on $dir directory"
    else
        print_warning "$dir directory not found, creating it..."
        mkdir -p "$dir"
        chmod -R 777 "$dir"
        print_status "Created and set permissions on $dir directory"
    fi
done

# Step 4: Clean server-specific directories
print_status "Cleaning server-side world data..."

# Clean server world directories if they exist
if [ -d "server/world" ]; then
    rm -rf server/world
    print_status "Cleaned server/world directory"
fi

if [ -d "server/world_nether" ]; then
    rm -rf server/world_nether
    print_status "Cleaned server/world_nether directory"
fi

if [ -d "server/world_the_end" ]; then
    rm -rf server/world_the_end
    print_status "Cleaned server/world_the_end directory"
fi

# Optional: Clean logs
if [ "$FORCE_MODE" = false ]; then
    echo ""
    read -p "Do you want to clean server logs as well? (y/N): " clean_logs
    if [[ $clean_logs =~ ^[Yy]$ ]]; then
        AUTO_CLEAN_LOGS=true
    fi
fi

if [ "$AUTO_CLEAN_LOGS" = true ]; then
    if [ -d "logs" ]; then
        rm -rf logs/*.log logs/*.log.gz 2>/dev/null || true
        print_status "Cleaned log files"
    fi
    if [ -d "server/logs" ]; then
        rm -rf server/logs/*.log server/logs/*.log.gz 2>/dev/null || true
        print_status "Cleaned server log files"
    fi
fi

echo ""
print_status "Server wipe completed successfully!"
echo ""
echo "Next steps:"
echo "  1. Start the server with: docker compose up -d"
echo "  2. Or use the start script: ./scripts/start-server.sh"
echo ""
print_warning "The server will generate a new world on next startup" 
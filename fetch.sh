#!/usr/bin/env bash

set -e

VERSION="${1:-latest}"

echo "==================================="
echo "Minecraft Server Downloader"
echo "==================================="
echo ""

MANIFEST_URL="https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"

echo "Fetching version manifest..."
MANIFEST=$(curl -s "$MANIFEST_URL")

if [ "$VERSION" = "latest" ]; then
    echo "Finding latest release version..."
    VERSION=$(echo "$MANIFEST" | jq -r '.latest.release')
    echo "Latest release: $VERSION"
fi

echo "Looking for Minecraft version: $VERSION"

VERSION_URL=$(echo "$MANIFEST" | jq -r ".versions[] | select(.id==\"$VERSION\") | .url")

if [ -z "$VERSION_URL" ] || [ "$VERSION_URL" = "null" ]; then
    echo "ERROR: Version $VERSION not found!"
    echo ""
    echo "Available versions:"
    echo "$MANIFEST" | jq -r '.versions[].id' | head -20
    echo "... (use 'jq' to see full list)"
    exit 1
fi

echo "Fetching version manifest from: $VERSION_URL"
VERSION_MANIFEST=$(curl -s "$VERSION_URL")

SERVER_URL=$(echo "$VERSION_MANIFEST" | jq -r '.downloads.server.url')
SERVER_SHA1=$(echo "$VERSION_MANIFEST" | jq -r '.downloads.server.sha1')

if [ -z "$SERVER_URL" ] || [ "$SERVER_URL" = "null" ]; then
    echo "ERROR: Server download not available for version $VERSION"
    exit 1
fi

echo "Server URL: $SERVER_URL"
echo "Expected SHA1: $SERVER_SHA1"
echo ""

if [ -f "server.jar" ]; then
    echo "Checking existing server.jar..."
    EXISTING_SHA1=$(sha1sum server.jar | awk '{print $1}')
    if [ "$EXISTING_SHA1" = "$SERVER_SHA1" ]; then
        echo "✓ server.jar is already up to date!"
        exit 0
    else
        echo "Existing server.jar has different hash, downloading new version..."
    fi
fi

echo "Downloading server.jar..."
curl -# -o server.jar "$SERVER_URL"

echo ""
echo "Verifying download..."
DOWNLOADED_SHA1=$(sha1sum server.jar | awk '{print $1}')

if [ "$DOWNLOADED_SHA1" = "$SERVER_SHA1" ]; then
    echo "✓ Download verified successfully!"
    echo "✓ Minecraft server $VERSION is ready!"
else
    echo "✗ ERROR: SHA1 mismatch!"
    echo "  Expected: $SERVER_SHA1"
    echo "  Got:      $DOWNLOADED_SHA1"
    exit 1
fi

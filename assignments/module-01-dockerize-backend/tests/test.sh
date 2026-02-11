#!/bin/bash
set -e

echo "========================================="
echo "Module 01: Backend Dockerfile Tests"
echo "========================================="

# Configuration
IMAGE_NAME="backend-test"
CONTAINER_NAME="backend-test-container"
DOCKERFILE_PATH="../starter/Dockerfile"
BUILD_CONTEXT="../../.."
MAX_IMAGE_SIZE_MB=500
HEALTH_ENDPOINT="http://localhost:3000/health"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Change to script directory for correct relative paths
cd "$(dirname "$0")"

# Cleanup function
cleanup() {
    echo ""
    echo "Cleaning up..."
    docker rm -f $CONTAINER_NAME 2>/dev/null || true
    docker rm -f postgres-test 2>/dev/null || true
    docker rmi -f $IMAGE_NAME 2>/dev/null || true
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Test 1: Dockerfile exists
echo ""
echo "Test 1: Checking if Dockerfile exists..."
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo -e "${RED}FAIL${NC}: Dockerfile not found at $DOCKERFILE_PATH"
    exit 1
fi
echo -e "${GREEN}PASS${NC}: Dockerfile found"

# Test 2: Build the image
echo ""
echo "Test 2: Building Docker image..."
if docker build -f "$DOCKERFILE_PATH" -t $IMAGE_NAME "$BUILD_CONTEXT/backend" > /tmp/build.log 2>&1; then
    echo -e "${GREEN}PASS${NC}: Image built successfully"
else
    echo -e "${RED}FAIL${NC}: Image build failed"
    echo "Build log:"
    cat /tmp/build.log
    exit 1
fi

# Test 3: Check image size
echo ""
echo "Test 3: Checking image size..."
IMAGE_SIZE=$(docker image inspect $IMAGE_NAME --format='{{.Size}}')
IMAGE_SIZE_MB=$((IMAGE_SIZE / 1024 / 1024))
echo "Image size: ${IMAGE_SIZE_MB}MB"

if [ $IMAGE_SIZE_MB -gt $MAX_IMAGE_SIZE_MB ]; then
    echo -e "${YELLOW}WARNING${NC}: Image size (${IMAGE_SIZE_MB}MB) exceeds recommended size (${MAX_IMAGE_SIZE_MB}MB)"
    echo "Consider using Alpine base image and optimizing dependencies"
else
    echo -e "${GREEN}PASS${NC}: Image size is acceptable"
fi

# Test 4: Start PostgreSQL and run the container
echo ""
echo "Test 4: Starting PostgreSQL and application container..."
docker run -d --name postgres-test \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=classroom_db \
    -p 5432:5432 \
    postgres:16-alpine
sleep 5

PG_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgres-test)

if docker run -d --name $CONTAINER_NAME -p 3000:3000 \
    -e NODE_ENV=development \
    -e PORT=3000 \
    -e DB_HOST=$PG_HOST \
    -e DB_PORT=5432 \
    -e DB_NAME=classroom_db \
    -e DB_USER=postgres \
    -e DB_PASSWORD=postgres \
    $IMAGE_NAME > /dev/null; then
    echo -e "${GREEN}PASS${NC}: Container started"
else
    echo -e "${RED}FAIL${NC}: Container failed to start"
    exit 1
fi

# Wait for application to be ready
echo ""
echo "Waiting for application to be ready..."
sleep 5

# Test 5: Check if container is running
echo ""
echo "Test 5: Verifying container is running..."
if docker ps | grep -q $CONTAINER_NAME; then
    echo -e "${GREEN}PASS${NC}: Container is running"
else
    echo -e "${RED}FAIL${NC}: Container is not running"
    echo "Container logs:"
    docker logs $CONTAINER_NAME
    exit 1
fi

# Test 6: Test health endpoint
echo ""
echo "Test 6: Testing health endpoint..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_ENDPOINT)
if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}PASS${NC}: Health endpoint returned 200"
    RESPONSE=$(curl -s $HEALTH_ENDPOINT)
    echo "Response: $RESPONSE"
else
    echo -e "${RED}FAIL${NC}: Health endpoint returned $HTTP_CODE (expected 200)"
    echo "Container logs:"
    docker logs $CONTAINER_NAME
    exit 1
fi

# Test 7: Verify port is exposed
echo ""
echo "Test 7: Verifying port 3000 is exposed..."
EXPOSED_PORTS=$(docker inspect $CONTAINER_NAME --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} {{end}}')
if echo "$EXPOSED_PORTS" | grep -q "3000"; then
    echo -e "${GREEN}PASS${NC}: Port 3000 is exposed"
else
    echo -e "${RED}FAIL${NC}: Port 3000 is not exposed"
    exit 1
fi

# All tests passed
echo ""
echo "========================================="
echo -e "${GREEN}ALL TESTS PASSED!${NC}"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Compare your Dockerfile with the solution"
echo "2. Review the differences and understand best practices"
echo "3. Proceed to Module 02: Dockerize the Frontend"
echo ""

exit 0

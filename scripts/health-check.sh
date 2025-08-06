#!/bin/bash

# LLM Monitoring System Health Check Script

set -e

echo "🔍 LLM Monitoring System Health Check 시작..."

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 상태 확인 함수
check_service() {
    local service=$1
    local url=$2
    local name=$3
    
    echo -n "🔍 $name 확인 중... "
    
    if curl -s -f "$url" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 정상${NC}"
        return 0
    else
        echo -e "${RED}❌ 오류${NC}"
        return 1
    fi
}

# Docker 컨테이너 상태 확인
echo "🐳 Docker 컨테이너 상태 확인..."
docker-compose ps

echo ""

# 서비스 상태 확인
echo "🌐 서비스 상태 확인..."

# Grafana 확인
check_service "grafana" "http://localhost:3000/api/health" "Grafana"

# Prometheus 확인
check_service "prometheus" "http://localhost:9090/-/healthy" "Prometheus"

# Alertmanager 확인
check_service "alertmanager" "http://localhost:9093/-/healthy" "Alertmanager"

echo ""

# 메트릭 수집 확인
echo "📊 메트릭 수집 상태 확인..."

# Prometheus 타겟 상태 확인
echo "🔍 Prometheus 타겟 상태:"
curl -s "http://localhost:9090/api/v1/targets" | jq -r '.data.activeTargets[] | "  \(.labels.job): \(.health)"' 2>/dev/null || echo "  jq가 설치되지 않았습니다. 수동으로 확인하세요."

echo ""

# 알림 상태 확인
echo "🚨 알림 상태 확인..."
curl -s "http://localhost:9093/api/v1/alerts" | jq -r '.data[] | "  \(.labels.alertname): \(.state)"' 2>/dev/null || echo "  활성 알림이 없거나 jq가 설치되지 않았습니다."

echo ""

# 시스템 리소스 확인
echo "💻 시스템 리소스 확인..."
echo "  CPU 사용률: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
echo "  메모리 사용률: $(free | grep Mem | awk '{printf("%.1f%%", $3/$2 * 100.0)}')"
echo "  디스크 사용률: $(df -h / | awk 'NR==2 {print $5}')"

echo ""

echo "✅ Health Check 완료!" 
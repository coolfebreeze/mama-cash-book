#!/bin/bash

# LLM Monitoring System Setup Script

set -e

echo "🚀 LLM Monitoring System Setup 시작..."

# 환경 변수 파일 확인
if [ ! -f .env ]; then
    echo "📝 .env 파일을 생성합니다..."
    cp env.example .env
    echo "⚠️  .env 파일을 수정하여 실제 설정값을 입력하세요."
    echo "   특히 LLM_AUTH_PROXY_HOST 주소를 설정해야 합니다."
fi

# 디렉토리 생성
echo "📁 필요한 디렉토리를 생성합니다..."
mkdir -p prometheus grafana/provisioning/datasources grafana/provisioning/dashboards grafana/dashboards alertmanager

# 권한 설정
echo "🔐 파일 권한을 설정합니다..."
chmod 600 prometheus/llm_admin_token.txt
chmod 644 prometheus/prometheus.yml
chmod 644 prometheus/alert.rules.yml
chmod 644 alertmanager/alertmanager.yml

# Docker Compose 확인
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose가 설치되지 않았습니다."
    echo "   Docker Compose를 설치한 후 다시 실행하세요."
    exit 1
fi

echo "✅ 설정이 완료되었습니다!"
echo ""
echo "📋 다음 단계:"
echo "1. .env 파일을 수정하여 실제 설정값을 입력하세요"
echo "2. prometheus/prometheus.yml에서 LLM Auth Proxy 주소를 설정하세요"
echo "3. docker-compose up -d로 시스템을 시작하세요"
echo ""
echo "🌐 접속 주소:"
echo "   Grafana: http://localhost:3000 (admin/admin123)"
echo "   Prometheus: http://localhost:9090"
echo "   Alertmanager: http://localhost:9093" 
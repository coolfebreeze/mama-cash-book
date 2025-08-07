#!/bin/bash

# Grafana Plugin Download Script for Offline Installation

set -e

# 프로젝트 루트 디렉토리 찾기 (스크립트 위치 기준)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PLUGINS_DIR="$PROJECT_ROOT/grafana/assets"

PLUGINS=(
    "grafana-clock-panel"
    "grafana-simple-json-datasource"
)

echo "📦 Grafana 플러그인 다운로드 시작..."
echo "📁 프로젝트 루트: $PROJECT_ROOT"
echo "📁 플러그인 디렉토리: $PLUGINS_DIR"

# 플러그인 디렉토리 생성
mkdir -p "$PLUGINS_DIR"

# 각 플러그인 다운로드
for plugin in "${PLUGINS[@]}"; do
    echo "🔽 $plugin 다운로드 중..."
    
    # 플러그인 디렉토리 생성
    mkdir -p "$PLUGINS_DIR/$plugin"
    
    # 플러그인 다운로드 (최신 버전)
    cd "$PLUGINS_DIR/$plugin"
    
    # Grafana 플러그인 레지스트리에서 다운로드
    PLUGIN_URL="https://grafana.com/api/plugins/$plugin/versions/latest/download"
    
    if curl -L -o plugin.zip "$PLUGIN_URL"; then
        # 압축 해제
        unzip -q plugin.zip
        rm plugin.zip
        
        echo "✅ $plugin 다운로드 완료"
    else
        echo "❌ $plugin 다운로드 실패"
        exit 1
    fi
    
    cd - > /dev/null
done

echo "✅ 모든 플러그인 다운로드 완료!"
echo "📁 플러그인 위치: $PLUGINS_DIR/"
echo ""
echo "💡 사용 방법:"
echo "1. 이 스크립트를 실행하여 플러그인을 다운로드"
echo "2. docker-compose up -d로 Grafana 시작"
echo "3. Grafana에서 플러그인이 자동으로 로드됨" 
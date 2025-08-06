#!/bin/bash

# LLM Monitoring System Backup Script

set -e

# 설정
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="llm_monitoring_backup_$DATE"

echo "💾 LLM Monitoring System 백업 시작..."

# 백업 디렉토리 생성
mkdir -p "$BACKUP_DIR"

echo "📁 설정 파일 백업 중..."

# 설정 파일 백업
tar -czf "$BACKUP_DIR/${BACKUP_NAME}_config.tar.gz" \
    prometheus/ \
    grafana/provisioning/ \
    grafana/dashboards/ \
    alertmanager/ \
    docker-compose.yml \
    .env \
    env.example

echo "📊 Prometheus 데이터 백업 중..."

# Prometheus 데이터 백업 (Docker 볼륨)
docker run --rm \
    -v llm-monitoring_prometheus_data:/data \
    -v "$(pwd)/$BACKUP_DIR:/backup" \
    alpine tar -czf "/backup/${BACKUP_NAME}_prometheus_data.tar.gz" -C /data .

echo "📈 Grafana 데이터 백업 중..."

# Grafana 데이터 백업 (Docker 볼륨)
docker run --rm \
    -v llm-monitoring_grafana_data:/data \
    -v "$(pwd)/$BACKUP_DIR:/backup" \
    alpine tar -czf "/backup/${BACKUP_NAME}_grafana_data.tar.gz" -C /data .

echo "🚨 Alertmanager 데이터 백업 중..."

# Alertmanager 데이터 백업 (Docker 볼륨)
docker run --rm \
    -v llm-monitoring_alertmanager_data:/data \
    -v "$(pwd)/$BACKUP_DIR:/backup" \
    alpine tar -czf "/backup/${BACKUP_NAME}_alertmanager_data.tar.gz" -C /data .

# 전체 백업 파일 생성
echo "📦 전체 백업 파일 생성 중..."
tar -czf "$BACKUP_DIR/${BACKUP_NAME}_full.tar.gz" \
    "$BACKUP_DIR/${BACKUP_NAME}_config.tar.gz" \
    "$BACKUP_DIR/${BACKUP_NAME}_prometheus_data.tar.gz" \
    "$BACKUP_DIR/${BACKUP_NAME}_grafana_data.tar.gz" \
    "$BACKUP_DIR/${BACKUP_NAME}_alertmanager_data.tar.gz"

# 개별 파일 정리
rm "$BACKUP_DIR/${BACKUP_NAME}_config.tar.gz"
rm "$BACKUP_DIR/${BACKUP_NAME}_prometheus_data.tar.gz"
rm "$BACKUP_DIR/${BACKUP_NAME}_grafana_data.tar.gz"
rm "$BACKUP_DIR/${BACKUP_NAME}_alertmanager_data.tar.gz"

# 오래된 백업 파일 정리 (30일 이상)
echo "🧹 오래된 백업 파일 정리 중..."
find "$BACKUP_DIR" -name "llm_monitoring_backup_*.tar.gz" -mtime +30 -delete

echo "✅ 백업 완료!"
echo "📁 백업 위치: $BACKUP_DIR/${BACKUP_NAME}_full.tar.gz"
echo "📏 백업 크기: $(du -h "$BACKUP_DIR/${BACKUP_NAME}_full.tar.gz" | cut -f1)" 
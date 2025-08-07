#!/bin/bash

# SSL Certificate Generation Script for LLM Monitoring System

set -e

SSL_DIR="./nginx/ssl"
DOMAIN=${NGINX_DOMAIN:-"localhost"}

echo "🔐 SSL 인증서 생성 시작..."

# SSL 디렉토리 생성
mkdir -p "$SSL_DIR"

# Self-signed certificate 생성
echo "📝 Self-signed SSL 인증서 생성 중..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$SSL_DIR/key.pem" \
    -out "$SSL_DIR/cert.pem" \
    -subj "/C=KR/ST=Seoul/L=Seoul/O=LLM Monitoring/OU=IT/CN=$DOMAIN"

# 권한 설정
chmod 600 "$SSL_DIR/key.pem"
chmod 644 "$SSL_DIR/cert.pem"

echo "✅ SSL 인증서 생성 완료!"
echo "📁 인증서 위치: $SSL_DIR/"
echo "🔑 개인키: $SSL_DIR/key.pem"
echo "📜 인증서: $SSL_DIR/cert.pem"
echo ""
echo "⚠️  주의: 이는 Self-signed 인증서입니다."
echo "   프로덕션 환경에서는 Let's Encrypt나 상용 인증서를 사용하세요."
echo ""
echo "🌐 접속 방법:"
echo "   - Grafana: https://$DOMAIN/"
echo "   - Prometheus: https://$DOMAIN/prometheus/"
echo "   - Alertmanager: https://$DOMAIN/alertmanager/" 
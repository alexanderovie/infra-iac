#!/bin/bash
# SÚPER-ÉLITE Cloudflare DNS Query Script

# Cargar variables de entorno
# shellcheck source=export-env.sh
source "$(dirname "$0")/export-env.sh"

# Función para consultar DNS records
query_dns() {
    local record_name="$1"
    local zone_id="${ZONE_ID:-6d7328e7f3edb975ef1f52cdb29178b7}"

    echo "🔍 Querying DNS record: $record_name"
    echo "📍 Zone ID: $zone_id"
    echo ""

    curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records?name=$record_name" \
      -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
      -H "X-Auth-Key: $CLOUDFLARE_API_KEY" \
      -H "Content-Type: application/json" | jq '.result[] | {name,type,content,proxied,ttl,id}'
}

# Función para listar todos los records
list_all_dns() {
    local zone_id="${ZONE_ID:-6d7328e7f3edb975ef1f52cdb29178b7}"

    echo "🔍 Listing all DNS records for fascinantedigital.com"
    echo "📍 Zone ID: $zone_id"
    echo ""

    curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records" \
      -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
      -H "X-Auth-Key: $CLOUDFLARE_API_KEY" \
      -H "Content-Type: application/json" | jq '.result[] | select(.name | contains("fascinantedigital.com")) | {name,type,content,proxied,ttl,id}'
}

# Uso del script
case "$1" in
    "stage")
        query_dns "stage.fascinantedigital.com"
        ;;
    "www")
        query_dns "www.fascinantedigital.com"
        ;;
    "root")
        query_dns "fascinantedigital.com"
        ;;
    "all")
        list_all_dns
        ;;
    *)
        echo "Usage: $0 {stage|www|root|all}"
        echo ""
        echo "Examples:"
        echo "  $0 stage    # Query stage.fascinantedigital.com"
        echo "  $0 www      # Query www.fascinantedigital.com"
        echo "  $0 root     # Query fascinantedigital.com"
        echo "  $0 all      # List all fascinantedigital.com records"
        exit 1
        ;;
esac

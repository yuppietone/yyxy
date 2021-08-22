FROM caddy:builder-alpine AS builder

RUN xcaddy build \
        --with github.com/mholt/caddy-l4 \
        --with github.com/mholt/caddy-dynamicdns \
        --with github.com/caddy-dns/openstack-designate \
        --with github.com/caddy-dns/azure \
        --with github.com/caddy-dns/vultr \
        --with github.com/caddy-dns/hetzner \
        --with github.com/caddy-dns/digitalocean \
        --with github.com/caddy-dns/alidns \
        --with github.com/caddy-dns/gandi \
        --with github.com/caddy-dns/duckdns \
        --with github.com/caddy-dns/dnspod \
        --with github.com/caddy-dns/lego-deprecated \
        --with github.com/caddy-dns/route53 \
        --with github.com/caddy-dns/cloudflare
        
FROM caddy:builder-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN apk update && \
    apk add --no-cache --virtual ca-certificates caddy tor wget curl && \
    mkdir /xray && \
    curl -L -H "Cache-Control: no-cache" -o /xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /xray/xray.zip -d /xray && \
    chmod +x /xray && \
    rm -rf /var/cache/apk/* && \
    apk del .build-deps

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh

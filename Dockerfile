FROM caddy:2-alpine

# Copy site files into Caddy's default static root
COPY . /srv

# Runtime entrypoint that builds the Caddyfile from env vars
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 80 : ACME HTTP-01 challenge (also plain HTTP redirect in https mode)
# 8080: HTTP serving in http mode
# 8443: HTTPS serving in https mode
EXPOSE 80 8080 8443

ENTRYPOINT ["/entrypoint.sh"]
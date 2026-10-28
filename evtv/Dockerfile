# NodeCast TV with Tailscale built in, so it can get its own free https:// address (Tailscale Funnel)
FROM ghcr.io/tailscale/tailscale:v1.104.2 AS tailscale
FROM ghcr.io/technomancer702/nodecast-tv:2.2.1

COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin/tailscaled /usr/local/bin/
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Home Assistant checks the add-on itself; the image's own check would mark it unhealthy while starting
HEALTHCHECK NONE
CMD ["/run.sh"]

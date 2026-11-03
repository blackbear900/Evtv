# NodeCast TV with Tailscale built in, so it can get its own free https:// address (Tailscale Funnel)
FROM ghcr.io/tailscale/tailscale:v1.104.2 AS tailscale
FROM ghcr.io/technomancer702/nodecast-tv:2.2.1

COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin/tailscaled /usr/local/bin/
COPY run.sh /run.sh
COPY evtv-groups.js /app/public/js/evtv-groups.js
COPY patch-group-order.js /tmp/patch-group-order.js
RUN chmod +x /run.sh && node /tmp/patch-group-order.js && rm /tmp/patch-group-order.js

# Home Assistant only shows the add-on as "started" once Docker reports a health status, and
# HEALTHCHECK NONE never reports one (it stays "starting" forever), so a real check is needed.
# It checks that NodeCast (PID 1, via run.sh's exec) is alive instead of asking it over HTTP: an EPG sync
# blocks NodeCast for minutes, an HTTP check would fail then, and the watchdog would restart it mid-sync.
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD kill -0 1 || exit 1
CMD ["/run.sh"]

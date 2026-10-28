#!/bin/bash
# Starts NodeCast TV, and (if turned on) shares it at a free https:// address with Tailscale Funnel.
set -e

opt() { node -e "const v=require('/data/options.json')['$1'];process.stdout.write(v==null?'':String(v))"; }

# Keep NodeCast's accounts, channels and settings in the add-on's saved folder, so updates don't erase them
mkdir -p /data/nodecast /data/tailscale /var/run/tailscale
if [ ! -L /app/data ]; then
  rm -rf /app/data
  ln -s /data/nodecast /app/data
fi

if [ "$(opt tailscale_funnel)" = "true" ]; then
  name="$(opt tailscale_name)"
  tailscaled --tun=userspace-networking --state=/data/tailscale/tailscaled.state \
    --socket=/var/run/tailscale/tailscaled.sock >/dev/null 2>&1 &
  (
    until [ -S /var/run/tailscale/tailscaled.sock ]; do sleep 1; done
    echo "[Tailscale] If this is the first start, open the link below to connect this add-on to your Tailscale account:"
    tailscale up --hostname="${name:-evtv}"

    # Only go public once the NodeCast admin account exists, so a stranger can't create it first
    until curl -fs http://127.0.0.1:3000/api/auth/setup-required | grep -q '"setupRequired":false'; do
      echo "[Tailscale] Waiting: first create your NodeCast account at http://homeassistant.local:3000 (from home), then the Tesla address turns on."
      sleep 60
    done

    echo "[Tailscale] Turning on your public address. If a link appears, open it once to allow Funnel:"
    tailscale funnel --bg 3000
    address=$(tailscale status --json | node -e "let s='';process.stdin.on('data',d=>s+=d).on('end',()=>process.stdout.write(JSON.parse(s).Self.DNSName.replace(/\.$/,'')))")
    echo "[Tailscale] Ready! Open this in the Tesla: https://${address}"
  ) &
fi

cd /app
exec node server/index.js

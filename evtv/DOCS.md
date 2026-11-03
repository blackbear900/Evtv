# EV TV

Watch your IPTV in your EV's web browser (like a Tesla's), using
[NodeCast TV](https://github.com/technomancer702/nodecast-tv). It brings your channels in through this
computer, so `http://` channels play on secure `https://` pages.

## First start

1. Start the add-on, then open the **Log** tab.
2. Open the Tailscale link shown there and sign in (a free Tailscale account is fine).
3. At home, open `http://homeassistant.local:3000` and create your NodeCast account.
   The public address stays off until this account exists, so nobody else can claim it.
4. Back in the **Log** tab: if a link to allow "Funnel" appears, open it and allow it.
5. The log then shows **Ready! Open this in the Tesla: https://evtv.….ts.net**.
6. In NodeCast, add your IPTV details, then in **Settings → Transcoding**:
   - **Network → Force Backend Proxy**: on
   - **Stream Processing → Auto Transcode (Smart)**: off
   - **Stream Processing → Force Audio Transcode**: on

   (Most IPTV channels come as raw `.ts` video, which browsers can't play. With these settings EV TV turns
   them into web video using a single connection to your IPTV service, which also suits plans that allow
   only one stream at a time, and iPhones.)

## Options

- **tailscale_funnel**: share NodeCast at a free public `https://` address (on by default).
- **tailscale_name**: the first word of that address (default `evtv`).

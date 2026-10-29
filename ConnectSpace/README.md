# ConnectSpace

A beginner-friendly Python + FastAPI + SQLite meeting app starter. It includes a guest-based dashboard, scheduled meetings, WebSocket signaling, WebRTC audio/video, screen sharing, browser-side recording, and meeting chat.

## Start on Windows

1. Install Python 3.12+ from https://www.python.org/downloads/ and tick **Add Python to PATH**.
2. Extract this ZIP.
3. Double-click `start.bat`.
4. Wait for the browser to open at http://127.0.0.1:8000.
5. Keep the black terminal window open while using the app.

No `.env` file, account, paid API, or separate database installation is required for local development. SQLite is created automatically in `data/connectspace.db`.

## Deploy to Vercel

1. Push this project to a Git provider and import it into Vercel. Keep the project root set to this directory.
2. Deploy with the included `vercel.json`; Vercel serves the FastAPI app and bundles the static assets.
3. For meeting data that survives deployments and serverless restarts, attach a PostgreSQL database and set `DATABASE_URL` in the Vercel project environment variables. The app accepts PostgreSQL URLs using either `postgres://` or `postgresql://`.

Without `DATABASE_URL`, the app uses SQLite under `/tmp` on Vercel. That database is temporary and can be reset between function instances, so it is only suitable for a demo. Locally, SQLite remains at `data/connectspace.db`.

**Vercel limitation:** Vercel Functions do not provide the persistent WebSocket server this app uses for meeting signaling. The dashboard, static assets, and HTTP API can deploy, but live meeting signaling (peer discovery, chat, and WebRTC setup) needs a WebSocket-capable backend. Deploy the full app on a persistent ASGI host for all meeting features.

## Run tests

Install the development dependencies and run the test suite:

```powershell
py -m pip install -r requirements-dev.txt
py -m pytest
```

## Features in this starter

- Guest access without login/register pages
- Create instant meeting links and join by meeting code
- Scheduled meetings saved in SQLite
- Real-time WebSocket signaling for WebRTC mesh calls
- Camera and microphone toggles
- Screen sharing using the browser's screen capture picker
- Meeting chat sent to connected room participants
- Browser-side recording using MediaRecorder, with a downloadable video file
- Meeting notes and meeting templates
- Homepage meeting video preview (stock footage by Jeff Vinluan via Pexels)
- Auto-rotating homepage carousel with locally hosted Pexels team photography
- Responsive UI and custom SVG logo
- Health endpoint at `/api/health`
- API documentation at `/docs`

## Important limitations (read before presenting as production-ready)

- **This is a local-development starter, not a hardened production conferencing service.** It uses a WebRTC mesh topology, which becomes inefficient as the number of participants increases. Treat it as a small-room demo (for example, 2–4 participants depending on devices/network).
- WebRTC requires HTTPS or localhost for camera/microphone/screen-capture APIs. The local URL is `http://127.0.0.1:8000`, which browsers treat as a secure context.
- STUN is configured in the browser for connectivity assistance, but STUN alone cannot traverse every firewall/NAT. For reliable calls across restrictive networks, configure a TURN service. A public internet deployment also needs HTTPS, a persistent Python host, and TURN/SFU infrastructure.
- **Browser recording records the current participant's local media stream** (camera/microphone, or a screen stream when sharing). It does not automatically create a combined recording of every remote participant. Browser system-audio capture varies by browser/OS.
- Meeting creation/joining is guest-based. Anyone with a meeting code/link can attempt to join unless you share it carefully. This demo does not implement strong production-grade host capability security, waiting-room enforcement, or private recording storage.
- Scheduling stores meeting details locally in SQLite. Email reminders are not sent.
- Browser device testing is required. Automated API tests cannot prove WebRTC media works across different devices or networks.

## Test with two people

1. Start ConnectSpace.
2. Create a meeting in one browser.
3. Copy the meeting link and open it in a second browser/device.
4. Enter a different display name and join.
5. Allow microphone/camera permissions.
6. Test mic, camera, chat, and screen share.
7. Test recording from a participant's own browser and download the file.

For two devices on the same Wi-Fi, use your computer's LAN IP instead of `127.0.0.1` on the second device. Camera/mic APIs on another device may require HTTPS; plain HTTP on a LAN IP usually is not considered a secure context. For public testing, deploy behind HTTPS.

## Troubleshooting

- **Python not found:** reinstall Python and tick "Add Python to PATH".
- **Port 8000 already in use:** close the other app using it, or change `--port 8000` in `start.bat` and use the matching URL.
- **Camera/mic unavailable:** use Chrome or Edge, check site permissions, and close other apps using the camera.
- **No remote video:** check the terminal and browser console, confirm both people are in the same meeting, and try another network. STUN cannot fix every network; TURN may be required.
- **Screen share unavailable:** use a supported desktop browser and click the browser's own screen/window/tab picker.
- **Recording unsupported:** the browser must support MediaRecorder for a compatible MIME type.
- **Database reset:** stop the server and delete `data/connectspace.db` (this permanently deletes saved local meeting data).

## Project structure

- `app/main.py` — FastAPI routes, SQLite models, WebSocket signaling, static files
- `app/static/index.html` — dashboard and meeting UI
- `app/static/styles.css` — responsive styles and animations
- `app/static/app.js` — browser UI, WebRTC, screen share, chat, recording
- `app/static/assets/logo.svg` — original ConnectSpace mark
- `start.bat` — Windows startup script

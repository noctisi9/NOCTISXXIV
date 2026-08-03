# NOCTIS XXIV — Dashboard Shell (Placeholder Data)

## What this is

A working Flutter desktop dashboard, matching your finished design, running
entirely on **mock data** so you can see it, click through it, and confirm
it looks and feels right — before any MT5 connection exists.

## Building via GitHub Actions (recommended, given local hardware constraints)

This project includes `.github/workflows/build-windows.yml`, which builds
the Windows release entirely in the cloud — matching the workflow already
used for Records of Noctis and BEACON1.

1. Push this project (with the `.github/workflows/` folder included) to
   your GitHub repo, same as your other projects — from PowerShell:
   ```powershell
   git add .
   git commit -m "Add Windows build workflow"
   git push
   ```
2. Go to the repo on GitHub → **Actions** tab. The build kicks off
   automatically on push, or click **Run workflow** to trigger it manually
   any time without pushing new code.
3. Once it finishes (green checkmark), open the completed run → scroll to
   **Artifacts** → download `noctis-xxiv-windows-build`. That zip contains
   the full Release folder — exe, `data\`, and DLLs together, ready to
   run on any Windows machine without needing Flutter installed.

## How to drop it in (local dev/testing only)

1. Copy the `lib/` folder into your existing Flutter project, merging with
   what's already there (don't overwrite `main.dart` if you have other
   screens depending on it — merge manually if so).
2. Check `pubspec_reference.yaml` — no new dependencies are required (every
   chart is hand-drawn with `CustomPainter`, no chart package needed), but
   confirm Windows desktop is enabled:
   ```
   flutter config --enable-windows-desktop
   ```
3. Run:
   ```
   flutter run -d windows
   ```

## Why it's structured this way

Every widget reads from a `DashboardSnapshot` object, which comes from a
`DataService` interface (`lib/services/data_service.dart`). Right now,
`main.dart` uses `MockDataService`, which generates plausible fake data
every 3 seconds so you can see the UI update/refresh live.

**When the MT5 bridge (mt5_bridge.py) is ready:**
1. Build an `Mt5DataService implements DataService` that calls your
   Python bridge's API (the `/market-state`, `/news-events`,
   `/event-reaction`, `/intelligence` endpoints from Research 003 §10)
   and maps the responses onto the same models in `market_models.dart`.
2. Change **one line** in `main.dart`:
   `final DataService dataService = MockDataService();`
   becomes
   `final DataService dataService = Mt5DataService(baseUrl: '...');`

Nothing in any widget file needs to change. That's the whole point of
building against an interface instead of hardcoding mock data into the
UI directly.

## What's still placeholder / not final

- All numbers (price, news event, scores, oscillator bars) are
  randomly generated in `MockDataService`, not real
- AO/AC bars are random, not calculated — real version reads directly
  from MT5's built-in indicator values (per your Research 003 decision)
- A small amber "MOCK DATA" badge renders on the dashboard whenever
  `isLiveData` is false, so it's never ambiguous whether you're
  looking at something real
- Timeframe tabs (M1/M5/etc.) are visually wired up but don't yet
  re-fetch different data — that's meaningful once real data exists

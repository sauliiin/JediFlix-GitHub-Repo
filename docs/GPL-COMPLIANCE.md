# GPL Compliance

This project is based on Kodi, which is distributed under `GPL-2.0-or-later`.

## What to keep with the APK

- The upstream license notice.
- A clear notice that this build is modified and unofficial.
- Access to the corresponding source code, or a reproducible patch set against the upstream source.

## Recommended minimum for public redistribution

1. Publish this APK repository.
2. Publish the modified source tree in a separate repository, or export a patch set from your local workspace.
3. Link both repositories together.

## Helper included here

This repo includes `scripts/export-source-patch.sh`, which can generate a patch file by comparing:

- `xbmc-21.3-Omega-original-unteched/xbmc-21.3-Omega`
- `xbmc-21.3-Omega`

## Important note

A patch file can help document your changes, but you should still make sure the full corresponding source is available in a practical way for whoever receives the binary.

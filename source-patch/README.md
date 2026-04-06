# Source Patch

This folder contains a cleaned corresponding-source patch for the `JediFlix` build.

## Files

- `jediflix-kodi-corresponding-source.patch.gz`: compressed patch with text and binary deltas.
- `changed-files.txt`: files added or modified in the `JediFlix` tree.
- `removed-files.txt`: files removed from the upstream tree.
- `SHA256SUMS.txt`: integrity checksum for the compressed patch.

## How to use

1. Start from the matching upstream Kodi source tree.
2. Extract the patch:

```bash
gunzip -c jediflix-kodi-corresponding-source.patch.gz > jediflix-kodi-corresponding-source.patch
```

3. Apply it from the upstream source root:

```bash
git apply -p2 --reject ../source-patch/jediflix-kodi-corresponding-source.patch
```

`-p2` is required because the patch was generated with the temporary prefixes `upstream/` and `jediflix/`.

# Homebrew tap

```sh
brew install --cask fogrye/tap/keywarden
```

[Keywarden](https://github.com/fogrye/Keywarden) requires Apple Silicon and macOS 26 or later. The cask installs the signed, notarized release into `/Applications`.

```sh
brew upgrade --cask keywarden
```

Disconnect browsers in Keywarden Settings > Browsers before `brew uninstall --cask keywarden`. Uninstalling preserves vault data and preferences.

The update workflow checks hourly for new stable releases and updates the cask version and SHA-256 from GitHub release metadata. Prereleases are excluded. To update manually, run `python3 scripts/update-cask.py` with authenticated `gh`, or dispatch the workflow.

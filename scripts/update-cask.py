#!/usr/bin/env python3
"""Update the cask from the latest stable Keywarden release metadata."""

import json
import re
import subprocess
from pathlib import Path


def update(release, cask):
    if release["isDraft"] or release["isPrerelease"]:
        raise ValueError("Expected a published stable release")
    tag = release["tagName"]
    if not re.fullmatch(r"v\d+\.\d+\.\d+", tag):
        raise ValueError(f"Unexpected release tag: {tag}")
    version = tag[1:]
    pattern = re.compile(rf"Keywarden-{re.escape(version)}-(\d+)\.zip")
    assets = [(asset, pattern.fullmatch(asset["name"])) for asset in release["assets"]]
    assets = [(asset, match) for asset, match in assets if match]
    if len(assets) != 1:
        raise ValueError("Expected exactly one versioned release ZIP")
    asset, match = assets[0]
    digest = asset.get("digest", "")
    if not isinstance(digest, str) or not re.fullmatch(r"sha256:[0-9a-f]{64}", digest):
        raise ValueError("Release asset has no SHA-256 digest")
    text = cask.read_text()
    text, count = re.subn(r'^  version "[^"]+"$', f'  version "{version},{match[1]}"', text, flags=re.M)
    if count != 1:
        raise ValueError("Expected exactly one cask version")
    text, count = re.subn(r'^  sha256 "[^"]+"$', f'  sha256 "{digest[7:]}"', text, flags=re.M)
    if count != 1:
        raise ValueError("Expected exactly one cask checksum")
    cask.write_text(text)
    print(f"Keywarden {version} (build {match[1]})")


if __name__ == "__main__":
    release = json.loads(subprocess.check_output([
        "gh", "release", "view", "--repo", "fogrye/Keywarden",
        "--json", "tagName,assets,isDraft,isPrerelease",
    ]))
    update(release, Path(__file__).resolve().parents[1] / "Casks/keywarden.rb")

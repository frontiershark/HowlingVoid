#!/usr/bin/env python3
"""
BYOND Cache Reloader

Watches for changes in the compiled bundles directory and copies them
into DreamSeeker's cache, then notifies running instances to reload.

Usage:
    python reload_byond.py [--bundle-dir PATH] [--watch]

Options:
    --bundle-dir PATH   Path to compiled bundles (default: ../compiled)
    --watch             Watch for changes and reload automatically
"""

import argparse
import glob
import os
import platform
import re
import shutil
import subprocess
import sys
import time
import urllib.request
from pathlib import Path


BUNDLE_PATTERNS = [
    "*.bundle.js",
    "*.bundle.css",
    "*.chunk.*",
    "*.hot-update.*",
]


def find_byond_cache() -> str | None:
    """Find the BYOND cache directory."""
    home = Path.home()

    # Custom location via env
    env_cache = os.environ.get("BYOND_CACHE")
    if env_cache and Path(env_cache).is_dir():
        return env_cache

    search_locations = [
        # Windows
        home / "*" / "BYOND" / "cache",
        # Wine
        home / ".wine" / "drive_c" / "users" / "*" / "*" / "BYOND" / "cache",
        # Lutris
        home / "Games" / "byond" / "drive_c" / "users" / "*" / "*" / "BYOND" / "cache",
        # WSL
        Path("/mnt/c/Users") / "*" / "*" / "BYOND" / "cache",
    ]

    for pattern in search_locations:
        matches = glob.glob(str(pattern))
        if matches:
            print(f"[reloader] found cache at '{matches[0]}'")
            return matches[0]

    # Windows Registry fallback
    if platform.system() == "Windows":
        try:
            result = subprocess.run(
                ["reg", "query", r"HKCU\Software\Dantom\BYOND", "/v", "userpath"],
                capture_output=True, text=True, timeout=5,
            )
            match = re.search(r"userpath\s+REG_SZ\s+(.+)", result.stdout)
            if match:
                userpath = match.group(1).strip().rstrip("\\")
                cache_path = os.path.join(userpath, "cache")
                if os.path.isdir(cache_path):
                    print(f"[reloader] found cache via registry at '{cache_path}'")
                    return cache_path
        except (subprocess.TimeoutExpired, FileNotFoundError):
            pass

    print("[reloader] could not find BYOND cache directory")
    return None


def find_dreamseeker_instances(pids: list[int]) -> list[str]:
    """Find DreamSeeker network addresses by PIDs using netstat."""
    if platform.system() != "Windows":
        return []

    try:
        result = subprocess.run(
            ["netstat", "-ano"],
            capture_output=True, text=True, timeout=10,
        )
        addresses = []
        for line in result.stdout.splitlines():
            if "TCP" not in line or "0.0.0.0:0" not in line:
                continue
            parts = line.split()
            if len(parts) >= 5:
                try:
                    pid = int(parts[4])
                    if pid in pids:
                        addresses.append(parts[1])
                except ValueError:
                    continue
        return addresses
    except (subprocess.TimeoutExpired, FileNotFoundError):
        return []


def notify_dreamseeker(addresses: list[str]) -> None:
    """Send cache reload notification to DreamSeeker instances."""
    for addr in addresses:
        url = f"http://{addr}/dummy.htm?tgui=1&type=cacheReloaded"
        try:
            urllib.request.urlopen(url, timeout=2)
            print(f"[reloader] notified DreamSeeker at {addr}")
        except Exception:
            pass


def collect_bundles(bundle_dir: str) -> list[str]:
    """Collect all bundle files from the bundle directory."""
    files = []
    for pattern in BUNDLE_PATTERNS:
        files.extend(glob.glob(os.path.join(bundle_dir, pattern)))
    return files


def reload_cache(bundle_dir: str, cache_root: str) -> None:
    """Copy bundles into BYOND cache and notify DreamSeeker."""
    # Find tmp directories in cache
    tmp_dirs = glob.glob(os.path.join(cache_root, "tmp*"))
    if not tmp_dirs:
        print("[reloader] no tmp folders found in cache")
        return

    # Get PIDs from tmp folder names
    pids = []
    for tmp_dir in tmp_dirs:
        basename = os.path.basename(tmp_dir)
        try:
            pid = int(basename.replace("tmp", ""))
            pids.append(pid)
        except ValueError:
            continue

    # Collect bundles
    bundles = collect_bundles(bundle_dir)
    if not bundles:
        print("[reloader] no bundle files found")
        return

    # Copy to each cache dir
    for tmp_dir in tmp_dirs:
        # Clean old bundles
        for pattern in BUNDLE_PATTERNS:
            for old_file in glob.glob(os.path.join(tmp_dir, pattern)):
                os.remove(old_file)

        # Write dummy file
        dummy_path = os.path.join(tmp_dir, "dummy.htm")
        Path(dummy_path).write_text("")

        # Copy new bundles
        for bundle in bundles:
            dest = os.path.join(tmp_dir, os.path.basename(bundle))
            shutil.copy2(bundle, dest)

        print(f"[reloader] copied {len(bundles)} files to '{tmp_dir}'")

    # Write dummy to cache root too
    Path(os.path.join(cache_root, "dummy.htm")).write_text("")

    # Notify DreamSeeker
    addresses = find_dreamseeker_instances(pids)
    if addresses:
        notify_dreamseeker(addresses)


def watch_and_reload(bundle_dir: str, cache_root: str) -> None:
    """Watch bundle directory for changes and reload on change."""
    print(f"[reloader] watching '{bundle_dir}' for changes...")

    last_mtimes: dict[str, float] = {}

    while True:
        bundles = collect_bundles(bundle_dir)
        current_mtimes = {f: os.path.getmtime(f) for f in bundles}

        if current_mtimes != last_mtimes and last_mtimes:
            print(f"[reloader] change detected, reloading...")
            reload_cache(bundle_dir, cache_root)

        last_mtimes = current_mtimes
        time.sleep(1)


def main():
    parser = argparse.ArgumentParser(description="BYOND Cache Reloader")
    parser.add_argument(
        "--bundle-dir",
        default=os.path.join(os.path.dirname(__file__), "..", "compiled"),
        help="Path to compiled bundles directory",
    )
    parser.add_argument(
        "--watch",
        action="store_true",
        help="Watch for changes and reload automatically",
    )
    args = parser.parse_args()

    bundle_dir = os.path.abspath(args.bundle_dir)
    if not os.path.isdir(bundle_dir):
        print(f"[reloader] bundle directory not found: {bundle_dir}")
        sys.exit(1)

    cache_root = find_byond_cache()
    if not cache_root:
        sys.exit(1)

    if args.watch:
        watch_and_reload(bundle_dir, cache_root)
    else:
        reload_cache(bundle_dir, cache_root)


if __name__ == "__main__":
    main()

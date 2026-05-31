import argparse
import gzip
import os
import socket
import subprocess
import sys
import tarfile
import tempfile
from abc import ABC, abstractmethod
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

import requests
from packaging.version import Version


def normalize_version(v: str) -> str:
    return v.lstrip("vV")


def is_newer_version(current_version: str, upstream_version: str) -> bool:
    return Version(normalize_version(upstream_version)) > Version(
        normalize_version(current_version)
    )


@dataclass(frozen=True)
class UpstreamInfo:
    version: str
    download_url: str


class App(ABC):

    _force_install: bool

    def __init__(self, force_install: bool) -> None:
        self._force_install = force_install

    @abstractmethod
    def get_current_version(self) -> str: ...

    @abstractmethod
    def get_upstream_info(self) -> UpstreamInfo: ...

    @abstractmethod
    def install(self) -> None: ...

    def update(self) -> None:
        class_name = self.__class__.__name__

        if self._force_install:
            print(f"Installing {class_name}")
            self.install()
            return

        print(f"Updating {class_name}")

        current_version = self.get_current_version()
        upstream_info = self.get_upstream_info()

        if not is_newer_version(current_version, upstream_info.version):
            print("Already up to date")
            return

        print(
            f"Would you like to update from {current_version} to {upstream_info.version}? [y/N]"
        )
        if input().lower() != "y":
            return

        self.install()


class GithubReleaseApp(App):

    @property
    @abstractmethod
    def github_repo(self) -> str: ...

    @property
    @abstractmethod
    def asset_pattern(self) -> str: ...

    def get_upstream_info(self) -> UpstreamInfo:
        url = f"https://api.github.com/repos/{self.github_repo}/releases/latest"
        resp = requests.get(url, headers={"Accept": "application/vnd.github+json"})
        resp.raise_for_status()
        data = resp.json()

        if "tag_name" not in data:
            raise RuntimeError(f"Failed to get latest version from {url}")
        version: str = data["tag_name"]

        if "assets" not in data:
            raise RuntimeError(f"Failed to get assets from {url}")

        assets = data["assets"]
        download_url: Optional[str] = None
        for asset in assets:
            if "name" not in asset:
                continue

            release_name = asset["name"]
            if self.asset_pattern in release_name:
                download_url = asset["browser_download_url"]
                break

        if download_url is None:
            raise RuntimeError(f"Failed to get asset from {url}")

        return UpstreamInfo(version=version, download_url=download_url)


class StretchlyRpmApp(GithubReleaseApp):
    @property
    def github_repo(self) -> str:
        return "hovancik/stretchly"

    @property
    def asset_pattern(self) -> str:
        return "aarch64.rpm"

    def get_current_version(self) -> str:
        result = subprocess.run(
            ["rpm", "-q", "--queryformat", "%{VERSION}", "Stretchly"],
            capture_output=True,
            text=True,
            timeout=10,
        )
        output = result.stdout.strip()
        return output

    def install(self) -> None:
        with tempfile.TemporaryDirectory() as tmpdir:
            tmpdir_path = Path(tmpdir)
            download_url = self.get_upstream_info().download_url
            print(f"Downloading {download_url}")
            r = requests.get(download_url, stream=True)
            r.raise_for_status()
            download_file_name = tmpdir_path / "stretchly.rpm"
            with download_file_name.open("wb") as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)

            cmd_args = ["dnf", "install", "-y", download_file_name.as_posix()]
            cmd = " ".join(cmd_args)
            print(f"Execute '{cmd}'")
            subprocess.run(cmd_args)


class RmpcAarch64App(GithubReleaseApp):
    @property
    def github_repo(self) -> str:
        return "mierak/rmpc"

    @property
    def asset_pattern(self) -> str:
        return "aarch64-unknown-linux-gnu.tar.gz"

    def install(self) -> None:
        install_path = Path("/usr/local/bin/rmpc")

        with tempfile.TemporaryDirectory() as tmpdir:
            tmpdir_path = Path(tmpdir)
            download_url = self.get_upstream_info().download_url
            print(f"Downloading {download_url}")
            r = requests.get(download_url, stream=True)
            r.raise_for_status()
            download_file_name = tmpdir_path / "rmpc.tar.gz"
            with download_file_name.open("wb") as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)

            print(f"Extracting {download_file_name}")
            with tarfile.open(download_file_name.as_posix()) as tar:
                tar.extractall(path=tmpdir_path)

            rmpc_path = tmpdir_path / "rmpc"
            print(f"Installing {rmpc_path} to {install_path}")
            tmp_path = install_path.with_name(".rmpc.tmp")
            rmpc_path.copy(tmp_path)
            tmp_path.replace(install_path)
            install_path.chmod(0o755)

    def get_current_version(self) -> str:
        result = subprocess.run(
            ["rmpc", "version"],
            capture_output=True,
            text=True,
            timeout=10,
        )
        output = result.stdout.strip()
        return output.split(" ")[-1]


class BeancountLanguageServerArm64(GithubReleaseApp):
    @property
    def github_repo(self) -> str:
        return "polarmutex/beancount-language-server"

    @property
    def asset_pattern(self) -> str:
        return "linux-arm64.gz"

    def install(self) -> None:
        install_path = Path("/usr/local/bin/beancount-language-server")

        with tempfile.TemporaryDirectory() as tmpdir:
            tmpdir_path = Path(tmpdir)
            download_url = self.get_upstream_info().download_url
            print(f"Downloading {download_url}")
            r = requests.get(download_url, stream=True)
            r.raise_for_status()
            download_file_name = tmpdir_path / "beancount-language-server.gz"
            with download_file_name.open("wb") as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)

            print(f"Extracting {download_file_name}")
            extracted_bin = tmpdir_path / "beancount-language-server"
            with gzip.open(download_file_name.as_posix(), "rb") as gz_f:
                extracted_bin.write_bytes(gz_f.read())

            print(f"Installing {extracted_bin} to {install_path}")
            tmp_path = install_path.with_name(".beancount-language-server.tmp")
            extracted_bin.copy(tmp_path)
            tmp_path.replace(install_path)
            install_path.chmod(0o755)

    def get_current_version(self) -> str:
        result = subprocess.run(
            ["beancount-language-server", "--version"],
            capture_output=True,
            text=True,
            timeout=10,
        )
        output = result.stdout.strip()
        return output.split(" ")[-1]


class ZkArm64(GithubReleaseApp):
    @property
    def github_repo(self) -> str:
        return "zk-org/zk"

    @property
    def asset_pattern(self) -> str:
        return "linux-arm64.tar.gz"

    def install(self) -> None:
        install_path = Path("/usr/local/bin/zk")

        with tempfile.TemporaryDirectory() as tmpdir:
            tmpdir_path = Path(tmpdir)
            download_url = self.get_upstream_info().download_url
            print(f"Downloading {download_url}")
            r = requests.get(download_url, stream=True)
            r.raise_for_status()
            download_file_name = tmpdir_path / "rmpc.tar.gz"
            with download_file_name.open("wb") as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)

            print(f"Extracting {download_file_name}")
            with tarfile.open(download_file_name.as_posix()) as tar:
                tar.extractall(path=tmpdir_path)

            zk_path = tmpdir_path / "zk"
            print(f"Installing {zk_path} to {install_path}")
            tmp_path = install_path.with_name(".zk.tmp")
            zk_path.copy(tmp_path)
            tmp_path.replace(install_path)
            install_path.chmod(0o755)

    def get_current_version(self) -> str:
        result = subprocess.run(
            ["zk", "--version"],
            capture_output=True,
            text=True,
            timeout=10,
        )
        output = result.stdout.strip()
        return output.split(" ")[-1]


class HyprdynamicmonitorsArm64(GithubReleaseApp):
    @property
    def github_repo(self) -> str:
        return "fiffeek/hyprdynamicmonitors"

    @property
    def asset_pattern(self) -> str:
        return "Linux_arm64.tar.gz"

    def install(self) -> None:
        install_path = Path("/usr/local/bin/hyprdynamicmonitors")

        with tempfile.TemporaryDirectory() as tmpdir:
            tmpdir_path = Path(tmpdir)
            download_url = self.get_upstream_info().download_url
            print(f"Downloading {download_url}")
            r = requests.get(download_url, stream=True)
            r.raise_for_status()
            download_file_name = tmpdir_path / "hyprdynamicmonitors.tar.gz"
            with download_file_name.open("wb") as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)

            print(f"Extracting {download_file_name}")
            with tarfile.open(download_file_name.as_posix()) as tar:
                tar.extractall(path=tmpdir_path)

            hyprdynamicmonitors_path = tmpdir_path / "hyprdynamicmonitors"
            print(f"Installing {hyprdynamicmonitors_path} to {install_path}")
            tmp_path = install_path.with_name(".hyprdynamicmonitors.tmp")
            hyprdynamicmonitors_path.copy(tmp_path)
            tmp_path.replace(install_path)
            install_path.chmod(0o755)

    def get_current_version(self) -> str:
        result = subprocess.run(
            ["hyprdynamicmonitors", "-v"],
            capture_output=True,
            text=True,
            timeout=10,
        )
        output = result.stdout.strip()
        return output.split(" ")[2]


if __name__ == "__main__":
    parser = argparse.ArgumentParser("third_party_software_manager")

    parser.add_argument(
        "--install",
        required=False,
        default=False,
        action="store_true",
        help="Install softwares but not update",
    )

    args = parser.parse_args()

    if os.geteuid() != 0:
        print("Please run as root")
        sys.exit(1)

    os.environ.setdefault("http_proxy", "http://127.0.0.1:7890")
    os.environ.setdefault("https_proxy", "http://127.0.0.1:7890")

    force_install = args.install

    hostname = socket.gethostname()
    if hostname == "luo-arch":
        print("No self managed apps to update")
    elif hostname == "luo-asahi":
        apps = [
            RmpcAarch64App(force_install),
            StretchlyRpmApp(force_install),
            BeancountLanguageServerArm64(force_install),
            ZkArm64(force_install),
            HyprdynamicmonitorsArm64(force_install),
        ]

        for app in apps:
            app.update()

    else:
        print("Unknown host, no action")

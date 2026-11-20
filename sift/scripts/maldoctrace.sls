# Name: MaldocTrace
# Website: https://github.com/debugactiveprocess/MaldocTrace
# Description: Static analyzer and safe VBA emulator for malicious Office documents
# Category:
# Author: debugactiveprocess
# License: Apache License 2.0 (https://github.com/debugactiveprocess/MaldocTrace/blob/main/LICENSE)
# Notes: maldoctrace

{% set version = "0.6.0" -%}
{%- if grains["osarch"] == "aarch64" or grains["osarch"] == "arm64" -%}
{%- set arch = "arm64" -%}
{%- set hash = "4925f17aeb2aeb6df40e0fa252904bcccf2d47088f69a75d6c661966d0e71b34" -%}
{%- else -%}
{%- set arch = "amd64" -%}
{%- set hash = "b760942d79911fe9697310e48916e6ccee965077e1aea913233dbbcec260a969" -%}
{%- endif -%}
{%- set folder = "maldocTrace_" ~ version ~ "_linux_" ~ arch -%}
{%- set filename = folder ~ ".tar.gz" -%}
{%- set base_url = "https://github.com/debugactiveprocess/MaldocTrace/releases/download/v" -%}

sift-scripts-maldoctrace-source:
  file.managed:
    - name: /var/cache/sift/archives/{{ filename }}
    - source: "{{ base_url }}{{ version }}/{{ filename }}"
    - source_hash: sha256={{ hash }}
    - makedirs: True

sift-scripts-maldoctrace-archive:
  archive.extracted:
    - name: /opt/maldoctrace
    - source: /var/cache/sift/archives/{{ filename }}
    - force: True
    - watch:
      - file: sift-scripts-maldoctrace-source

sift-scripts-maldoctrace:
  file.symlink:
    - name: /usr/local/bin/maldoctrace
    - target: /opt/maldoctrace/{{ folder }}/maldocTrace
    - force: True
    - require:
      - archive: sift-scripts-maldoctrace-archive

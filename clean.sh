#!/bin/bash

# Run this first to remove ./plugins-config/WorldEdit/.archive-unpack, a cache protected dir.
# Only root can read this cache files. Removing them cleans the project

sudo rm -rf ./plugins-config/WorldEdit/.archive-unpack
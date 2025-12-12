#!/bin/bash
export INPUT_TOKEN=$(doppler secrets get GITHUB_PAT_TOKEN_LOCALDEV --plain 2>/dev/null)
./run-action-local.sh

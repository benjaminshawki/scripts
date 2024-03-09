#!/usr/bin/env bash
FZF_DIR=$(find . -type d | fzf) && [ -n "$FZF_DIR" ] && cd "$FZF_DIR"

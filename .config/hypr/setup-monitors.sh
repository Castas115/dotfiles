#!/usr/bin/env bash

hyprctl keyword workspace "name:V, monitor:desc:HP Inc. HP P24h G5 3CM5090R7B"

if hyprctl monitors | grep -q "HP Inc. HP P24h G5"; then
    # Work setup
    hyprctl keyword workspace "3, name:C, monitor:desc:HP Inc. HP P24h G5 3CM5090R7B"
    hyprctl keyword workspace "name:V, monitor:desc:HP Inc. HP P24h G5 3CM5090R7B"
    # ... other workspaces
elif hyprctl monitors | grep -q "Philips Consumer Electronics Company PHL 243V7"; then
    # Home setup
    hyprctl keyword workspace "3, name:C, monitor:desc:Philips Consumer Electronics Company PHL 243V7 UK02128017955"
    # ... other workspaces
fi

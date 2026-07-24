#!/usr/bin/env bash

set -euo pipefail

battery="$(upower -e | grep -m1 -i 'BAT' || true)"

if [[ -z "${battery}" ]]; then
    printf '{"text": "n/a", "class": "degraded", "tooltip": "No battery detected"}\n'
    exit 0
fi

read -r ef efd cycles < <(upower -i "${battery}" | awk '
    /energy-full:/        { ef  = $2 }
    /energy-full-design:/ { efd = $2 }
    /charge-cycles:/      { cyc = $2 }
    END { print ef, efd, (cyc ? cyc : "?") }
')

if [[ -z "${efd}" ]] || (( $(echo "${efd} <= 0" | bc -l) )); then
    printf '{"text": "?", "class": "", "tooltip": "Could not read battery data"}\n'
    exit 0
fi

degradation=$(echo "(1 - ${ef}/${efd}) * 100 + 0.5" | bc -l)

case "${degradation}" in
    .*)  degradation="0${degradation}" ;;
    -.*) degradation="-0${degradation#-}" ;;
esac
degradation=$(echo "${degradation}" | cut -d'.' -f1)
degradation="${degradation:-0}"

[[ "${degradation}" == "-0" ]] && degradation="0"
if (( degradation < 0 )); then degradation=0; fi
health=$(echo "100 - ${degradation}" | bc)

if   (( degradation > 25 )); then css_class="degraded"
elif (( degradation > 10 )); then css_class="warning"
else                               css_class=""
fi

tooltip="${degradation}% wear (${health}% health) — ${cycles} cycles"

printf '{"text": "%d", "class": "%s", "tooltip": "%s"}\n' \
    "${degradation}" "${css_class}" "${tooltip}"

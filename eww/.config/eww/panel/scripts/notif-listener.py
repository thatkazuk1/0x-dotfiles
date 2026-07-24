#!/usr/bin/env python3
"""Notification history for the eww panel.

Listens (read-only) to org.freedesktop.Notifications `Notify` method calls
on the session bus via dbus-monitor, and maintains a JSON store at
~/.cache/eww-notifications.json. swaync stays the daemon and keeps drawing
banners; this script never answers or interferes with the bus — it only
observes, so it can coexist with swaync indefinitely.

On every new notification it atomically rewrites the store and pushes the
fresh array into the eww variable `notifications` (push failures are
ignored, e.g. when the eww daemon isn't up — the store file remains the
source of truth and the defpoll picks it up).

Start once per session from hyprland.conf:
  exec-once = ~/.config/eww/panel/scripts/notif-listener.py
"""

import fcntl
import json
import os
import re
import subprocess
import sys
import time

STORE = os.path.expanduser("~/.cache/eww-notifications.json")
LOCK = os.path.expanduser("~/.cache/eww-notif-listener.lock")
MAX_ITEMS = 30
BODY_LIMIT = 140
IGNORE_APPS = set()

STR_RE = re.compile(r'^\s*string "(.*)"$')
STR_OPEN_RE = re.compile(r'^\s*string "(.*)$')


def single_instance():
  """Exit quietly if another listener already runs (e.g. hyprctl reload)."""
  fd = os.open(LOCK, os.O_CREAT | os.O_RDWR)
  try:
    fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
  except BlockingIOError:
    sys.exit(0)
  return fd  # keep fd alive for process lifetime


def load_store():
  try:
    with open(STORE) as f:
      data = json.load(f)
      return data if isinstance(data, list) else []
  except (OSError, ValueError):
    return []


def save_and_push(items):
  tmp = STORE + ".tmp"
  with open(tmp, "w") as f:
    json.dump(items, f)
  os.replace(tmp, STORE)
  try:
    subprocess.run(
      ["eww", "update", "notifications=" + json.dumps(items)],
      capture_output=True,
    )
  except OSError:
    # eww not in this session's PATH or daemon down — the store file
    # is still written, and the panel's defpoll picks it up.
    pass


def add_notification(app, summary, body):
  if app in IGNORE_APPS:
    return
  if not summary and not body:
    return
  items = load_store()
  new_id = int(time.time() * 1000)
  if items and new_id <= items[0].get("id", 0):
    new_id = items[0]["id"] + 1  # same-ms arrivals stay unique
  items.insert(0, {
    "id": new_id,
    "app": app or "Notification",
    "summary": summary,
    "body": body[:BODY_LIMIT],
    "time": time.strftime("%H:%M"),
  })
  save_and_push(items[:MAX_ITEMS])


def read_string(lines_iter, first_line):
  """Parse a dbus-monitor string value, tolerating embedded newlines."""
  m = STR_RE.match(first_line)
  if m:
    return m.group(1)
  m = STR_OPEN_RE.match(first_line)
  if not m:
    return None
  parts = [m.group(1)]
  for line in lines_iter:
    line = line.rstrip("\n")
    if line.endswith('"'):
      parts.append(line[:-1])
      break
    parts.append(line)
  return "\n".join(parts)


def main():
  single_instance()
  proc = subprocess.Popen(
    [
      "dbus-monitor",
      "type='method_call',interface='org.freedesktop.Notifications',"
      "member='Notify'",
    ],
    stdout=subprocess.PIPE,
    text=True,
    bufsize=1,
  )
  lines = iter(proc.stdout.readline, "")
  strings = None  # None = not inside a Notify call
  for line in lines:
    if "member=Notify" in line and "interface=org.freedesktop.Notifications" in line:
      strings = []
      continue
    if strings is None:
      continue
    s = read_string(lines, line.rstrip("\n"))
    if s is not None:
      strings.append(s)
      # Notify signature: app_name, (replaces_id), app_icon, summary, body
      if len(strings) == 4:
        app, _icon, summary, body = strings
        add_notification(app, summary, body)
        strings = None
    elif "method call" in line:
      strings = []  # unrelated header; reset


if __name__ == "__main__":
  main()

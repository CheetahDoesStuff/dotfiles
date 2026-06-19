import evdev
import subprocess
from evdev import ecodes as e

KEYBOARD = "/dev/input/event23"

device = evdev.InputDevice(KEYBOARD)
meta_held = False

for event in device.read_loop():
    if event.type != e.EV_KEY:
        continue
    if event.code == e.KEY_LEFTMETA:
        meta_held = event.value == 1
    if event.code == e.KEY_C and event.value == 1 and meta_held:
        subprocess.run(["bash", "/home/cheetah/scripts/autoclicker.sh"])

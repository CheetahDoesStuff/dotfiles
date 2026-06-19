import evdev
import threading
import time
import subprocess
from evdev import UInput, ecodes as e

MOUSE_DEVICE = "/dev/input/event8"
KEYBOARD_DEVICE = "/dev/input/event23"
CLICK_INTERVAL = 1 / 20

mouse = evdev.InputDevice(MOUSE_DEVICE)
keyboard = evdev.InputDevice(KEYBOARD_DEVICE)
ui = UInput(
    {e.EV_KEY: [e.BTN_LEFT, e.BTN_RIGHT]},
    name="autoclicker-virtual"
)

enabled = False
left_held = False
right_held = False
lock = threading.Lock()

def click_loop():
    while True:
        with lock:
            en = enabled
            lh = left_held
            rh = right_held
        if en:
            if lh:
                ui.write(e.EV_KEY, e.BTN_LEFT, 1)
                ui.syn()
                time.sleep(0.005)
                ui.write(e.EV_KEY, e.BTN_LEFT, 0)
                ui.syn()
            if rh:
                ui.write(e.EV_KEY, e.BTN_RIGHT, 1)
                ui.syn()
                time.sleep(0.005)
                ui.write(e.EV_KEY, e.BTN_RIGHT, 0)
                ui.syn()
            if lh or rh:
                time.sleep(CLICK_INTERVAL)
            else:
                time.sleep(0.005)
        else:
            time.sleep(0.005)

def mouse_loop():
    global left_held, right_held
    for event in mouse.read_loop():
        if event.type == e.EV_KEY and event.code == e.BTN_LEFT:
            with lock:
                left_held = event.value == 1
        elif event.type == e.EV_KEY and event.code == e.BTN_RIGHT:
            with lock:
                right_held = event.value == 1

def keyboard_loop():
    global enabled
    meta_held = False
    for event in keyboard.read_loop():
        if event.type != e.EV_KEY:
            continue
        if event.code == e.KEY_LEFTMETA:
            meta_held = event.value == 1
        if event.code == e.KEY_C and event.value == 1 and meta_held:
            with lock:
                enabled = not enabled
            msg = "ON" if enabled else "OFF"
            subprocess.Popen(["notify-send", "Autoclicker", msg, "--icon=input-mouse"])

threading.Thread(target=mouse_loop, daemon=True).start()
threading.Thread(target=click_loop, daemon=True).start()

keyboard_loop()

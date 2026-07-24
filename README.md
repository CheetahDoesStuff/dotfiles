# Nightfall
**An actively maintained rice for the MangoWM window manager mostly written in quickshell**

## Pictures / Showcase
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/c96a5676-81c4-4379-86a6-382581f89495" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/4c3306a8-ff2d-4804-9132-dac4a96f0952" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/35d64e40-2731-41fc-8f10-2b0ecdc55380" />

## Features
**Main Features**
- Bar, with workspaces, window titles, internet and bluetooth sttatus, clock and a convenient screenshot button
- An application launcher, with a clean and simple ui that you can operate with either keyboard or keyboard and mouse
- A tool launcher, that gives you access to multiple built in tools listed below

**Tools**
- A QR code scanner, that copies any detected urls to your clipboard

## Planned features
**Main Features**
- Network manager gui
- Bluetooth manager gui
- Custom notification popups & notification centre
- Wallpaper switcher - for now you will have to manually switch wallpapers via awww

**Tools**
- Text detection in image tool (to copy text you cant select)

## Installation
**Note: This installation guide is focused on arch linux, while this rice probably works on other distros, i will only give exact package names for everything for arch linux.**
This is packaged using the [chezmoi](https://www.chezmoi.io/) dotfile manager, and therefore to install you have to install chezmoi, and then you can simply run
```bash
chezmoi init --apply CheetahDoesStuff
```

After this you also have to install the required packages, which i have written a convenient little script for!
```bash
curl -fsSL https://l.ch0.dev/7 | bash
```

Then, reboot your computer and it should be all set up!

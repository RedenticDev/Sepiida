<img width="100" src="./Preferences/Resources/icon@3x.png" alt="Sepiida icon" />

# Sepiida

Make the 3D Touch menu yours. Made for **iOS 13 & 14** (started around March 2021).

---
> **Warning**  
> **This tweak is unfinished and will probably never be finished** because I don't have the time to work on it at the moment. If you want to contribute, feel free to open a pull request.  
> The tweak probably won't be published on my repo, but you can [build it yourself](#installation).  
> If you see something that doesn't make sense or that's wrong, don't hesitate to open an issue or contact me on [Twitter](https://twitter.com/RedenticDev).

## Features

### Tweak

- Remove/reorder items from the menu
- Change each item's height or menu's corner radius
- Hide separators or status bar
- Add device info to the Settings menu
- Change theme, colors, and blur for menu, items, and background

### Preferences

- **New design system**
- Respring-less experience, except for the Enable switch (allowing you to fully unload the tweak)
- Dynamic, RTL-compatible, and programmatic banner
- Scroll-aware title bar
- Modal sheet with new update changelogs
- Automatic update checker
- Full changelog in a subpage
- "Test setup" button, with optional support of Vexillarius
- DRM for a safer experience
- and more!

## Additional work needed

### iOS 13

- Fix the corner radius not working
- Fix the menu coloring not working
- Fix the animation for the background color

### iOS 14

- Add/check support for folders (on iOS 13 too) and widgets

### General

- Change the call for status bar hiding for better reliability
- Global FIXMEs, TODOs, and code improvements
- Finish the localization support

## Installation

Clone the repository and run `make package FINALPACKAGE=1` in the root directory. The package will be available in the `packages` folder.

## Issues & Contributions

For issues, you can either open a GitHub issue or contact me on [Twitter](https://twitter.com/RedenticDev). I will probably not fix anything though, as I don't have the time to work on this project at the moment.  
If you want to contribute, feel free to open a pull request.

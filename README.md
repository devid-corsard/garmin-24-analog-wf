# 24hAnalog Watch Face

A 24-hour analog watch face for Garmin devices that displays time in a full-day rotation format.

## Install

copy file `bin/24hAnalog.prg` to garmin/apps folder on device

## Overview

Most analog watches complete a full revolution every 12 hours, making it difficult to distinguish between AM and PM. This watch face solves that problem by implementing a 24-hour dial where the hour hand makes exactly one complete revolution per day.

## Features

- **24-Hour Dial**: Hour markers and numbers from 0 to 23
- **Three-Hand Display**:
  - Hour hand (red, thick) - completes one rotation per day
  - Minute hand (white, medium thickness) - completes one rotation per hour
  - Second hand (yellow, thin) - completes one rotation per minute
- **Minimalist Design**: Clean interface with hour markers and numbers
- **Hour Markers**: Visual markers at each hour position

## Design Details

- The hour hand completes a full 360° rotation once per day (15° per hour)
- Hour markers are placed at 15° intervals
- Numbers 0-23 are displayed around the dial for easy reading

## Installation

1. Connect your Garmin device to your computer
2. Transfer the compiled .prg file to the "GARMIN/APPS" directory on your device
3. Disconnect your device

## Development

This watch face is developed using Monkey C and the Garmin Connect IQ SDK. Key components:

- **24hAnalogView.mc**: Contains the core watch face implementation
  - `drawWatchFace()`: Handles the rendering of the 24-hour dial and markers
  - `drawHands()`: Calculates and draws the position of each hand

## Compatibility

Compatible with Garmin devices that support Connect IQ watch faces.

## License

This project is available for personal use and modification.
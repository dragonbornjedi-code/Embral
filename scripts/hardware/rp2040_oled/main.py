from machine import Pin, I2C
import ssd1306
import time

# I2C configuration for RP2040-Zero
# SDA -> GP0
# SCL -> GP1
i2c = I2C(0, sda=Pin(0), scl=Pin(1), freq=400000)

# Initialize OLED (128x64)
# Address 0x3C is standard
display = ssd1306.SSD1306_I2C(128, 64, i2c)

def show_ezra_quest():
    # Clear display
    display.fill(0)
    
    # Header
    display.text("EZRA'S QUEST", 15, 5)
    display.hline(0, 15, 128, 1)
    
    # Body
    display.text("STATUS: ONLINE", 0, 25)
    display.text("LEVEL: STUMP", 0, 40)
    display.text("READY TO PLAY", 0, 55)
    
    # Show it
    display.show()

if __name__ == "__main__":
    print("Initializing Ezra's Quest screen...")
    show_ezra_quest()
    print("Done!")

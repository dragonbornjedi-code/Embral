# 3D Print Instructions: Never-Ending Infinity Cube

Congratulations on your first print! You have chosen an "S-Tier" fidget toy. This model is a **Print-in-Place** design, meaning it comes off the bed as a single moving piece with no assembly required.

## 📦 Model Information
- **Name:** Sturdy Infinity Cube (Size M)
- **Design:** Print-in-place hinges (no assembly)
- **File:** `infinity_cube_M.stl`

## 🛠 Slicer Configuration (Important!)
To ensure the hinges don't fuse together, use these specific settings in your slicer (Cura, PrusaSlicer, or OrcaSlicer):

| Setting | Recommended Value | Why? |
| :--- | :--- | :--- |
| **Layer Height** | **0.2mm** | Best balance for hinge tolerances. Do not go higher than 0.2mm. |
| **Supports** | **OFF** | Built-in hinges will be ruined by supports. |
| **Walls / Perimeters** | **3** | Makes the hinges strong enough to survive "breaking in". |
| **Infill** | **15% - 20%** | Gyroid pattern provides a satisfying weight and strength. |
| **Bottom Layers** | **4** | Ensures a solid base for the hinges. |
| **Print Speed** | **50-60 mm/s** | Slow and steady ensures the hinges print cleanly. |
| **Cooling Fan** | **100%** | Keeps the plastic from sagging and fusing the hinges. |

## 🧵 Material Recommendation
- **Best Choice:** **PLA** (Any color). PLA is rigid and prints with high detail, which is perfect for hinges.
- **Avoid:** TPU (too flexible) or PETG (too much "stringing" can fuse the hinges).

## 🚀 Post-Print: "The First Snap"
When the print finishes, it will feel like a solid block. **This is normal.**
1. Let the print cool completely before removing it from the bed.
2. Carefully pick up the cube and find the hinge lines.
3. Gently but firmly "snap" each section to break the tiny internal sacrificial bridges.
4. Work the cube back and forth for 5 minutes to smooth out the motion. It will get better with use!

## 🏁 Finishing Touches
- **Sanding:** If there are rough edges on the bottom, use 400-grit sandpaper to smooth them.
- **Lubrication:** A tiny drop of dry PTFE lubricant or even a bit of vegetable oil on the hinges can make it "butter smooth," though it's not strictly necessary.

---

## 📋 QUICK COPY-PASTE SLICER LIST
*Keep this list open while you configure your slicer (Cura/Prusa/Orca):*

**PRIMARY SETTINGS:**
- **Layer Height:** 0.2 mm
- **Initial Layer Height:** 0.2 mm
- **Supports:** Disabled (None)
- **Wall Loops/Count:** 3
- **Top Layers:** 4
- **Bottom Layers:** 4
- **Infill Density:** 20%
- **Infill Pattern:** Gyroid (Recommended)

**SPEED & COOLING:**
- **Print Speed:** 50 mm/s
- **Outer Wall Speed:** 25 mm/s
- **Fan Speed:** 100% (after Layer 2)
- **Minimum Layer Time:** 10 seconds

---

## 🎛 Klipper Pad 8 Integration
I attempted to reach your Klipper Pad at `http://192.168.1.174/`, but since it is on your local private network, I cannot access it directly from my cloud environment.

**How to start the print:**
1. Open your browser and go to `http://192.168.1.174/`.
2. Navigate to the **"Jobs"** or **"Files"** tab.
3. Drag and drop the `infinity_cube_M.stl` from your computer into the Klipper interface.
4. Slice it using your preferred slicer first (if you haven't) or use the built-in slicer if your Pad 7 has one.
5. Click **"Print"**!

Enjoy your first 3D print!

from PIL import Image, ImageDraw, ImageFont
import math, os

def create_dgi_health_icon(size=1024, transparent=False, padding_ratio=0.0):
    # Adaptive icons need a safe zone. Foreground should be in the center ~66% (radius ~33%)
    if transparent:
        img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    else:
        img = Image.new('RGBA', (size, size), (30, 64, 175, 255))
    
    draw = ImageDraw.Draw(img)

    # Calculate content scale
    content_scale = 1.0 - (padding_ratio * 2)
    content_size = int(size * content_scale)
    offset = (size - content_size) // 2

    if not transparent:
        # Background — ko'k gradient (rounded rect)
        radius = int(size * 0.22)
        margin = 0

        # Gradient background
        for i in range(size):
            ratio = i / size
            r = int(30 + (14 - 30) * ratio)
            g = int(64 + (165 - 64) * ratio)
            b = int(175 + (233 - 175) * ratio)
            draw.rectangle([margin, i, size - margin, i + 1], fill=(r, g, b, 255))

        # Rounded corners mask (only for full icon, not adaptive foreground)
        mask = Image.new('L', (size, size), 0)
        mask_draw = ImageDraw.Draw(mask)
        mask_draw.rounded_rectangle([margin, margin, size - margin, size - margin],
                                      radius=radius, fill=255)
        img.putalpha(mask)

    # Re-draw object to apply text
    draw = ImageDraw.Draw(img)
    
    # Text sizes scaled down relative to content_size
    dgi_size = int(content_size * 0.38)
    health_size = int(content_size * 0.13)

    fonts_to_try = [
        "C:\\Windows\\Fonts\\arialbd.ttf",
        "C:\\Windows\\Fonts\\segoeuib.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        "arialbd.ttf"
    ]
    
    font_dgi = None
    for f in fonts_to_try:
        try:
            font_dgi = ImageFont.truetype(f, dgi_size)
            break
        except:
            continue
    
    if font_dgi is None:
        font_dgi = ImageFont.load_default()

    fonts_health_to_try = [
        "C:\\Windows\\Fonts\\arial.ttf",
        "C:\\Windows\\Fonts\\segoeui.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "arial.ttf"
    ]
    
    font_health = None
    for f in fonts_health_to_try:
        try:
            font_health = ImageFont.truetype(f, health_size)
            break
        except:
            continue
    
    if font_health is None:
        font_health = ImageFont.load_default()

    # Calculate text positions within the content area
    dgi_bbox = draw.textbbox((0, 0), "DGI", font=font_dgi)
    dgi_w = dgi_bbox[2] - dgi_bbox[0]
    dgi_h = dgi_bbox[3] - dgi_bbox[1]
    
    # Center text in the whole image
    dgi_x = (size - dgi_w) // 2
    # Adjust y to be centered vertically within the safe zone
    dgi_y = offset + int(content_size * 0.25)
    
    draw.text((dgi_x, dgi_y), "DGI", font=font_dgi, fill=(255, 255, 255, 255))

    # "health" — kichik, ostida
    health_bbox = draw.textbbox((0, 0), "health", font=font_health)
    health_w = health_bbox[2] - health_bbox[0]
    health_x = (size - health_w) // 2
    health_y = dgi_y + dgi_h + int(content_size * 0.02)
    draw.text((health_x, health_y), "health", font=font_health,
              fill=(255, 255, 255, 180))

    return img

os.makedirs("assets/images", exist_ok=True)

# Main icon (full background, slight padding)
icon = create_dgi_health_icon(1024, transparent=False, padding_ratio=0.1)
icon.save("assets/images/app_icon.png")

# Foreground (transparent background, significant padding for adaptive icons)
# Adaptive icon safe zone is 66%, so padding_ratio 0.20-0.25 is good
fg = create_dgi_health_icon(1024, transparent=True, padding_ratio=0.25)
fg.save("assets/images/app_icon_foreground.png")

print("✅ Icons regenerated with padding for adaptive support.")

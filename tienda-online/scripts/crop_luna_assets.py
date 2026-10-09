from PIL import Image
import os

ref_file = r'c:\Users\ALAN\PROTOTIPO PAG WEB\ref\_sw-syY4YaCOzPM105139DLyEW-12MCrtljOrYGRx4T5JXUAl-lpWsaBw5ksGSnRrH1nYHvYHjkKpJcO5IqeojnII_UgXrCy3IWVYKec-dRQ0zFR6ZlLhnf2GdBHJTs-MNRELpxVN7sL2cefV5VVdgwfxJWNAk4StUtNdqChWpEY_hNS0_TIcLq7EI1SPR00.jpg'
out_dir = r'c:\Users\ALAN\PROTOTIPO PAG WEB\tienda-online\public\banners'
os.makedirs(out_dir, exist_ok=True)

im = Image.open(ref_file)
w, h = im.size
print(f"Original image size: {w} x {h}")

# 1. Hero right side model photo (high quality)
# The woman in floral dress is on the right side of the hero section
hero_crop = im.crop((460, 80, 1024, 510))
hero_crop.save(os.path.join(out_dir, 'luna-hero-model.jpg'), quality=95)

# Full hero section background
full_hero = im.crop((0, 80, 1024, 510))
full_hero.save(os.path.join(out_dir, 'luna-hero-full.jpg'), quality=95)

# 2. Dual Banners
# Left: Model in white + Summer essentials
banner_left = im.crop((64, 960, 503, 1195))
banner_left.save(os.path.join(out_dir, 'luna-banner-essentials.jpg'), quality=95)

# Left photo only
banner_left_photo = im.crop((64, 960, 290, 1195))
banner_left_photo.save(os.path.join(out_dir, 'luna-banner-left-photo.jpg'), quality=95)

# Right: Accessories flat lay
banner_right = im.crop((520, 960, 960, 1195))
banner_right.save(os.path.join(out_dir, 'luna-banner-accessories.jpg'), quality=95)

# 3. Rack photo in perks section
rack_photo = im.crop((710, 1225, 960, 1350))
rack_photo.save(os.path.join(out_dir, 'luna-rack.jpg'), quality=95)

print("Crops saved successfully!")

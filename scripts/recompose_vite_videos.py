import os
import sys
import math
import subprocess
from PIL import Image, ImageDraw, ImageFont

CARD_W = 376
CARD_H = 508
IMG_W = 346
IMG_H = 246
CARD_X = 874
CARD_Y = 28

FONTS = {
    'bold': "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
    'regular': "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
}

SECTIONS = [
    {
        'key': 'visage_v',
        'letter': 'V',
        'title': 'VISAGE',
        'subtitle': 'Paralysie faciale / Déviation',
        'bullets': [
            "Bouche déviée ou asymétrique",
            "Impossibilité de sourire / siffler",
            "Affaissement brutal d'un côté"
        ],
        'banner': "SIGNE D'ALERTE AVC - AGIR VITE",
        'img_path': "assets/images/visage_droop_ci.jpg",
        'accent_color': (0, 109, 119), # Teal
        'focus_point': (0.55, 0.45), # Focus on face
    },
    {
        'key': 'incapacite_i',
        'letter': 'I',
        'title': 'INCAPACITÉ',
        'subtitle': 'Faiblesse soudaine d\'un membre',
        'bullets': [
            "Test Mingazzini : chute d'un bras",
            "Engourdissement ou lourdeur",
            "Paralysie d'un côté du corps"
        ],
        'banner': "SIGNE D'ALERTE AVC - AGIR VITE",
        'img_path': "assets/images/incapacite_arm_ci.jpg",
        'accent_color': (0, 109, 119), # Teal
        'focus_point': (0.6, 0.45), # Focus on arm test
    },
    {
        'key': 'trouble_t',
        'letter': 'T',
        'title': 'TROUBLE DE LA PAROLE',
        'subtitle': 'Difficulté d\'élocution / Aphasie',
        'bullets': [
            "Difficulté à articuler les mots",
            "Paroles confuses / incompréhensibles",
            "Impossibilité subite de parler"
        ],
        'banner': "SIGNE D'ALERTE AVC - AGIR VITE",
        'img_path': "assets/images/trouble_parole_ci.jpg",
        'accent_color': (226, 149, 120), # Terracotta / Orange
        'focus_point': (0.45, 0.4), # Focus on mouth/expression
    },
    {
        'key': 'urgence_e',
        'letter': 'E',
        'title': 'EN URGENCE',
        'subtitle': 'Appeler immédiatement le 185 SAMU',
        'bullets': [
            "Chaque minute compte (fenêtre 4h30)",
            "Appeler immédiatement le 185 (SAMU)",
            "Ne rien donner à boire ni à manger"
        ],
        'banner': "URGENCE VITALE - AGIR VITE (185)",
        'img_path': "assets/images/urgence_samu_ci.jpg",
        'accent_color': (188, 71, 73), # Emergency Red
        'focus_point': (0.5, 0.5), # Focus on ambulance / care
    }
]

def render_card_frame(sec, t_ratio, font_bold, font_sub, font_letter, font_bullet, font_banner):
    card = Image.new("RGBA", (CARD_W, CARD_H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(card)
    
    # 1. Solid opaque card background to completely cover old card
    card_bg = (24, 34, 48, 255)
    draw.rounded_rectangle([0, 0, CARD_W - 1, CARD_H - 1], radius=24, fill=card_bg, outline=(55, 75, 100, 255), width=2)
    
    # 2. Header
    accent = sec['accent_color']
    badge_x, badge_y, badge_r = 30, 30, 19
    draw.ellipse([badge_x - badge_r, badge_y - badge_r, badge_x + badge_r, badge_y + badge_r], fill=accent)
    draw.text((badge_x - 7, badge_y - 13), sec['letter'], fill=(255, 255, 255), font=font_letter)
    
    draw.text((60, 16), sec['title'], fill=(255, 255, 255), font=font_bold)
    draw.text((60, 38), sec['subtitle'], fill=(165, 185, 205), font=font_sub)

    # 3. Inner Animated Image Window
    img_x = (CARD_W - IMG_W) // 2
    img_y = 62
    
    if os.path.exists(sec['img_path']):
        raw_img = Image.open(sec['img_path']).convert("RGBA")
        
        # Subtle dynamic motion: zoom + gentle pan
        zoom = 1.02 + 0.07 * (0.5 + 0.5 * math.sin(t_ratio * math.pi * 2))
        crop_w = int(raw_img.width / zoom)
        crop_h = int(raw_img.height / zoom)
        
        fx, fy = sec['focus_point']
        cx = int(raw_img.width * fx)
        cy = int(raw_img.height * fy)
        
        left = max(0, min(raw_img.width - crop_w, cx - crop_w // 2))
        top = max(0, min(raw_img.height - crop_h, cy - crop_h // 2))
        
        cropped = raw_img.crop((left, top, left + crop_w, top + crop_h))
        resized = cropped.resize((IMG_W, IMG_H), Image.Resampling.LANCZOS)
        
        mask = Image.new("L", (IMG_W, IMG_H), 0)
        mask_draw = ImageDraw.Draw(mask)
        mask_draw.rounded_rectangle([0, 0, IMG_W, IMG_H], radius=14, fill=255)
        
        card.paste(resized, (img_x, img_y), mask)
        draw.rounded_rectangle([img_x, img_y, img_x + IMG_W, img_y + IMG_H], radius=14, outline=(80, 105, 135, 255), width=1)
        
        # Animated Live Badge
        pulse = 0.5 + 0.5 * math.sin(t_ratio * math.pi * 4)
        dot_color = (255, 60, 60, int(160 + 95 * pulse))
        draw.rounded_rectangle([img_x + 10, img_y + 10, img_x + 115, img_y + 32], radius=6, fill=(15, 22, 32, 190))
        draw.ellipse([img_x + 18, img_y + 18, img_x + 24, img_y + 24], fill=dot_color)
        draw.text((img_x + 28, img_y + 13), "ILLUSTRATION", fill=(240, 245, 255), font=font_sub)

    # 4. Bullet points
    bullet_y = img_y + IMG_H + 14
    for b in sec['bullets']:
        draw.ellipse([img_x + 4, bullet_y + 5, img_x + 11, bullet_y + 12], fill=accent)
        draw.text((img_x + 18, bullet_y), b, fill=(235, 242, 252), font=font_bullet)
        bullet_y += 24

    # 5. Bottom Banner
    banner_w = IMG_W
    banner_h = 30
    banner_y = CARD_H - banner_h - 14
    draw.rounded_rectangle([img_x, banner_y, img_x + banner_w, banner_y + banner_h], radius=8, fill=(32, 45, 62, 255), outline=accent, width=1)
    
    bbox = font_banner.getbbox(sec['banner'])
    tw = bbox[2] - bbox[0]
    draw.text((img_x + (banner_w - tw) // 2, banner_y + 8), sec['banner'], fill=(255, 255, 255), font=font_banner)
    
    return card

def process_section(sec):
    key = sec['key']
    input_video = f"assets/videos/{key}.mp4"
    if not os.path.exists(input_video):
        print(f"Skipping {key}, file not found")
        return
    
    print(f"\n==========================================")
    print(f"🎬 Processing {key} ({sec['title']})...")
    print(f"==========================================")
    
    # Get video duration
    cmd = ["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "default=noprint_wrappers=1:nokey=1", input_video]
    duration_str = subprocess.check_output(cmd).decode().strip()
    duration = float(duration_str)
    fps = 25
    total_frames = int(duration * fps)
    print(f"Duration: {duration:.2f}s, Total Frames: {total_frames}")
    
    # Fonts
    font_bold = ImageFont.truetype(FONTS['bold'], 18)
    font_sub = ImageFont.truetype(FONTS['regular'], 12)
    font_letter = ImageFont.truetype(FONTS['bold'], 22)
    font_bullet = ImageFont.truetype(FONTS['regular'], 13)
    font_banner = ImageFont.truetype(FONTS['bold'], 12)
    
    # Render overlay video stream via ffmpeg pipe
    overlay_mp4 = f"/tmp/{key}_overlay.mp4"
    ffmpeg_pipe_cmd = [
        "ffmpeg", "-y",
        "-f", "rawvideo",
        "-vcodec", "rawvideo",
        "-s", f"{CARD_W}x{CARD_H}",
        "-pix_fmt", "rgba",
        "-r", str(fps),
        "-i", "-",
        "-c:v", "libx264",
        "-pix_fmt", "yuva420p",
        "-t", str(duration),
        overlay_mp4
    ]
    
    pipe_proc = subprocess.Popen(ffmpeg_pipe_cmd, stdin=subprocess.PIPE)
    
    # Generate animated frames
    for f in range(total_frames):
        t_ratio = (f % (fps * 6)) / (fps * 6) # 6-second motion cycle
        card = render_card_frame(sec, t_ratio, font_bold, font_sub, font_letter, font_bullet, font_banner)
        pipe_proc.stdin.write(card.tobytes())
    
    pipe_proc.stdin.close()
    pipe_proc.wait()
    print(f"✓ Generated overlay stream: {overlay_mp4}")
    
    # Composite overlay onto base video
    out_mp4 = f"assets/videos/{key}.mp4"
    out_webm = f"assets/videos/{key}.webm"
    temp_mp4 = f"/tmp/{key}_final.mp4"
    temp_webm = f"/tmp/{key}_final.webm"
    
    # 1. Output MP4
    composite_mp4_cmd = [
        "ffmpeg", "-y",
        "-i", input_video,
        "-i", overlay_mp4,
        "-filter_complex", f"[0:v][1:v]overlay={CARD_X}:{CARD_Y}:shortest=1[v]",
        "-map", "[v]",
        "-map", "0:a?",
        "-c:v", "libx264",
        "-crf", "24",
        "-preset", "fast",
        "-c:a", "aac",
        "-ar", "48000",
        "-b:a", "128k",
        "-movflags", "+faststart",
        temp_mp4
    ]
    subprocess.run(composite_mp4_cmd, check=True)
    os.replace(temp_mp4, out_mp4)
    print(f"✓ Replaced {out_mp4}")
    
    # 2. Output WebM
    composite_webm_cmd = [
        "ffmpeg", "-y",
        "-i", out_mp4,
        "-c:v", "libvpx-vp9",
        "-crf", "30",
        "-b:v", "0",
        "-c:a", "libopus",
        "-ar", "48000",
        "-b:a", "128k",
        temp_webm
    ]
    subprocess.run(composite_webm_cmd, check=True)
    os.replace(temp_webm, out_webm)
    print(f"✓ Replaced {out_webm}")
    
    # Cleanup temp
    if os.path.exists(overlay_mp4):
        os.remove(overlay_mp4)

def main():
    for sec in SECTIONS:
        process_section(sec)
    print("\n🎉 All 4 V.I.T.E. guide videos successfully recomposed with Côte d'Ivoire visuals!")

if __name__ == "__main__":
    main()

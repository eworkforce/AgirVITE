import os, sys, time
from dotenv import load_dotenv
from google import genai
from google.genai import types

load_dotenv('/home/serge/Documents/EWORKFORCE/DEVSpace/GOOGLE_API_TESTS/Omni_API/.env')
api_key = os.environ.get('GEMINI_API_KEY')

client = genai.Client(api_key=api_key, vertexai=False)

video_path = "/home/serge/Documents/EWORKFORCE/DEVSpace/VITE_APPv2/assets/videos/dashboard_overview.mp4"
print(f"Uploading {video_path} for Gemini 3.8 Agentic Video Review...")

uploaded_file = client.files.upload(file=video_path)
print(f"Uploaded file: {uploaded_file.name}, state: {uploaded_file.state}")

while uploaded_file.state.name == "PROCESSING":
    print("Video is processing on Gemini API... waiting 5 seconds")
    time.sleep(5)
    uploaded_file = client.files.get(name=uploaded_file.name)

print(f"File state is ready: {uploaded_file.state.name}")

prompt = """
Tu es un Directeur Artistique et Expert en Sémiologie Médicale & Ergonomie Vidéo Mobile de niveau mondial, spécialisé dans la sensibilisation d'urgence vitale (AVC en Afrique de l'Ouest / Côte d'Ivoire).

Analyse minutieusement cette vidéo (137 secondes) qui sert de vidéo d'accueil et d'introduction dans l'application mobile V.I.T.E. (AVC Espoir).
Le médecin à l'écran est le Pr Ismaïla Diakité, éminent neurologue au CHU de Treichville (Abidjan).

Donne une revue critique impitoyable, approfondie, professionnelle et constructive sur :
1. DÉCOR & COMPOSITION VISUELLE :
   - L'incrustation du médecin sur le décor d'Abidjan (Pont Alassane Ouattara, lagune, Plateau) : intégration, détourage, perspective, réalisme.
   - La visibilité des éléments clés du décor (le pont, la ville, l'ambiance).
2. CARTOUCHES TEXTUELS & HUD :
   - Positionnement des cartouches (gauche, droite, bas). Sont-ils bien équilibrés ? Encombrent-ils la vue ?
   - Lisibilité sur écran de smartphone : contraste, taille de police, hiérarchie visuelle, durée d'affichage.
   - Les choix graphiques (verre fumé, bordures, couleurs blanc/rouge).
3. PRÉSENCE & COMMUNICATION DU MÉDECIN :
   - Cadrage, éclairage, contact visuel, posture, découpage du bureau.
   - Synchronisation et dynamisme avec le message oral.
4. PROBLÈMES MAJEURS DÉTECTÉS (CRITIQUES) :
   - Quels sont les défauts évidents ou "pain points" qui sautent aux yeux d'un utilisateur ou d'un professionnel exigeant ? (Ex: artefacts de détourage autour de la tête/chaise, statisme du fond vs médecin, découpe brutale du bas du corps/bureau, lecture sur petit écran, etc.).
5. RECOMMANDATIONS CONCRÈTES D'AMÉLIORATION (Plan d'action priorisé) :
   - Comment sublimer ce rendu pour atteindre un niveau de qualité broadcast / application médicale premium ?

Fournis une analyse structurée, précise, avec timecodes précis si nécessaire.
"""

print("Running deep analysis with gemini-3.8-flash...")
response = client.models.generate_content(
    model="gemini-3.8-flash",
    contents=[
        uploaded_file,
        prompt
    ]
)

print("\n" + "="*80)
print("RAPPORT D'ANALYSE GEMINI 3.8 FLASH :")
print("="*80 + "\n")
print(response.text)

with open("/home/serge/.gemini/antigravity/brain/ee344e11-cf85-4c80-90b1-e2303a22e5bc/gemini_38_analysis_report.md", "w", encoding="utf-8") as f:
    f.write(response.text)

print("\nRapport sauvegardé dans gemini_38_analysis_report.md")

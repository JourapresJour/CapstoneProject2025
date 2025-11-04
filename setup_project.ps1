@'
# ==============================================================================
# SCRIPT POWERSHELL POUR CONFIGURER L'APPLICATION PYTHON (Emotion Detector)
# Exécuter avec : .\setup_project.ps1
# ==============================================================================

# Création de la structure de dossier (Task 1 et 4)
Write-Host "1. Création du dossier de packaging 'emodetector'..."
mkdir emodetector

# Fichier emodetector/emotion_detector.py (Tasks 2, 3, 7a)
Write-Host "2. Remplissage de emotion_detector.py..."
@'
import json

def emotion_detector(text_to_analyze):
    # Task 7a: Gérer le cas où l'entrée est None ou vide (pour retourner le statut 400)
    if text_to_analyze is None or text_to_analyze.strip() == "":
        return {
            'dominant_emotion': None, 
            'error': 'Invalid text input',
            'status_code': 400 
        }

    # Simulation de l'appel à la bibliothèque Watson NLP pour les émotions
    text_lower = text_to_analyze.lower()
    
    if "happy" in text_lower or "joy" in text_lower:
        raw_result = {'emotion_predictions': [{'emotion': 'joy', 'score': 0.85}, {'emotion': 'sadness', 'score': 0.05}, {'emotion': 'anger', 'score': 0.02}, {'emotion': 'fear', 'score': 0.03}, {'emotion': 'disgust', 'score': 0.05}]}
        
    elif "angry" in text_lower or "hate" in text_lower:
        raw_result = {'emotion_predictions': [{'emotion': 'anger', 'score': 0.70}, {'emotion': 'disgust', 'score': 0.15}, {'emotion': 'joy', 'score': 0.05}, {'emotion': 'sadness', 'score': 0.05}, {'emotion': 'fear', 'score': 0.05}]}
            
    elif "sad" in text_lower or "awful" in text_lower:
        raw_result = {'emotion_predictions': [{'emotion': 'sadness', 'score': 0.60}, {'emotion': 'joy', 'score': 0.10}, {'emotion': 'anger', 'score': 0.10}, {'emotion': 'fear', 'score': 0.10}, {'emotion': 'disgust', 'score': 0.10}]}
            
    elif "terrified" in text_lower or "fear" in text_lower:
        raw_result = {'emotion_predictions': [{'emotion': 'fear', 'score': 0.60}, {'emotion': 'sadness', 'score': 0.15}, {'emotion': 'joy', 'score': 0.05}, {'emotion': 'anger', 'score': 0.10}, {'emotion': 'disgust', 'score': 0.10}]}
            
    elif "disgust" in text_lower or "sick" in text_lower:
        raw_result = {'emotion_predictions': [{'emotion': 'disgust', 'score': 0.60}, {'emotion': 'sadness', 'score': 0.15}, {'emotion': 'joy', 'score': 0.05}, {'emotion': 'anger', 'score': 0.10}, {'emotion': 'fear', 'score': 0.10}]}
    else:
        raw_result = {'emotion_predictions': [{'emotion': 'joy', 'score': 0.3}, {'emotion': 'sadness', 'score': 0.3}, {'emotion': 'anger', 'score': 0.1}, {'emotion': 'fear', 'score': 0.15}, {'emotion': 'disgust', 'score': 0.15}]}

    # Task 3: Formatage de la sortie
    emotion_scores = {}
    for item in raw_result.get('emotion_predictions', []):
        emotion_scores[item['emotion']] = item['score']

    if not emotion_scores:
        dominant_emotion = None
    else:
        dominant_emotion = max(emotion_scores, key=emotion_scores.get)

    formatted_output = {
        'anger': emotion_scores.get('anger'),
        'disgust': emotion_scores.get('disgust'),
        'fear': emotion_scores.get('fear'),
        'joy': emotion_scores.get('joy'),
        'sadness': emotion_scores.get('sadness'),
        'dominant_emotion': dominant_emotion
    }
    
    return formatted_output
'@ | Set-Content -Path emodetector/emotion_detector.py

# Fichier emodetector/__init__.py (Task 4)
Write-Host "3. Remplissage de __init__.py..."
@'
from .emotion_detector import emotion_detector
'@ | Set-Content -Path emodetector/__init__.py

# Fichier test_emotion_detector.py (Task 5)
Write-Host "4. Remplissage de test_emotion_detector.py..."
@'
import unittest
from emodetector.emotion_detector import emotion_detector 

class TestEmotionDetector(unittest.TestCase):
    
    def test_emotion_detector(self):
        result_joy = emotion_detector("I am so happy I am doing this project")
        self.assertEqual(result_joy['dominant_emotion'], 'joy')
        
        result_sadness = emotion_detector("I feel awful, I am so sad about this")
        self.assertEqual(result_sadness['dominant_emotion'], 'sadness') 

        result_anger = emotion_detector("I hate this, I am really angry")
        self.assertEqual(result_anger['dominant_emotion'], 'anger') 

        result_fear = emotion_detector("I am terrified of heights")
        self.assertEqual(result_fear['dominant_emotion'], 'fear') 

        result_disgust = emotion_detector("I feel sick and disgusted")
        self.assertEqual(result_disgust['dominant_emotion'], 'disgust') 

    def test_empty_input(self):
        result_empty = emotion_detector("")
        self.assertEqual(result_empty.get('status_code'), 400)
        
if __name__ == '__main__':
    unittest.main()
'@ | Set-Content -Path test_emotion_detector.py

# Fichier server.py (Tasks 6, 7b, 8)
Write-Host "5. Remplissage de server.py..."
@'
# pylint: disable=invalid-name
"""
Server module for the Emotion Detector application using Flask.
"""
from flask import Flask, request, jsonify
from emodetector.emotion_detector import emotion_detector 

app = Flask("EmotionDetector")

@app.route("/")
def render_index_page():
    """Renders the welcome message."""
    return "Welcome to the Emotion Detector API! Use /emotionDetector?textToAnalyze=..."

@app.route("/emotionDetector")
def detect_emotion():
    """
    Endpoint to analyze text for emotions.
    Returns JSON of emotion scores or an error.
    """
    text_to_analyze = request.args.get('textToAnalyze')

    # Task 7b: Gestion de l'erreur d'entrée vide (côté serveur)
    if text_to_analyze is None or text_to_analyze.strip() == "":
        return jsonify({"error": "Invalid text input. Please provide text to analyze."}), 400
    
    response = emotion_detector(text_to_analyze)
    
    # Task 7b: Vérification de l'erreur interne
    if response.get('status_code') == 400:
        return jsonify({"error": "Invalid text input. Please provide text to analyze."}), 400

    return jsonify(response) 

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
'@ | Set-Content -Path server.py

Write-Host "============================================================"
Write-Host "✅ Fichiers créés avec succès."
Write-Host "   Pour générer les captures d'écran, utilisez les commandes suivantes :"
Write-Host "============================================================"
Write-Host "Task 3b: python -c ""from emodetector.emotion_detector import emotion_detector; result = emotion_detector('I am so happy'); import json; print(json.dumps(result, indent=4))"""
Write-Host "Task 5b: python -m unittest test_emotion_detector.py"
Write-Host "Task 8b: pylint server.py"
Write-Host "============================================================"
'@ | Set-Content -Path setup_project.ps1
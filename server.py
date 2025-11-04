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
    
    # Task 6: Appeler la fonction de détection
    response = emotion_detector(text_to_analyze)
    
    # Vérification si la fonction interne a retourné une erreur (Task 7b/7a)
    if response.get('status_code') == 400:
        return jsonify({"error": "Invalid text input. Please provide text to analyze."}), 400

    # Task 6: Renvoyer la réponse formatée
    return jsonify(response) 

if __name__ == "__main__":
    # Task 6: Déploiement de l'application
    app.run(host="0.0.0.0", port=5000)

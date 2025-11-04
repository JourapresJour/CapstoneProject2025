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

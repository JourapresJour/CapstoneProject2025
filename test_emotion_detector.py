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

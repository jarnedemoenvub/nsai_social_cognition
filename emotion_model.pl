nn(emotion_net,[Image],Emotion,['angry', 'disgust', 'fear', 'happy', 'neutral', 'sad', 'surprise']) :: face(Image, Emotion).

happy(Image) :- face(Image, 'happy').

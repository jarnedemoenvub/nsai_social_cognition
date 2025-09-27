nn(emotion_net, [X], Y, [angry, disgust, fear, happy, neutral, sad, surprise]) :: emotion(X, Y).
positive_emotion(X) :- emotion(X, happy).
positive_emotion(X) :- emotion(X, surprise).
negative_emotion(X) :- emotion(X, angry).
negative_emotion(X) :- emotion(X, sad).
negative_emotion(X) :- emotion(X, disgust).
negative_emotion(X) :- emotion(X, fear).
neutral_emotion(X) :- emotion(X, neutral).
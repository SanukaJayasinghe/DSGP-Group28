import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import pickle

class ExerciseClassifier:
    def __init__(self):
        self.random_forest_model = None
        self.training_columns = None
        self.tfidf_vectorizer = None

    def load_random_forest_model(self):
        # Load the model from the pickle file
        with open("flaskProject/model/exercise_model.pkl", "rb") as f:
            self.random_forest_model = pickle.load(f)
            self.training_columns = self.random_forest_model.feature_names_in_.tolist()

    def tokenize_text(self, text):
        if self.tfidf_vectorizer is None:
            raise ValueError("TF-IDF vectorizer is not initialized. Please train or load the model first.")
        return self.tfidf_vectorizer.transform([text])

    def predict_exercise(self, body_part, equipment, target):
        # Tokenize text data - Removed other inputs as they are not needed
        # Create user inputs dictionary
        user_inputs = {
            f'bodyPart_{body_part}': 1,
            f'equipment_{equipment}': 1,
            f'target_{target}': 1
        }

        # Create DataFrame from user inputs
        input_df = pd.DataFrame([user_inputs])

        # Concatenate tokenized text data with user inputs
        input_df = pd.concat([input_df], axis=1)

        # Reindexing to ensure all required columns are present
        input_df = input_df.reindex(columns=self.training_columns, fill_value=0)

        # Make predictions
        predictions = self.random_forest_model.predict(input_df)

        # Output the predictions
        return predictions[0]

# Instantiate ExerciseClassifier
exercise_classifier = ExerciseClassifier()
exercise_classifier.load_random_forest_model()

# User inputs
print("Please provide the following information:")
body_part = input("Body Part: ")
equipment = input("Equipment: ")
target = input("Target: ")

# Make prediction
prediction = exercise_classifier.predict_exercise(body_part, equipment, target)
print("\nPredicted exercise: \n")
print("Name:", prediction[0])
print("Secondary Muscles:", prediction[1])
print("Predicted Level:", prediction[2])
print("GIF URL:", prediction[3])
print("Instructions:", prediction[4])
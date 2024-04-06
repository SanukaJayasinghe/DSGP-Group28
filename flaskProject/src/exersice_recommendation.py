import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import pickle, os

class ExerciseRecommendation:
    model_path = os.path.join('model','exercise_recommendation_model.pkl')

    def __init__(self):
        print('Exercise Recommendation Class initialized')
        self.random_forest_model = self.load_random_forest_model()
        self.training_columns = self.random_forest_model.feature_names_in_.tolist() if self.random_forest_model else []
        self.tfidf_vectorizer = None

    def load_random_forest_model(self):
        # Load the model from the pickle file
        with open(self.model_path, "rb") as f:
            return pickle.load(f)

    def tokenize_text(self, text):
        if self.tfidf_vectorizer is None:
            raise ValueError("TF-IDF vectorizer is not initialized.")
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
        predictions = self.random_forest_model.predict(input_df) #type:ignore

        # Output the predictions
        return predictions[0]
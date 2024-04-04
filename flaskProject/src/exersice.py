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
        with open("exercise_model.pkl", "rb") as f:
            self.random_forest_model = pickle.load(f)
            self.training_columns = self.random_forest_model.feature_names_in_.tolist()

    def tokenize_text(self, text):
        if self.tfidf_vectorizer is None:
            raise ValueError("TF-IDF vectorizer is not initialized. Please train or load the model first.")
        return self.tfidf_vectorizer.transform([text])

    def predict_exercise(self, name, secondary_muscles, instructions, body_part, equipment, target):
        # Tokenize text data
        name_tfidf = self.tokenize_text(name)
        secondary_muscles_tfidf = self.tokenize_text(secondary_muscles)
        instructions_tfidf = self.tokenize_text(instructions)
        
        # Create user inputs dictionary
        user_inputs = {
            f'bodyPart_{body_part}': 1,
            f'equipment_{equipment}': 1,
            f'target_{target}': 1
        }

        # Create DataFrame from user inputs
        input_df = pd.DataFrame([user_inputs])

        # Concatenate tokenized text data with user inputs
        input_df = pd.concat([input_df, name_tfidf, secondary_muscles_tfidf, instructions_tfidf], axis=1)

        # Reindexing to ensure all required columns are present
        input_df = input_df.reindex(columns=self.training_columns, fill_value=0)

        # Make predictions
        predictions = self.random_forest_model.predict(input_df)

        # Output the predictions
        return predictions[0]
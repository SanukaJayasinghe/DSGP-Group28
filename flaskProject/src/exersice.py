import pandas as pd
import pickle

class ExercisePredictor:
    def __init__(self, model_path):
        self.model_path = model_path
        self.model = None
        self.label_encoders = None

    def load_model(self):
        with open(self.model_path, "rb") as f:
            try:
                self.model, self.label_encoders = pickle.load(f)
            except ValueError:
                # If there's a ValueError, assume only the model is saved
                f.seek(0)  # Reset file pointer to the beginning
                self.model = pickle.load(f)

    def predict_exercise(self, input_data):
        if self.label_encoders is None:
            raise ValueError("Label encoders not loaded. Please make sure to load the model correctly.")

        encoded_input = {}
        for column, value in input_data.items():
            encoded_input[column] = self.label_encoders[column].transform([value])[0]

        input_df = pd.DataFrame([encoded_input])
        predicted_level = self.model.predict(input_df)[0]
        predicted_level = self.label_encoders['Predicted_Level'].inverse_transform([predicted_level])[0]

        predicted_exercise = {
            "Predicted Level": predicted_level
        }

        return predicted_exercise

# Example usage:
model_path = "flaskProject/model/exercise_model.pkl"

exercise_predictor = ExercisePredictor(model_path)
exercise_predictor.load_model()

input_data = {
    'bodyPart': input("Enter body part: "),
    'equipment': input("Enter equipment: "),
    'target': input("Enter target: ")
}

prediction = exercise_predictor.predict_exercise(input_data)
print("Predicted Level:", prediction["Predicted Level"])

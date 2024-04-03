class DietRecommendation:
    def _init_(self, model_path):
        self.model_path = model_path
        self.model = self.load_model()

    def load_model(self):
        with open(self.model_path, 'rb') as f:
            model = pickle.load(f)
        return model

    def predict_health(self, user_age, user_weight, user_height, user_gender, user_activity_level):
        BMI = user_weight / (user_height ** 2)
        if user_gender == "M":
            user_gender = 1
        elif user_gender == "F":
            user_gender = 0

        # Assuming you have performed grid search and obtained the best model (best_model)
        user_input = [[user_age, user_weight, user_height, BMI, user_activity_level, user_gender]]  # List of features for the user input

        # Make predictions on the user input using the loaded model
        user_pred = self.model.predict(user_input)

        return user_pred[0]
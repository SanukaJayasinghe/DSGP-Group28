import pickle
import pandas as pd
import random
import os

class DietRecommendation:
    model_path = "diet_recommendation_model.pkl"
    dataset_path = "food_ingredient.csv"

    def __init__(self):
        print('Diet Recommendation Class initialized')
        self.model_path = self.model_path
        self.dataset_path = self.dataset_path
        self.model = self.load_model()
        self.data = self.read_data_from_csv()

    def load_model(self):
        path = os.path.join('model', self.model_path)
        with open(path, 'rb') as f:
            model = pickle.load(f)
        return model

    def read_data_from_csv(self):
        path = os.path.join('database', self.dataset_path)
        return pd.read_csv(path)

    def predict_calorie(self, user_age, user_weight, user_height, user_gender, user_activity_level):
        BMI = user_weight / (user_height ** 2)
        user_gender = 1 if user_gender == "M" else 0

        user_input = [[user_age, user_weight, user_height, BMI, user_activity_level, user_gender]]
        user_pred = self.model.predict(user_input)

        return int(user_pred[0])

    def fetch_ingredients(self, target_calories):
        result = self.subset_sum_pandas(target_calories)
        if result is not None:
            return result
        else:
            return "No combination found to achieve the target calories."

    def subset_sum_pandas(self, target_calories):
        data = self.data.copy()
        subset = data[data['Calories'] <= target_calories].reset_index(drop=True)

        if subset.empty:
            return None

        selected_indices = []
        current_sum = 0

        # Shuffle the indices to randomize selection
        indices = list(range(len(subset)))
        random.shuffle(indices)

        for index in indices:
            if current_sum + subset.at[index, 'Calories'] <= target_calories:
                current_sum += subset.at[index, 'Calories']
                selected_indices.append(index)

            if current_sum == target_calories:
                break

        if current_sum != target_calories:
            return None

        return subset.loc[selected_indices, ['Food', 'Serving']]


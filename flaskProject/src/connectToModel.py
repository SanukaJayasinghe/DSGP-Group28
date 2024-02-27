import cv2
import mediapipe as mp
import numpy as np
import pandas as pd
import pickle
import base64
import math


class PoseDetector:
    desired_width = 640
    desired_height = 480
    mp_pose = mp.solutions.pose  # type: ignore
    mp_drawing = mp.solutions.drawing_utils  # type: ignore
    pose = mp_pose.Pose(
        min_detection_confidence=0.4,
        min_tracking_confidence=0.4,
        static_image_mode=False,
        smooth_landmarks=True,
        model_complexity=2
    )

    def __init__(self):
        print('Class initialized')
        self.model = self.load_model()

    def load_model(self):
        with open('../flaskProject/model/model.pkl', 'rb') as f:
            model = pickle.load(f)
        return model

    def calculate_angle(self, rows):
        row = abs(rows)

        # Accessing columns by their index positions (0 to 5) from the row
        radians = math.atan2(row[5] - row[3], row[4] - row[2]) - \
            math.atan2(row[1] - row[3], row[0] - row[2])
        angle = math.degrees(radians)
        if angle < 0:
            angle += 360
        return angle

    def draw_line_and_send(self, image, landmarks):
        self.mp_drawing.draw_landmarks(
            image, landmarks, self.mp_pose.POSE_CONNECTIONS)
        return image

    def process_video(self, video_path, callback_function):
        cap = cv2.VideoCapture(video_path)
        frame_count = 0

        while cap.isOpened():
            success, image = cap.read()
            if not success:
                break

            frame_count += 1
            print(f'Processing frame {frame_count}')

            # Resize the frame to the desired width and height
            image = cv2.resize(
                image, (self.desired_width, self.desired_height))

            # Convert the image from BGR to RGB
            image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

            results = self.pose.process(image_rgb)

            if results.pose_landmarks:
                data_dict = {f"{landmark.name}_Point_x": []
                             for landmark in self.mp_pose.PoseLandmark}
                data_dict.update({f"{landmark.name}_Point_y": []
                                 for landmark in self.mp_pose.PoseLandmark})
                data_dict.update({f"{landmark.name}_Point_z": []
                                 for landmark in self.mp_pose.PoseLandmark})
                data_dict.update({f"{landmark.name}_visibility": []
                                 for landmark in self.mp_pose.PoseLandmark})

                landmarks = results.pose_landmarks

                for landmark in self.mp_pose.PoseLandmark:
                    x_list_name = f"{landmark.name}_Point_x"
                    y_list_name = f"{landmark.name}_Point_y"
                    z_list_name = f"{landmark.name}_Point_z"
                    visibility_list_name = f"{landmark.name}_visibility"

                    data_dict[x_list_name].append(
                        landmarks.landmark[landmark].x)
                    data_dict[y_list_name].append(
                        landmarks.landmark[landmark].y)
                    data_dict[z_list_name].append(
                        landmarks.landmark[landmark].z)
                    data_dict[visibility_list_name].append(
                        landmarks.landmark[landmark].visibility)

                df = pd.DataFrame(data_dict)
                Angles_df = pd.DataFrame()

                Angle_At_Right_Elbow = df[[
                    'RIGHT_WRIST_Point_x', 'RIGHT_WRIST_Point_y',
                    'RIGHT_ELBOW_Point_x', 'RIGHT_ELBOW_Point_y',
                    'RIGHT_SHOULDER_Point_x', 'RIGHT_SHOULDER_Point_y'
                ]]

                Angles_df['Angle_At_Right_Elbow'] = Angle_At_Right_Elbow.apply(
                    self.calculate_angle, axis=1)

                Angle_At_Left_Elbow = df[[
                    'LEFT_WRIST_Point_x', 'LEFT_WRIST_Point_y',
                    'LEFT_ELBOW_Point_x', 'LEFT_ELBOW_Point_y',
                    'LEFT_SHOULDER_Point_x', 'LEFT_SHOULDER_Point_y'
                ]]
                Angles_df['Angle_At_Left_Elbow'] = Angle_At_Left_Elbow.apply(
                    self.calculate_angle, axis=1)

                # Calculate angle at right shoulder
                Angle_At_Right_Shoulder = df[[
                    'RIGHT_ELBOW_Point_x', 'RIGHT_ELBOW_Point_y',
                    'RIGHT_SHOULDER_Point_x', 'RIGHT_SHOULDER_Point_y',
                    'RIGHT_HIP_Point_x', 'RIGHT_HIP_Point_y'
                ]]
                Angles_df['Angle_At_Right_Shoulder'] = Angle_At_Right_Shoulder.apply(
                    self.calculate_angle, axis=1)

                # Calculate angle at left shoulder
                Angle_At_Left_Shoulder = df[[
                    'LEFT_ELBOW_Point_x', 'LEFT_ELBOW_Point_y',
                    'LEFT_SHOULDER_Point_x', 'LEFT_SHOULDER_Point_y',
                    'LEFT_HIP_Point_x', 'LEFT_HIP_Point_y'
                ]]
                Angles_df['Angle_At_Left_Shoulder'] = Angle_At_Left_Shoulder.apply(
                    self.calculate_angle, axis=1)

                # Calculate angle at right knee (example)
                Angle_At_Right_Knee = df[[
                    'RIGHT_HIP_Point_x', 'RIGHT_HIP_Point_y',
                    'RIGHT_KNEE_Point_x', 'RIGHT_KNEE_Point_y',
                    'RIGHT_ANKLE_Point_x', 'RIGHT_ANKLE_Point_y'
                ]]
                Angles_df['Angle_At_Right_Knee'] = Angle_At_Right_Knee.apply(
                    self.calculate_angle, axis=1)

                # Calculate angle at left knee (example)
                Angle_At_Left_Knee = df[[
                    'LEFT_HIP_Point_x', 'LEFT_HIP_Point_y',
                    'LEFT_KNEE_Point_x', 'LEFT_KNEE_Point_y',
                    'LEFT_ANKLE_Point_x', 'LEFT_ANKLE_Point_y'
                ]]
                Angles_df['Angle_At_Left_Knee'] = Angle_At_Left_Knee.apply(
                    self.calculate_angle, axis=1)

                # Calculate angle at right hip
                Angle_At_Right_Hip = df[[
                    'RIGHT_SHOULDER_Point_x', 'RIGHT_SHOULDER_Point_y',
                    'RIGHT_HIP_Point_x', 'RIGHT_HIP_Point_y',
                    'RIGHT_KNEE_Point_x', 'RIGHT_KNEE_Point_y'
                ]]
                Angles_df['Angle_At_Right_Hip'] = Angle_At_Right_Hip.apply(
                    self.calculate_angle, axis=1)

                # Calculate angle at left hip
                Angle_At_Left_Hip = df[[
                    'LEFT_SHOULDER_Point_x', 'LEFT_SHOULDER_Point_y',
                    'LEFT_HIP_Point_x', 'LEFT_HIP_Point_y',
                    'LEFT_KNEE_Point_x', 'LEFT_KNEE_Point_y'
                ]]
                Angles_df['Angle_At_Left_Hip'] = Angle_At_Left_Hip.apply(
                    self.calculate_angle, axis=1)

                # Calculate angle at neck (example)
                Angle_At_Neck = df[[
                    'LEFT_SHOULDER_Point_x', 'LEFT_SHOULDER_Point_y',
                    'NOSE_Point_x', 'NOSE_Point_y',
                    'RIGHT_SHOULDER_Point_x', 'RIGHT_SHOULDER_Point_y'
                ]]
                Angles_df['Angle_At_Neck'] = Angle_At_Neck.apply(
                    self.calculate_angle, axis=1)

                prediction = self.model.predict(Angles_df)

                if prediction == 0 or prediction is False:
                    image = self.draw_line_and_send(image, landmarks)
                    image_bytes = cv2.imencode('.jpg', image)[1].tobytes()
                    image64bit = base64.b64encode(image_bytes).decode()
                    callback_function(
                        {'image': image64bit, 'header': 'Sample header', 'description': 'Sample description'})
                else:
                    # image = self.draw_line_and_send(image, landmarks)
                    pass

            # Display the image
            # cv2.imshow('MediaPipe Pose', image)

            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

        cap.release()
        cv2.destroyAllWindows()

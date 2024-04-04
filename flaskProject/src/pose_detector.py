import cv2
import mediapipe as mp
import numpy as np
import pandas as pd
import pickle
import base64
import math
import os


class PoseDetector:
    model = ''
    stream = bool
    mp_pose = mp.solutions.pose  # type:ignore
    mp_drawing = mp.solutions.drawing_utils  # type:ignore
    pose = mp_pose.Pose(
        min_detection_confidence=0.4,
        min_tracking_confidence=0.4,
        static_image_mode=False,
        smooth_landmarks=True,
        model_complexity=1
    )
    model_path = {
        'Pushup': 'pushup_model.pkl',
        'Situp': 'situp_model.pkl',
        'Squat': 'squat_model.pkl',
        'Pullup': 'pullup_model.pkl',
        'Mountain Climbing': 'mountain_climbing_model.pkl'
    }

    def __init__(self):
        print('Pose Detector Class initialized')

    def load_model(self, path):
        path = os.path.join('model', self.model_path[path])
        with open(path, 'rb') as f:
            self.model = pickle.load(f)

    def stop_stream(self):
        self.stream = False
        try:
            self.cap.release()
            cv2.destroyAllWindows()
            print('Cap released')
        except:
            print('Cap not released')

    def calculate_angle(self, rows):
        row = abs(rows)

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

    def resize_image(self, image):
        min_height = 400
        height, width = image.shape[:2]
        aspect_ratio = width / height
        new_height = max(height // 2, min_height)
        new_width = int(new_height * aspect_ratio)
        resized_img = cv2.resize(
            image, (new_width, new_height), interpolation=cv2.INTER_AREA)
        return resized_img

    def process_video(self, video_path, callback_function):
        frame_count = 0
        self.stream = True
        self.cap = cv2.VideoCapture(video_path)

        while self.cap.isOpened() and self.stream:
            success, image = self.cap.read()
            if not success:
                break

            frame_count += 1
            print(f'Processing frame {frame_count}')

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
                angles_df = pd.DataFrame()

                Angle_At_Right_Elbow = df[[
                    'RIGHT_WRIST_Point_x', 'RIGHT_WRIST_Point_y',
                    'RIGHT_ELBOW_Point_x', 'RIGHT_ELBOW_Point_y',
                    'RIGHT_SHOULDER_Point_x', 'RIGHT_SHOULDER_Point_y'
                ]]

                angles_df['Angle_At_Right_Elbow'] = Angle_At_Right_Elbow.apply(
                    self.calculate_angle, axis=1)

                Angle_At_Left_Elbow = df[[
                    'LEFT_WRIST_Point_x', 'LEFT_WRIST_Point_y',
                    'LEFT_ELBOW_Point_x', 'LEFT_ELBOW_Point_y',
                    'LEFT_SHOULDER_Point_x', 'LEFT_SHOULDER_Point_y'
                ]]
                angles_df['Angle_At_Left_Elbow'] = Angle_At_Left_Elbow.apply(
                    self.calculate_angle, axis=1)

                Angle_At_Right_Shoulder = df[[
                    'RIGHT_ELBOW_Point_x', 'RIGHT_ELBOW_Point_y',
                    'RIGHT_SHOULDER_Point_x', 'RIGHT_SHOULDER_Point_y',
                    'RIGHT_HIP_Point_x', 'RIGHT_HIP_Point_y'
                ]]
                angles_df['Angle_At_Right_Shoulder'] = Angle_At_Right_Shoulder.apply(
                    self.calculate_angle, axis=1)

                Angle_At_Left_Shoulder = df[[
                    'LEFT_ELBOW_Point_x', 'LEFT_ELBOW_Point_y',
                    'LEFT_SHOULDER_Point_x', 'LEFT_SHOULDER_Point_y',
                    'LEFT_HIP_Point_x', 'LEFT_HIP_Point_y'
                ]]
                angles_df['Angle_At_Left_Shoulder'] = Angle_At_Left_Shoulder.apply(
                    self.calculate_angle, axis=1)

                Angle_At_Right_Knee = df[[
                    'RIGHT_HIP_Point_x', 'RIGHT_HIP_Point_y',
                    'RIGHT_KNEE_Point_x', 'RIGHT_KNEE_Point_y',
                    'RIGHT_ANKLE_Point_x', 'RIGHT_ANKLE_Point_y'
                ]]
                angles_df['Angle_At_Right_Knee'] = Angle_At_Right_Knee.apply(
                    self.calculate_angle, axis=1)

                Angle_At_Left_Knee = df[[
                    'LEFT_HIP_Point_x', 'LEFT_HIP_Point_y',
                    'LEFT_KNEE_Point_x', 'LEFT_KNEE_Point_y',
                    'LEFT_ANKLE_Point_x', 'LEFT_ANKLE_Point_y'
                ]]
                angles_df['Angle_At_Left_Knee'] = Angle_At_Left_Knee.apply(
                    self.calculate_angle, axis=1)

                Angle_At_Right_Hip = df[[
                    'RIGHT_SHOULDER_Point_x', 'RIGHT_SHOULDER_Point_y',
                    'RIGHT_HIP_Point_x', 'RIGHT_HIP_Point_y',
                    'RIGHT_KNEE_Point_x', 'RIGHT_KNEE_Point_y'
                ]]
                angles_df['Angle_At_Right_Hip'] = Angle_At_Right_Hip.apply(
                    self.calculate_angle, axis=1)

                Angle_At_Left_Hip = df[[
                    'LEFT_SHOULDER_Point_x', 'LEFT_SHOULDER_Point_y',
                    'LEFT_HIP_Point_x', 'LEFT_HIP_Point_y',
                    'LEFT_KNEE_Point_x', 'LEFT_KNEE_Point_y'
                ]]
                angles_df['Angle_At_Left_Hip'] = Angle_At_Left_Hip.apply(
                    self.calculate_angle, axis=1)

                Angle_At_Neck = df[[
                    'LEFT_SHOULDER_Point_x', 'LEFT_SHOULDER_Point_y',
                    'NOSE_Point_x', 'NOSE_Point_y',
                    'RIGHT_SHOULDER_Point_x', 'RIGHT_SHOULDER_Point_y'
                ]]
                angles_df['Angle_At_Neck'] = Angle_At_Neck.apply(
                    self.calculate_angle, axis=1)


                prediction = self.model.predict(angles_df)  # type:ignore
                image = self.draw_line_and_send(image, landmarks)
                resized_image = self.resize_image(image)
                image_bytes = cv2.imencode('.jpeg', resized_image)[1].tobytes()
                image64bit = base64.b64encode(image_bytes).decode()

                if prediction == 0 or prediction is False:
                    callback_function(
                        {'type': 'wrong', 'image': image64bit, 'header': 'Sample header', 'description': 'Sample description'})
                else:
                    callback_function(
                        {'type': 'stream', 'image': image64bit, 'header': 'Sample header', 'description': 'Sample description'})
                    pass

            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

        self.cap.release()
        cv2.destroyAllWindows()

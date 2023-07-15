📚 **Thesis and Project Summary**

Author : Gaurav Anand (CSE/19030/457) 
Mentor : Dr. Dalia Nandi (ECE, IIIT Kalyani)

📖 **Introduction**
This chapter introduces the problem statement, implementation details, and scope of the project. It discusses the objective, methodology, and tools used, along with the deliverables and organizational structure of the thesis.

🔍 **Problem Statement**
Extreme weather events pose a significant threat, and accurate prediction can help mitigate their impacts. The thesis proposes the use of Deep Learning to predict extreme weather events accurately, with a focus on cost-effective methods. The objective is to develop a model that predicts cyclones, thunderstorms, and heatwaves with high accuracy, 6 hours, 12 hours, and 24 hours in advance. A mobile application will be developed to make these predictions accessible to the general public.

📚 **Existing Methodology**
Existing methods for extreme weather prediction, such as Numerical Weather Prediction (NWP), statistical methods, and Global Climate Models (GCM), have limitations. New approaches like machine learning algorithms and data assimilation techniques aim to improve accuracy and reliability. The development of new technologies will continue to enhance our ability to predict extreme weather events.

💡 **Proposed Model**
The thesis proposes a model using meteorological data from the POWER project. The model employs an LSTM stacked autoencoder for feature extraction and clustering techniques (DBSCAN and PCA) to identify extreme weather events. The model generates weather data 6H, 12H, and 24H in advance and integrates into a mobile application developed in Flutter, providing real-time predictions and alerts.

🗃️ **Dataset**
The Power and Storm datasets are valuable for studying extreme weather events in India. The Power Dataset provides hourly weather data from 2010 to 2022 for Indian cities, and the Storm Dataset contains information on extreme weather events in the USA. These datasets can aid in training a classifier to identify and classify extreme weather events in India.

📚 **Literature Review**
The importance of literature reviews in deep learning for extreme weather prediction research is highlighted. Deep learning has shown success in various domains and has the potential to overcome limitations of traditional weather prediction models. Challenges such as incorporating physical constraints, ensuring robustness and interpretability of predictions, and evaluating performance and uncertainty require further investigation.

🔬 **Methodology**
This section describes the proposed approach, including data preprocessing, DBSCAN-PCA analysis for anomaly detection, and the use of an isolation forest-based classifier. The model architecture consists of a stacked LSTM autoencoder for extreme weather prediction. The methodology ensures data quality, anomaly identification, and accurate prediction.

📊 **Chapter 4 Experimental Results**
This section evaluates the stacked LSTM Autoencoder model's performance in predicting weather patterns. The model is assessed using mean squared error (MSE) as the loss function. Results show accurate predictions up to 24 hours in advance, demonstrating the effectiveness of the analysis and modeling techniques for weather forecasting and climate research.

📱 **Need for the App**
The thesis emphasizes the need for a mobile application that provides real-time weather updates and alerts, especially in regions with limited access to conventional methods. The Reaps Mobile App addresses this need by offering advanced weather prediction capabilities, extreme weather alerts, and data storage for 6h, 12h, and 24h predictions. It utilizes Flutter for the frontend and Firebase for notification and data storage, ensuring accurate and reliable weather information.

<img src="https://github.com/GauravAnand563/Reaps/assets/10172216/fb8cd060-3dcf-49ad-a2cc-e6cd3dfbbc25" alt="Image 1" style="height: 300px;">
<img src="https://github.com/GauravAnand563/Reaps/assets/10172216/a33d6db8-3d8d-4839-b817-67386c22069a" alt="Image 2" style="height: 300px;">
<img src="https://github.com/GauravAnand563/Reaps/assets/10172216/d0328406-0195-4afc-b090-e9e3b3c31191" alt="Image 3" style="height: 300px;">
<img src="https://github.com/GauravAnand563/Reaps/assets/10172216/a80da38e-4c47-470c-bb30-1f42436d2afd" alt="Image 4" style="height: 300px;">
<img src="https://github.com/GauravAnand563/Reaps/assets/10172216/79311d86-7fc3-4729-8efa-35f5d32049c2" alt="Image 5" style="height: 300px;">
<img src="https://github.com/GauravAnand563/Reaps/assets/10172216/5e4332ff-f960-4c31-b3b1-1a57fbe52a77" alt="Image 6" style="height: 300px;">


✅ **Functional Requirements of the App**
The Reaps Mobile App has functional requirements, including fetching current weather data, utilizing machine learning models for weather prediction and classification, offering a user-friendly interface, sending notifications for extreme weather conditions, and storing weather data for the last 

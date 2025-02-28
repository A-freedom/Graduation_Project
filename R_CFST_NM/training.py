# %%
import os

import tensorflow as tf

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
os.environ["CUDA_VISIBLE_DEVICES"] = ""  # Limit TensorFlow to CPU only
from data_preprocessor import DataPreprocessor
from my_tools import evaluate_and_plot
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint, TensorBoard

data_preprocessor = DataPreprocessor()
# Load the dataset
X_train, X_test, y_train, y_test, X, y = data_preprocessor.get_training_and_testing_data()

# Model design
model = tf.keras.Sequential([
    tf.keras.layers.Dense(6, activation='elu'),
    tf.keras.layers.Dense(8, activation='elu'),
    tf.keras.layers.Dense(10, activation='elu'),
    tf.keras.layers.Dense(8, activation='elu'),
    tf.keras.layers.Dense(6, activation='elu'),
    tf.keras.layers.Dense(1, activation='elu')  # Output layer for regression
])

# Compile the model
# custom_optimizer = tf.keras.optimizers.Adam(learning_rate=0.001, )
model.compile(optimizer='adam', loss='mse', metrics=["mape", "mse"])

# Define callbacks
# Early stopping callback
# early_stopping = EarlyStopping(monitor='val_mape', patience=50, restore_best_weights=True)
# Model checkpoint callback
checkpoint = ModelCheckpoint("R_CFST_NM/my_model/best_model.keras", save_best_only=True)
# TensorBoard callback for profiling
tensorboard = TensorBoard(log_dir="logs/")

# Train the model
model.fit(X_train, y_train, epochs=60000, batch_size=len(X_train), verbose=2, validation_data=(X_test, y_test),
          callbacks=[checkpoint, tensorboard])


# Evaluate the model on testing data
model.evaluate(X_test, y_test)

model = tf.keras.models.load_model('R_CFST_NM/my_model/best_model.keras')
#
# evaluate_and_plot(X_test, y_test, model, 'test data')
#
# evaluate_and_plot(X, y, model, 'All data')

# %%

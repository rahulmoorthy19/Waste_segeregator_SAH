import numpy as np
import matplotlib.pyplot as plt
import cv2
import tensorflow as tf
import keras
from keras.models import Sequential, load_model
from keras.layers import Dense, Conv2D, MaxPooling2D, Flatten, Dropout
from keras.losses import categorical_crossentropy
from keras.optimizers import adam, sgd
from keras.preprocessing.image import ImageDataGenerator
from keras.callbacks import ModelCheckpoint
from tensorflow.python.keras.backend import set_session
from PIL import Image
global graph
global sess
sess=tf.Session()
graph = tf.get_default_graph()
IMG_BREDTH = 60
IMG_HEIGHT = 60
num_classes = 2
set_session(sess)
model = load_model('waste_classifier.h5')

def use_model(path):
    pic = plt.imread(path)
    pic = cv2.resize(pic, (IMG_BREDTH, IMG_HEIGHT))
    pic = np.expand_dims(pic, axis=0)
    with graph.as_default():
        set_session(sess)
        classes = model.predict_classes(pic)
    return classes

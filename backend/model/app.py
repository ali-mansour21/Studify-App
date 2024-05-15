# Import necessary libraries
from flask import Flask, request, jsonify
from PIL import Image, ImageOps
import io
import requests
import numpy as np
from transformers import TrOCRProcessor, VisionEncoderDecoderModel 

# Initialize Flask app
app = Flask(__name__)

# Load the processor and model
processor = TrOCRProcessor.from_pretrained("./local_model/trocr-processor")
model = VisionEncoderDecoderModel.from_pretrained("./local_model/trocr-model")

# Function to predict text from image
def predict(image):
    pixel_values = processor(image, return_tensors="pt").pixel_values
    generated_ids = model.generate(pixel_values)
    generated_text = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]
    return generated_text

# Function to crop image
def crop_image(img):
    img_bw = img.convert("1")
    binary_matrix = []
    width, height = img_bw.size
    for y in range(height):
        row = []
        for x in range(width):
            pixel = 1 if img_bw.getpixel((x, y)) == 255 else 0
            row.append(pixel)
        binary_matrix.append(row)

    top_crop = 0
    bottom_crop = height - 1
    found_black = False

    for i, row in enumerate(binary_matrix):
        if not found_black:
            if 0 in row:
                found_black = True
        elif all(pixel == 1 for pixel in row):
            bottom_crop = i - 1
            break

    cropped_img = img.crop((0, top_crop, width, bottom_crop + 1))
    bottom_crop += 1
    lower_crop_img = img.crop((0, bottom_crop, width, height))

    return cropped_img, lower_crop_img

# Function to check if the image has black pixels
def has_black_pixels(image):
    grayscale_image = image.convert("L")
    np_image = np.array(grayscale_image)
    return np.any(np_image < 128)

# Flask endpoint to process the image
@app.route('/process_image', methods=['POST'])
def process_image():
    text = ""
    file = request.files['image']
    img = Image.open(io.BytesIO(file.read()))
    
    first, second = "", img
    while True:
        first, second = crop_image(second)
        if first == second:
            break
        if has_black_pixels(first):
            text += predict(first)
        else:
            pass
    response = requests.post('http://192.168.0.104:8001/api/save-text', json={'text': "success"})
    if response.status_code != 200:
      return jsonify({'error': 'Failed to save text'}), 500

    return jsonify({'message': 'Processing complete'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
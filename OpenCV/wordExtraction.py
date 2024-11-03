# import time
import firebase_admin
from firebase_admin import credentials, storage
import cv2
import pytesseract
from googletrans import Translator

# opencv to greyscale and run edge detection/threshold
# then use tesseract (can replace with apple vision OCR) to extract and return text
# once text is extracted, draw a transluscent background and write text over 

def download_new_images():
    blobs = bucket.list_blobs(prefix='images/')
    for blob in blobs:
        if blob.name not in downloaded_images:
            local_filename = f'local_images/{blob.name.split("/")[-1]}'
            blob.download_to_filename(local_filename)  # Download to a local file
            downloaded_images.add(blob.name)  # Add to the set of downloaded images
            print(f'Downloaded: {local_filename}')


def extract_text_from_image(path, lang):
    
    image = cv2.imread(path)

    # grayscale
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # thresholding
    _, thresh_image = cv2.threshold(gray_image, 150, 255, cv2.THRESH_BINARY_INV)

    # extract text
    text = pytesseract.image_to_string(thresh_image)

    if text:
        translator = Translator()
        try:
            translated = translator.translate(text, dest=lang) 
            print(f"Translated Text: '{translated.text}'")
        except Exception as e:
            print(f"Translation Error: {e}")
    else:
        # throw error
        print("No text was extracted from the image.")
        
    return text

if __name__ == "__main__":
    cred = credentials.Certificate('path/to/serviceAccountKey.json')
    firebase_admin.initialize_app(cred, {
        'storageBucket': 'your-bucket-name.appspot.com'
    })
    
    bucket = storage.bucket()
    downloaded_images = set()
    
    image_path = r"C:\Users\jason\Desktop\HackTX24\OpenCV\IMG_3172.jpg"
    extracted_text = extract_text_from_image(image_path)
    
    print(f"Extracted Text: '{extracted_text}'")

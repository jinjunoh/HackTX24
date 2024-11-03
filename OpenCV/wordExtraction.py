import cv2
import pytesseract
from googletrans import Translator

# opencv to greyscale and run edge detection/threshold
# then use tesseract (can replace with apple vision OCR) to extract and return text
# once text is extracted, draw a transluscent background and write text over 

def extract_text_from_image(image_path):
    
    image = cv2.imread(image_path)

    # grayscale
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # thresholding
    _, thresh_image = cv2.threshold(gray_image, 150, 255, cv2.THRESH_BINARY_INV)

    # extract text
    text = pytesseract.image_to_string(thresh_image)

    return text

if __name__ == "__main__":
    image_path = r"C:\Users\jason\Desktop\HackTX24\OpenCV\IMG_3172.jpg"
    extracted_text = extract_text_from_image(image_path)
    
    print(f"Extracted Text: '{extracted_text}'")
    
    if extracted_text:
        translator = Translator()
        try:
            translated = translator.translate(extracted_text, dest='hi') 
            print(f"Translated Text: '{translated.text}'")
        except Exception as e:
            print(f"Translation Error: {e}")
    else:
        print("No text was extracted from the image.")

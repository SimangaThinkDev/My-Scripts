import os, sys, logging, argparse, subprocess

parser = argparse.ArgumentParser(
    prog="compress-image.py",
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description="Compress images to under 1MB"
)

parser.add_argument("-i", "--input", help="Input file path", required=True)
parser.add_argument("-o", "--output", help="Output file path", required=False)
parser.add_argument("-s", "--size", help="Size limit in MB", required=False, default=1)

args = parser.parse_args()
input_image = args.input
output_image = args.output or os.path.splitext(args.input)[0] + "_compressed.jpg"

try:
    from PIL import Image
except ImportError:
    logging.log(20, "PIL not found, installing...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pillow"])
    logging.log(20, "Done installing Pillow, starting image compression")
    from PIL import Image

try:
    MAX_SIZE = int( args.size ) * 1024 * 1024  # 1 MB in bytes
except ValueError:
    logging.log(20, "Invalid size argument, using default 1MB")
    MAX_SIZE = 1 * 1024 * 1024

def compress_image(input_path, output_path):
    with Image.open(input_path) as img:
        # Convert to RGB (important for JPEG)
        if img.mode in ("RGBA", "P"):
            img = img.convert("RGB")

        quality = 95
        img.save(output_path, format="JPEG", quality=quality)

        # Reduce quality until under size limit
        while os.path.getsize(output_path) > MAX_SIZE and quality > 10:
            quality -= 5
            img.save(output_path, format="JPEG", quality=quality)
            print(f"Trying quality={quality} -> size={os.path.getsize(output_path)/1024:.2f} KB")

        # If still too big, resize
        while os.path.getsize(output_path) > MAX_SIZE:
            width, height = img.size
            img = img.resize((int(width * 0.9), int(height * 0.9)))
            img.save(output_path, format="JPEG", quality=quality)
            print(f"Resized to {img.size}, size={os.path.getsize(output_path)/1024:.2f} KB")

    print("Done!")
    print(f"Final size: {os.path.getsize(output_path)/1024:.2f} KB")

# Usage

if __name__ == "__main__":
    # Run the program
    compress_image(input_image, output_image)


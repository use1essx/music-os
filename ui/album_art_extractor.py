#!/usr/bin/env python3
"""
Album Art Extractor for Music OS
Extracts album art from music files and saves them for the UI
"""

import os
import sys
from PIL import Image
import mutagen
from mutagen.mp3 import MP3
from mutagen.id3 import ID3
from mutagen.flac import FLAC
import base64

class AlbumArtExtractor:
    def __init__(self, music_dir="/home/pi/Music", output_dir="/home/pi/MusicUI/assets"):
        self.music_dir = music_dir
        self.output_dir = output_dir
        self.supported_formats = ['.mp3', '.flac', '.wav', '.m4a']
        
        # Create output directory
        os.makedirs(output_dir, exist_ok=True)
        
    def extract_album_art(self, file_path):
        """Extract album art from a music file"""
        try:
            file_ext = os.path.splitext(file_path)[1].lower()
            
            if file_ext == '.mp3':
                return self._extract_from_mp3(file_path)
            elif file_ext == '.flac':
                return self._extract_from_flac(file_path)
            elif file_ext == '.m4a':
                return self._extract_from_m4a(file_path)
            else:
                return None
                
        except Exception as e:
            print(f"Error extracting album art from {file_path}: {e}")
            return None
            
    def _extract_from_mp3(self, file_path):
        """Extract album art from MP3 file"""
        try:
            audio = MP3(file_path, ID3=ID3)
            
            if audio.tags:
                for key in ['APIC:Cover', 'APIC:0', 'APIC']:
                    if key in audio.tags:
                        artwork = audio.tags[key].data
                        return self._save_artwork(artwork, file_path)
                        
        except Exception as e:
            print(f"Error extracting from MP3 {file_path}: {e}")
            
        return None
        
    def _extract_from_flac(self, file_path):
        """Extract album art from FLAC file"""
        try:
            audio = FLAC(file_path)
            
            if audio.pictures:
                for picture in audio.pictures:
                    if picture.type == 3:  # Front cover
                        return self._save_artwork(picture.data, file_path)
                        
        except Exception as e:
            print(f"Error extracting from FLAC {file_path}: {e}")
            
        return None
        
    def _extract_from_m4a(self, file_path):
        """Extract album art from M4A file"""
        try:
            audio = mutagen.File(file_path)
            
            if audio and hasattr(audio, 'tags'):
                for tag in audio.tags:
                    if 'covr' in tag:
                        artwork = audio.tags[tag][0]
                        return self._save_artwork(artwork, file_path)
                        
        except Exception as e:
            print(f"Error extracting from M4A {file_path}: {e}")
            
        return None
        
    def _save_artwork(self, artwork_data, original_file):
        """Save artwork to file"""
        try:
            # Generate filename based on original file
            base_name = os.path.splitext(os.path.basename(original_file))[0]
            output_path = os.path.join(self.output_dir, f"{base_name}_artwork.jpg")
            
            # Save artwork
            with open(output_path, 'wb') as f:
                f.write(artwork_data)
                
            # Resize to standard size
            img = Image.open(output_path)
            img = img.resize((300, 300), Image.Resampling.LANCZOS)
            img.save(output_path, 'JPEG', quality=85)
            
            return output_path
            
        except Exception as e:
            print(f"Error saving artwork: {e}")
            return None
            
    def scan_music_directory(self):
        """Scan music directory and extract album art from all files"""
        print(f"Scanning {self.music_dir} for music files...")
        
        extracted_count = 0
        total_files = 0
        
        for root, dirs, files in os.walk(self.music_dir):
            for file in files:
                if any(file.lower().endswith(ext) for ext in self.supported_formats):
                    total_files += 1
                    file_path = os.path.join(root, file)
                    
                    print(f"Processing: {file}")
                    artwork_path = self.extract_album_art(file_path)
                    
                    if artwork_path:
                        extracted_count += 1
                        print(f"  ✓ Extracted artwork: {artwork_path}")
                    else:
                        print(f"  ✗ No artwork found")
                        
        print(f"\nExtraction complete!")
        print(f"Total files processed: {total_files}")
        print(f"Artwork extracted: {extracted_count}")
        
    def create_default_artwork(self):
        """Create a default artwork for files without album art"""
        default_path = os.path.join(self.output_dir, "default_artwork.jpg")
        
        if not os.path.exists(default_path):
            # Create a simple default artwork
            img = Image.new('RGB', (300, 300), color='#222222')
            
            # Draw a music note
            from PIL import ImageDraw
            draw = ImageDraw.Draw(img)
            
            # Draw a simple music note
            draw.ellipse([120, 100, 180, 160], fill='white')
            draw.rectangle([170, 80, 190, 200], fill='white')
            draw.ellipse([170, 60, 210, 100], fill='white')
            
            img.save(default_path, 'JPEG', quality=85)
            print(f"Created default artwork: {default_path}")

def main():
    if len(sys.argv) > 1:
        music_dir = sys.argv[1]
    else:
        music_dir = "/home/pi/Music"
        
    extractor = AlbumArtExtractor(music_dir)
    
    # Create default artwork
    extractor.create_default_artwork()
    
    # Scan and extract artwork
    extractor.scan_music_directory()

if __name__ == "__main__":
    main() 
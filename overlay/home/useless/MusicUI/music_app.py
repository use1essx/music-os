#!/usr/bin/env python3
"""
Custom Music OS - Main Music Player Application
"""

import tkinter as tk
from tkinter import messagebox
import subprocess
import os

class MusicPlayer:
    def __init__(self):
        self.root = tk.Tk()
        self.setup_window()
        self.setup_ui()
        self.setup_mpd()
        
    def setup_window(self):
        """Configure the main window"""
        self.root.title("Custom Music OS")
        self.root.geometry("800x600")
        self.root.configure(bg='#1a1a1a')
        self.root.attributes('-fullscreen', True)
        self.root.bind('<Escape>', lambda e: self.root.quit())
        
    def setup_ui(self):
        """Create the user interface"""
        # Title
        title = tk.Label(self.root, text="🎵 Custom Music OS", 
                        font=('Arial', 24, 'bold'), 
                        bg='#1a1a1a', fg='white')
        title.pack(pady=20)
        
        # Now playing
        self.now_playing = tk.Label(self.root, text="Now Playing: Nothing", 
                                   font=('Arial', 16), 
                                   bg='#1a1a1a', fg='white')
        self.now_playing.pack(pady=10)
        
        # Controls
        controls = tk.Frame(self.root, bg='#1a1a1a')
        controls.pack(pady=20)
        
        tk.Button(controls, text="⏮️", font=('Arial', 20), 
                 bg='#333333', fg='white',
                 command=self.previous_song).pack(side=tk.LEFT, padx=10)
        
        self.play_button = tk.Button(controls, text="⏯️", font=('Arial', 20), 
                                    bg='#333333', fg='white',
                                    command=self.toggle_play)
        self.play_button.pack(side=tk.LEFT, padx=10)
        
        tk.Button(controls, text="⏭️", font=('Arial', 20), 
                 bg='#333333', fg='white',
                 command=self.next_song).pack(side=tk.LEFT, padx=10)
        
        # Volume
        volume_frame = tk.Frame(self.root, bg='#1a1a1a')
        volume_frame.pack(pady=10)
        
        tk.Label(volume_frame, text="🔈", font=('Arial', 16), 
                bg='#1a1a1a', fg='white').pack(side=tk.LEFT)
        
        self.volume = tk.Scale(volume_frame, from_=0, to=100, 
                              orient=tk.HORIZONTAL, bg='#1a1a1a', fg='white',
                              command=self.set_volume)
        self.volume.set(50)
        self.volume.pack(side=tk.LEFT, padx=10)
        
        # Music list
        self.music_list = tk.Listbox(self.root, bg='#333333', fg='white',
                                     height=15, width=60)
        self.music_list.pack(pady=20)
        self.music_list.bind('<Double-Button-1>', self.play_selected)
        
        # Load music
        self.load_music()
        
    def setup_mpd(self):
        """Setup MPD"""
        try:
            subprocess.run(['sudo', 'systemctl', 'start', 'mpd'], check=True)
            subprocess.run(['mpc', 'update'], check=True)
        except Exception as e:
            print(f"MPD setup error: {e}")
            
    def load_music(self):
        """Load music library"""
        try:
            result = subprocess.run(['mpc', 'listall'], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                songs = result.stdout.strip().split('\n')
                for song in songs:
                    if song.strip():
                        # Extract filename
                        filename = os.path.basename(song)
                        self.music_list.insert(tk.END, filename)
        except Exception as e:
            self.music_list.insert(tk.END, f"Error: {e}")
            
    def play_selected(self, event):
        """Play selected song"""
        selection = self.music_list.curselection()
        if selection:
            index = selection[0]
            try:
                subprocess.run(['mpc', 'clear'], check=True)
                subprocess.run(['mpc', 'add', f'file://{index}'], check=True)
                subprocess.run(['mpc', 'play'], check=True)
                self.update_display()
            except Exception as e:
                print(f"Play error: {e}")
                
    def toggle_play(self):
        """Toggle play/pause"""
        try:
            subprocess.run(['mpc', 'toggle'], check=True)
            self.update_display()
        except Exception as e:
            print(f"Toggle error: {e}")
            
    def next_song(self):
        """Next song"""
        try:
            subprocess.run(['mpc', 'next'], check=True)
            self.update_display()
        except Exception as e:
            print(f"Next error: {e}")
            
    def previous_song(self):
        """Previous song"""
        try:
            subprocess.run(['mpc', 'prev'], check=True)
            self.update_display()
        except Exception as e:
            print(f"Previous error: {e}")
            
    def set_volume(self, value):
        """Set volume"""
        try:
            subprocess.run(['mpc', 'volume', str(int(value))], check=True)
        except Exception as e:
            print(f"Volume error: {e}")
            
    def update_display(self):
        """Update display"""
        try:
            result = subprocess.run(['mpc', 'current'], 
                                  capture_output=True, text=True)
            if result.returncode == 0 and result.stdout.strip():
                current = result.stdout.strip()
                self.now_playing.config(text=f"Now Playing: {current}")
            else:
                self.now_playing.config(text="Now Playing: Nothing")
        except Exception as e:
            print(f"Update error: {e}")
            
    def run(self):
        """Start the application"""
        self.update_display()
        self.root.after(1000, self.update_display)
        self.root.mainloop()

if __name__ == "__main__":
    app = MusicPlayer()
    app.run() 
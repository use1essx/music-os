#!/usr/bin/env python3
"""
Video Player Component for Music OS
Supports: MP4, AVI, MKV, MOV
"""

import tkinter as tk
from tkinter import ttk, messagebox
import subprocess
import threading
import time
import os
import json
import math

# Handle VLC imports
try:
    import vlc
except ImportError:
    print("Warning: python-vlc not available, video features will be limited")
    vlc = None

class VideoPlayer:
    def __init__(self):
        self.root = tk.Tk()
        self.setup_window()
        self.setup_variables()
        self.setup_ui()
        self.setup_vlc()
        
    def setup_window(self):
        """Configure the main window"""
        self.root.title("Music OS - Video Player")
        self.root.geometry("800x600")
        self.root.configure(bg='black')
        
        # Fullscreen toggle
        self.root.bind('<F11>', self.toggle_fullscreen)
        self.root.bind('<Escape>', self.exit_fullscreen)
        
        # Make window fullscreen
        self.root.attributes('-fullscreen', True)
        
    def setup_variables(self):
        """Initialize variables"""
        self.is_playing = False
        self.current_video = None
        self.video_duration = 0
        self.current_position = 0
        self.volume = 50
        self.is_fullscreen = True
        
    def setup_ui(self):
        """Create the video player interface"""
        # Main frame
        main_frame = tk.Frame(self.root, bg='black')
        main_frame.pack(expand=True, fill='both')
        
        # Video display frame
        self.video_frame = tk.Frame(main_frame, bg='black')
        self.video_frame.pack(expand=True, fill='both')
        
        # Controls frame (hidden by default, shown on mouse move)
        self.controls_frame = tk.Frame(main_frame, bg='#000000')
        self.controls_frame.pack(fill='x', side='bottom')
        
        # Play/Pause button
        self.play_button = tk.Button(
            self.controls_frame,
            text="▶",
            font=('Arial', 16),
            bg='#333333',
            fg='white',
            command=self.toggle_play
        )
        self.play_button.pack(side='left', padx=10, pady=5)
        
        # Progress bar
        self.progress_var = tk.DoubleVar()
        self.progress_bar = ttk.Progressbar(
            self.controls_frame,
            variable=self.progress_var,
            maximum=100,
            length=400,
            mode='determinate'
        )
        self.progress_bar.pack(side='left', padx=10, pady=5)
        
        # Time labels
        self.time_label = tk.Label(
            self.controls_frame,
            text="0:00 / 0:00",
            font=('Arial', 10),
            fg='white',
            bg='#000000'
        )
        self.time_label.pack(side='left', padx=10, pady=5)
        
        # Volume control
        self.volume_var = tk.IntVar(value=self.volume)
        self.volume_slider = ttk.Scale(
            self.controls_frame,
            from_=0,
            to=100,
            orient='horizontal',
            variable=self.volume_var,
            command=self.set_volume,
            length=100
        )
        self.volume_slider.pack(side='right', padx=10, pady=5)
        
        # Hide controls initially
        self.controls_frame.pack_forget()
        
        # Mouse movement detection
        self.root.bind('<Motion>', self.show_controls)
        self.root.bind('<Leave>', self.hide_controls)
        
        # Keyboard bindings
        self.setup_keyboard_bindings()
        
    def setup_vlc(self):
        """Initialize VLC instance"""
        if vlc:
            self.vlc_instance = vlc.Instance()
            self.media_player = self.vlc_instance.media_player_new()
        else:
            self.vlc_instance = None
            self.media_player = None
            
    def setup_keyboard_bindings(self):
        """Setup keyboard shortcuts"""
        self.root.bind('<space>', lambda e: self.toggle_play())
        self.root.bind('<Left>', lambda e: self.seek_backward())
        self.root.bind('<Right>', lambda e: self.seek_forward())
        self.root.bind('<Up>', lambda e: self.volume_up())
        self.root.bind('<Down>', lambda e: self.volume_down())
        self.root.bind('<q>', lambda e: self.quit())
        
    def show_controls(self, event=None):
        """Show video controls"""
        self.controls_frame.pack(fill='x', side='bottom')
        self.root.after(3000, self.hide_controls)
        
    def hide_controls(self, event=None):
        """Hide video controls"""
        if not self.is_fullscreen:
            return
        self.controls_frame.pack_forget()
        
    def toggle_fullscreen(self, event=None):
        """Toggle fullscreen mode"""
        self.is_fullscreen = not self.is_fullscreen
        self.root.attributes('-fullscreen', self.is_fullscreen)
        
    def exit_fullscreen(self, event=None):
        """Exit fullscreen mode"""
        self.is_fullscreen = False
        self.root.attributes('-fullscreen', False)
        
    def load_video(self, file_path):
        """Load a video file"""
        if not vlc or not self.media_player:
            messagebox.showerror("Error", "VLC not available")
            return
            
        if not os.path.exists(file_path):
            messagebox.showerror("Error", f"File not found: {file_path}")
            return
            
        # Supported video formats
        supported_formats = ['.mp4', '.avi', '.mkv', '.mov', '.wmv', '.flv']
        file_ext = os.path.splitext(file_path)[1].lower()
        
        if file_ext not in supported_formats:
            messagebox.showerror("Error", f"Unsupported format: {file_ext}")
            return
            
        try:
            # Create media
            media = self.vlc_instance.media_new(file_path)
            self.media_player.set_media(media)
            
            # Get video frame
            if hasattr(self.video_frame, 'winfo_id'):
                self.media_player.set_hwnd(self.video_frame.winfo_id())
            
            self.current_video = file_path
            self.is_playing = False
            
            # Update UI
            self.update_video_info()
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load video: {e}")
            
    def update_video_info(self):
        """Update video information display"""
        if self.current_video:
            filename = os.path.basename(self.current_video)
            self.root.title(f"Music OS - {filename}")
            
    def toggle_play(self):
        """Toggle play/pause"""
        if not self.media_player:
            return
            
        if self.is_playing:
            self.media_player.pause()
            self.play_button.config(text="▶")
        else:
            self.media_player.play()
            self.play_button.config(text="⏸")
            
        self.is_playing = not self.is_playing
        
    def seek_forward(self):
        """Seek forward 10 seconds"""
        if self.media_player:
            current_time = self.media_player.get_time()
            self.media_player.set_time(current_time + 10000)
            
    def seek_backward(self):
        """Seek backward 10 seconds"""
        if self.media_player:
            current_time = self.media_player.get_time()
            self.media_player.set_time(max(0, current_time - 10000))
            
    def set_volume(self, value):
        """Set volume"""
        self.volume = int(value)
        if self.media_player:
            self.media_player.audio_set_volume(self.volume)
            
    def volume_up(self):
        """Increase volume"""
        self.volume = min(100, self.volume + 10)
        self.volume_var.set(self.volume)
        self.set_volume(self.volume)
        
    def volume_down(self):
        """Decrease volume"""
        self.volume = max(0, self.volume - 10)
        self.volume_var.set(self.volume)
        self.set_volume(self.volume)
        
    def update_progress(self):
        """Update progress bar and time display"""
        if self.media_player and self.current_video:
            try:
                # Get current time and duration
                current_time = self.media_player.get_time() or 0
                duration = self.media_player.get_length() or 0
                
                if duration > 0:
                    # Update progress bar
                    progress = (current_time / duration) * 100
                    self.progress_var.set(progress)
                    
                    # Update time labels
                    current_str = self.format_time(current_time)
                    duration_str = self.format_time(duration)
                    self.time_label.config(text=f"{current_str} / {duration_str}")
                    
            except Exception as e:
                print(f"Error updating progress: {e}")
                
    def format_time(self, milliseconds):
        """Format milliseconds to MM:SS"""
        if milliseconds <= 0:
            return "0:00"
        seconds = milliseconds // 1000
        minutes = seconds // 60
        seconds = seconds % 60
        return f"{minutes}:{seconds:02d}"
        
    def quit(self):
        """Quit the video player"""
        if self.media_player:
            self.media_player.stop()
        self.root.quit()
        
    def run(self):
        """Start the video player"""
        # Start progress update thread
        def update_loop():
            while True:
                try:
                    self.root.after(0, self.update_progress)
                    time.sleep(0.1)
                except:
                    break
                    
        update_thread = threading.Thread(target=update_loop, daemon=True)
        update_thread.start()
        
        # Start the GUI
        self.root.mainloop()

if __name__ == "__main__":
    player = VideoPlayer()
    
    # Test with a video file if provided
    import sys
    if len(sys.argv) > 1:
        player.load_video(sys.argv[1])
        
    player.run() 
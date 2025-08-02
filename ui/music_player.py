#!/usr/bin/env python3
"""
Music OS - Main Player Application
iPod-inspired music player for Raspberry Pi
"""

import tkinter as tk
from tkinter import ttk, messagebox
import subprocess
import threading
import time
import os
import json
from PIL import Image, ImageTk, ImageDraw
import mutagen
from mutagen.mp3 import MP3
from mutagen.id3 import ID3
import pygame
import math

class MusicPlayer:
    def __init__(self):
        self.root = tk.Tk()
        self.setup_window()
        self.setup_variables()
        self.setup_ui()
        self.setup_mpd()
        self.setup_keyboard_bindings()
        self.update_playlist()
        self.start_update_thread()
        
    def setup_window(self):
        """Configure the main window"""
        self.root.title("Music OS")
        self.root.configure(bg='black')
        
        # Get screen dimensions
        screen_width = self.root.winfo_screenwidth()
        screen_height = self.root.winfo_screenheight()
        
        # Set fullscreen
        self.root.attributes('-fullscreen', True)
        self.root.geometry(f"{screen_width}x{screen_height}")
        
        # Prevent window from being resized
        self.root.resizable(False, False)
        
    def setup_variables(self):
        """Initialize player variables"""
        self.current_track = None
        self.is_playing = False
        self.volume = 50
        self.playlist = []
        self.current_index = 0
        self.update_interval = 1000  # 1 second
        
    def setup_ui(self):
        """Create the iPod-inspired user interface"""
        # Main frame
        main_frame = tk.Frame(self.root, bg='black')
        main_frame.pack(expand=True, fill='both', padx=20, pady=20)
        
        # Title
        title_label = tk.Label(
            main_frame, 
            text="Music OS", 
            font=('Arial', 24, 'bold'),
            fg='white',
            bg='black'
        )
        title_label.pack(pady=(0, 20))
        
        # Album art frame
        self.album_frame = tk.Frame(main_frame, bg='black', width=300, height=300)
        self.album_frame.pack(pady=20)
        self.album_frame.pack_propagate(False)
        
        # Default album art
        self.create_default_album_art()
        
        # Track info frame
        info_frame = tk.Frame(main_frame, bg='black')
        info_frame.pack(pady=20)
        
        # Track title
        self.title_label = tk.Label(
            info_frame,
            text="No track selected",
            font=('Arial', 16, 'bold'),
            fg='white',
            bg='black',
            wraplength=400
        )
        self.title_label.pack()
        
        # Artist
        self.artist_label = tk.Label(
            info_frame,
            text="Unknown Artist",
            font=('Arial', 14),
            fg='#888888',
            bg='black'
        )
        self.artist_label.pack()
        
        # Album
        self.album_label = tk.Label(
            info_frame,
            text="Unknown Album",
            font=('Arial', 12),
            fg='#666666',
            bg='black'
        )
        self.album_label.pack()
        
        # Progress bar
        progress_frame = tk.Frame(main_frame, bg='black')
        progress_frame.pack(pady=20, fill='x', padx=50)
        
        self.progress_var = tk.DoubleVar()
        self.progress_bar = ttk.Progressbar(
            progress_frame,
            variable=self.progress_var,
            maximum=100,
            length=400,
            mode='determinate'
        )
        self.progress_bar.pack()
        
        # Time labels
        time_frame = tk.Frame(progress_frame, bg='black')
        time_frame.pack(fill='x')
        
        self.current_time_label = tk.Label(
            time_frame,
            text="0:00",
            font=('Arial', 10),
            fg='white',
            bg='black'
        )
        self.current_time_label.pack(side='left')
        
        self.total_time_label = tk.Label(
            time_frame,
            text="0:00",
            font=('Arial', 10),
            fg='white',
            bg='black'
        )
        self.total_time_label.pack(side='right')
        
        # Control buttons frame
        controls_frame = tk.Frame(main_frame, bg='black')
        controls_frame.pack(pady=30)
        
        # Create wheel-style controls
        self.create_wheel_controls(controls_frame)
        
        # Volume frame
        volume_frame = tk.Frame(main_frame, bg='black')
        volume_frame.pack(pady=10)
        
        # Volume label
        volume_label = tk.Label(
            volume_frame,
            text="Volume",
            font=('Arial', 12),
            fg='white',
            bg='black'
        )
        volume_label.pack()
        
        # Volume slider
        self.volume_var = tk.IntVar(value=self.volume)
        self.volume_slider = ttk.Scale(
            volume_frame,
            from_=0,
            to=100,
            orient='horizontal',
            variable=self.volume_var,
            command=self.set_volume,
            length=200
        )
        self.volume_slider.pack()
        
    def setup_ui(self):
        """Create the iPod-inspired user interface"""
        # Main frame
        main_frame = tk.Frame(self.root, bg='black')
        main_frame.pack(expand=True, fill='both', padx=20, pady=20)
        
        # Title
        title_label = tk.Label(
            main_frame, 
            text="Music OS", 
            font=('Arial', 24, 'bold'),
            fg='white',
            bg='black'
        )
        title_label.pack(pady=(0, 20))
        
        # Album art frame
        self.album_frame = tk.Frame(main_frame, bg='black', width=300, height=300)
        self.album_frame.pack(pady=20)
        self.album_frame.pack_propagate(False)
        
        # Default album art
        self.create_default_album_art()
        
        # Track info frame
        info_frame = tk.Frame(main_frame, bg='black')
        info_frame.pack(pady=20)
        
        # Track title
        self.title_label = tk.Label(
            info_frame,
            text="No track selected",
            font=('Arial', 16, 'bold'),
            fg='white',
            bg='black',
            wraplength=400
        )
        self.title_label.pack()
        
        # Artist
        self.artist_label = tk.Label(
            info_frame,
            text="Unknown Artist",
            font=('Arial', 14),
            fg='#888888',
            bg='black'
        )
        self.artist_label.pack()
        
        # Album
        self.album_label = tk.Label(
            info_frame,
            text="Unknown Album",
            font=('Arial', 12),
            fg='#666666',
            bg='black'
        )
        self.album_label.pack()
        
        # Progress bar
        progress_frame = tk.Frame(main_frame, bg='black')
        progress_frame.pack(pady=20, fill='x', padx=50)
        
        self.progress_var = tk.DoubleVar()
        self.progress_bar = ttk.Progressbar(
            progress_frame,
            variable=self.progress_var,
            maximum=100,
            length=400,
            mode='determinate'
        )
        self.progress_bar.pack()
        
        # Time labels
        time_frame = tk.Frame(progress_frame, bg='black')
        time_frame.pack(fill='x')
        
        self.current_time_label = tk.Label(
            time_frame,
            text="0:00",
            font=('Arial', 10),
            fg='white',
            bg='black'
        )
        self.current_time_label.pack(side='left')
        
        self.total_time_label = tk.Label(
            time_frame,
            text="0:00",
            font=('Arial', 10),
            fg='white',
            bg='black'
        )
        self.total_time_label.pack(side='right')
        
        # Control buttons frame
        controls_frame = tk.Frame(main_frame, bg='black')
        controls_frame.pack(pady=30)
        
        # Create wheel-style controls
        self.create_wheel_controls(controls_frame)
        
        # Volume frame
        volume_frame = tk.Frame(main_frame, bg='black')
        volume_frame.pack(pady=10)
        
        # Volume label
        volume_label = tk.Label(
            volume_frame,
            text="Volume",
            font=('Arial', 12),
            fg='white',
            bg='black'
        )
        volume_label.pack()
        
        # Volume slider
        self.volume_var = tk.IntVar(value=self.volume)
        self.volume_slider = ttk.Scale(
            volume_frame,
            from_=0,
            to=100,
            orient='horizontal',
            variable=self.volume_var,
            command=self.set_volume,
            length=200
        )
        self.volume_slider.pack()
        
    def create_wheel_controls(self, parent):
        """Create iPod-style wheel controls"""
        # Wheel frame
        wheel_frame = tk.Frame(parent, bg='black')
        wheel_frame.pack()
        
        # Create wheel canvas
        self.wheel_canvas = tk.Canvas(
            wheel_frame,
            width=200,
            height=200,
            bg='black',
            highlightthickness=0
        )
        self.wheel_canvas.pack()
        
        # Draw wheel
        self.draw_wheel()
        
        # Bind wheel events
        self.wheel_canvas.bind('<Button-1>', self.on_wheel_click)
        self.wheel_canvas.bind('<B1-Motion>', self.on_wheel_drag)
        
    def draw_wheel(self):
        """Draw the iPod-style wheel"""
        # Clear canvas
        self.wheel_canvas.delete('all')
        
        # Wheel dimensions
        center_x, center_y = 100, 100
        outer_radius = 80
        inner_radius = 40
        
        # Draw outer circle
        self.wheel_canvas.create_oval(
            center_x - outer_radius,
            center_y - outer_radius,
            center_x + outer_radius,
            center_y + outer_radius,
            outline='#333333',
            width=2
        )
        
        # Draw inner circle
        self.wheel_canvas.create_oval(
            center_x - inner_radius,
            center_y - inner_radius,
            center_x + inner_radius,
            center_y + inner_radius,
            outline='#333333',
            width=2
        )
        
        # Draw control buttons
        button_size = 15
        
        # Play/Pause button (center)
        self.wheel_canvas.create_oval(
            center_x - button_size,
            center_y - button_size,
            center_x + button_size,
            center_y + button_size,
            fill='#444444',
            outline='#666666',
            tags='play_button'
        )
        
        # Previous button (left)
        self.wheel_canvas.create_oval(
            center_x - outer_radius + 10,
            center_y - button_size,
            center_x - outer_radius + 10 + button_size * 2,
            center_y + button_size,
            fill='#444444',
            outline='#666666',
            tags='prev_button'
        )
        
        # Next button (right)
        self.wheel_canvas.create_oval(
            center_x + outer_radius - 10 - button_size * 2,
            center_y - button_size,
            center_x + outer_radius - 10,
            center_y + button_size,
            fill='#444444',
            outline='#666666',
            tags='next_button'
        )
        
        # Volume up button (top)
        self.wheel_canvas.create_oval(
            center_x - button_size,
            center_y - outer_radius + 10,
            center_x + button_size,
            center_y - outer_radius + 10 + button_size * 2,
            fill='#444444',
            outline='#666666',
            tags='vol_up_button'
        )
        
        # Volume down button (bottom)
        self.wheel_canvas.create_oval(
            center_x - button_size,
            center_y + outer_radius - 10 - button_size * 2,
            center_x + button_size,
            center_y + outer_radius - 10,
            fill='#444444',
            outline='#666666',
            tags='vol_down_button'
        )
        
    def on_wheel_click(self, event):
        """Handle wheel button clicks"""
        x, y = event.x, event.y
        center_x, center_y = 100, 100
        
        # Check which button was clicked
        if self.is_point_in_circle(x, y, center_x, center_y, 15):
            self.toggle_play()
        elif self.is_point_in_circle(x, y, center_x - 70, center_y, 15):
            self.previous_track()
        elif self.is_point_in_circle(x, y, center_x + 70, center_y, 15):
            self.next_track()
        elif self.is_point_in_circle(x, y, center_x, center_y - 70, 15):
            self.volume_up()
        elif self.is_point_in_circle(x, y, center_x, center_y + 70, 15):
            self.volume_down()
            
    def is_point_in_circle(self, x, y, cx, cy, radius):
        """Check if point is inside circle"""
        return math.sqrt((x - cx)**2 + (y - cy)**2) <= radius
        
    def on_wheel_drag(self, event):
        """Handle wheel drag for volume control"""
        # This could be used for continuous volume control
        pass
        
    def create_default_album_art(self):
        """Create a default album art image"""
        # Create a 300x300 image with a music note
        img = Image.new('RGB', (300, 300), color='#222222')
        draw = ImageDraw.Draw(img)
        
        # Draw a simple music note
        draw.ellipse([120, 100, 180, 160], fill='white')
        draw.rectangle([170, 80, 190, 200], fill='white')
        draw.ellipse([170, 60, 210, 100], fill='white')
        
        self.album_photo = ImageTk.PhotoImage(img)
        
        # Create label for album art
        self.album_label = tk.Label(
            self.album_frame,
            image=self.album_photo,
            bg='black'
        )
        self.album_label.pack()
        
    def setup_mpd(self):
        """Initialize MPD connection"""
        try:
            # Start MPD if not running
            subprocess.run(['systemctl', 'start', 'mpd'], check=True)
            time.sleep(1)
            
            # Update MPD database
            subprocess.run(['mpc', 'update'], check=True)
            
        except subprocess.CalledProcessError as e:
            print(f"Error setting up MPD: {e}")
            
    def setup_keyboard_bindings(self):
        """Set up keyboard shortcuts"""
        self.root.bind('<space>', lambda e: self.toggle_play())
        self.root.bind('<Left>', lambda e: self.previous_track())
        self.root.bind('<Right>', lambda e: self.next_track())
        self.root.bind('<Up>', lambda e: self.volume_up())
        self.root.bind('<Down>', lambda e: self.volume_down())
        self.root.bind('<Escape>', lambda e: self.root.quit())
        self.root.bind('<Control-c>', lambda e: self.root.quit())
        
    def update_playlist(self):
        """Update the playlist from MPD"""
        try:
            result = subprocess.run(['mpc', 'playlist'], capture_output=True, text=True)
            if result.returncode == 0:
                self.playlist = [line.strip() for line in result.stdout.split('\n') if line.strip()]
        except Exception as e:
            print(f"Error updating playlist: {e}")
            
    def get_current_track_info(self):
        """Get current track information from MPD"""
        try:
            # Get current song info
            result = subprocess.run(['mpc', 'current', '-f', '%title%|%artist%|%album%|%time%'], 
                                  capture_output=True, text=True)
            
            if result.returncode == 0 and result.stdout.strip():
                info = result.stdout.strip().split('|')
                if len(info) >= 4:
                    return {
                        'title': info[0] if info[0] != 'unknown' else 'Unknown Title',
                        'artist': info[1] if info[1] != 'unknown' else 'Unknown Artist',
                        'album': info[2] if info[2] != 'unknown' else 'Unknown Album',
                        'time': info[3]
                    }
        except Exception as e:
            print(f"Error getting track info: {e}")
            
        return None
        
    def update_ui(self):
        """Update the user interface"""
        try:
            # Get current track info
            track_info = self.get_current_track_info()
            
            if track_info:
                # Update labels
                self.title_label.config(text=track_info['title'])
                self.artist_label.config(text=track_info['artist'])
                self.album_label.config(text=track_info['album'])
                
                # Update progress
                time_parts = track_info['time'].split(':')
                if len(time_parts) == 2:
                    current, total = time_parts
                    try:
                        current_sec = int(current.split(':')[0]) * 60 + int(current.split(':')[1])
                        total_sec = int(total.split(':')[0]) * 60 + int(total.split(':')[1])
                        
                        if total_sec > 0:
                            progress = (current_sec / total_sec) * 100
                            self.progress_var.set(progress)
                            
                        # Update time labels
                        self.current_time_label.config(text=current)
                        self.total_time_label.config(text=total)
                    except:
                        pass
                        
            # Check play status
            result = subprocess.run(['mpc', 'status'], capture_output=True, text=True)
            if result.returncode == 0:
                status_lines = result.stdout.split('\n')
                for line in status_lines:
                    if '[playing]' in line:
                        self.is_playing = True
                        break
                    elif '[paused]' in line:
                        self.is_playing = False
                        break
                        
        except Exception as e:
            print(f"Error updating UI: {e}")
            
    def start_update_thread(self):
        """Start the update thread"""
        def update_loop():
            while True:
                self.root.after(0, self.update_ui)
                time.sleep(1)
                
        thread = threading.Thread(target=update_loop, daemon=True)
        thread.start()
        
    def toggle_play(self):
        """Toggle play/pause"""
        try:
            subprocess.run(['mpc', 'toggle'], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error toggling play: {e}")
            
    def next_track(self):
        """Play next track"""
        try:
            subprocess.run(['mpc', 'next'], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error playing next track: {e}")
            
    def previous_track(self):
        """Play previous track"""
        try:
            subprocess.run(['mpc', 'prev'], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error playing previous track: {e}")
            
    def set_volume(self, value):
        """Set volume"""
        try:
            volume = int(float(value))
            subprocess.run(['mpc', 'volume', str(volume)], check=True)
            self.volume = volume
        except subprocess.CalledProcessError as e:
            print(f"Error setting volume: {e}")
            
    def volume_up(self):
        """Increase volume"""
        new_volume = min(100, self.volume + 10)
        self.volume_var.set(new_volume)
        self.set_volume(new_volume)
        
    def volume_down(self):
        """Decrease volume"""
        new_volume = max(0, self.volume - 10)
        self.volume_var.set(new_volume)
        self.set_volume(new_volume)
        
    def run(self):
        """Start the application"""
        try:
            self.root.mainloop()
        except KeyboardInterrupt:
            print("Shutting down Music OS...")
        finally:
            # Cleanup
            try:
                subprocess.run(['mpc', 'stop'], check=True)
            except:
                pass

if __name__ == "__main__":
    player = MusicPlayer()
    player.run() 
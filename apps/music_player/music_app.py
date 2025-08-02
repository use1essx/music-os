import tkinter as tk

class MusicPlayer(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Music OS")
        self.geometry("800x480")
        self.configure(bg="#121212")
        self.create_widgets()

    def create_widgets(self):
        # Now Playing Label
        now_playing_label = tk.Label(self, text="Now Playing: [Song Title - Artist]", bg="#121212", fg="#FFFFFF", font=("sans-serif", 16))
        now_playing_label.pack(pady=10)

        # Album Art
        album_art_label = tk.Label(self, text="[Album Art]", bg="#282828", fg="#FFFFFF", width=50, height=20)
        album_art_label.pack(pady=20)

        # Controls Frame
        controls_frame = tk.Frame(self, bg="#121212")
        controls_frame.pack(pady=10)

        prev_button = tk.Button(controls_frame, text="⏮️", bg="#121212", fg="#FFFFFF", font=("sans-serif", 20), borderwidth=0)
        prev_button.grid(row=0, column=0, padx=10)

        play_pause_button = tk.Button(controls_frame, text="⏯️", bg="#121212", fg="#FFFFFF", font=("sans-serif", 20), borderwidth=0)
        play_pause_button.grid(row=0, column=1, padx=10)

        next_button = tk.Button(controls_frame, text="⏭️", bg="#121212", fg="#FFFFFF", font=("sans-serif", 20), borderwidth=0)
        next_button.grid(row=0, column=2, padx=10)

        # Volume Scale
        volume_scale = tk.Scale(controls_frame, from_=0, to=100, orient=tk.HORIZONTAL, bg="#121212", fg="#FFFFFF", troughcolor="#535353", highlightthickness=0)
        volume_scale.set(75)
        volume_scale.grid(row=0, column=3, padx=50)

        # Tab Bar Frame
        tab_bar_frame = tk.Frame(self, bg="#282828")
        tab_bar_frame.pack(fill=tk.X, side=tk.BOTTOM)

        local_music_button = tk.Button(tab_bar_frame, text="Local Music", bg="#282828", fg="#FFFFFF", font=("sans-serif", 12), borderwidth=0)
        local_music_button.pack(side=tk.LEFT, expand=True, fill=tk.X)

        youtube_button = tk.Button(tab_bar_frame, text="YouTube", bg="#282828", fg="#FFFFFF", font=("sans-serif", 12), borderwidth=0)
        youtube_button.pack(side=tk.LEFT, expand=True, fill=tk.X)

        spotify_button = tk.Button(tab_bar_frame, text="Spotify", bg="#282828", fg="#FFFFFF", font=("sans-serif", 12), borderwidth=0)
        spotify_button.pack(side=tk.LEFT, expand=True, fill=tk.X)

        settings_button = tk.Button(tab_bar_frame, text="Settings", bg="#282828", fg="#FFFFFF", font=("sans-serif", 12), borderwidth=0)
        settings_button.pack(side=tk.LEFT, expand=True, fill=tk.X)

if __name__ == "__main__":
    app = MusicPlayer()
    app.mainloop()
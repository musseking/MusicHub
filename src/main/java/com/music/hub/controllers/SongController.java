package com.music.hub.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.music.hub.service.SongService;

@Controller
public class SongController {
    private final SongService songService;

    public SongController(SongService songService) {
        this.songService = songService;
    }

    // JAVNA RUTA - SVI MOGU DA VIDELISTU PESAMA
    @GetMapping("/songs")
    public String listSongs(Model model) {
        model.addAttribute("songs", songService.getAllSongs());
        model.addAttribute("title", "All Songs - MusicHub");
        return "songs";
    }

    // JAVNA RUTA - SVI MOGU DA VIDEDETALJE O PESMI
    @GetMapping("/songs/{id}")
    public String songDetails(@PathVariable Long id, Model model) {
        // OVDE ĆETE DODATI LOGIKU ZA PREUZIMANJE PESME PO ID
        model.addAttribute("title", "Song Details");
        return "song-details";
    }

    // JAVNA RUTA - 30-SEKUNDNI PREVIEW (za nelogovane)
    @GetMapping("/preview/{id}")
    public String songPreview(@PathVariable Long id, Model model) {
        model.addAttribute("title", "Song Preview");
        return "song-preview";
    }

    // ZAŠTIĆENA RUTA - DOWNLOAD (samo logovani)
    @GetMapping("/download/{id}")
    public String downloadSong(@PathVariable Long id) {
        // OVDE ĆETE DODATI LOGIKU ZA DOWNLOAD
        return "redirect:/songs";
    }
}
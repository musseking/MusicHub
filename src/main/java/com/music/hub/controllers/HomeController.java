package com.music.hub.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.music.hub.service.SongService;

@Controller
public class HomeController {
    private final SongService songService;

    public HomeController(SongService songService) {
        this.songService = songService;
    }
    
    @GetMapping({"/", "/index", "/home"})
    public String home(Model model) {
        System.out.println("=== HOME CONTROLLER - PUBLIC ACCESS ===");
        
        var songs = songService.getAllSongs();
        System.out.println("Found " + songs.size() + " songs");
        
        model.addAttribute("title", "MusicHub - Share, Discover, Download Music");
        model.addAttribute("songs", songs);
        
        return "index";
    }
}
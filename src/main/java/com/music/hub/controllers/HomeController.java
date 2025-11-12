package com.music.hub.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.music.hub.service.SongService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import com.music.hub.repository.UserRepository;
import com.music.hub.entity.User;

@Controller
public class HomeController {
    private final SongService songService;
    private final UserRepository userRepository;

    public HomeController(SongService songService, UserRepository userRepository) {
        this.songService = songService;
        this.userRepository = userRepository;
    }
    
    @GetMapping({"/", "/index", "/home"})
    public String home(Model model, Authentication authentication) {
        System.out.println("=== HOME CONTROLLER - PUBLIC ACCESS ===");
        
        var songs = songService.getAllSongs();
        System.out.println("Found " + songs.size() + " songs");
        
        model.addAttribute("title", "MusicHub - Share, Discover, Download Music");
        model.addAttribute("songs", songs);
        model.addAttribute("isLoggedIn", false);
        model.addAttribute("loggedUserRole", "NOT_REGISTERED");
        model.addAttribute("loggedDisplayRole", "Not Registered");
        model.addAttribute("displayName", "Guest User");
        
        if (authentication != null && authentication.isAuthenticated()) {
            String username = authentication.getName();
            String userRole = "USER";
            String displayRole = "Registered";
            String displayName = username;
            
            for (GrantedAuthority authority : authentication.getAuthorities()) {
                if (authority.getAuthority().equals("ROLE_ADMIN")) {
                    userRole = "ADMIN";
                    displayRole = "Administrator";
                    displayName = "Admin";
                    break;
                } else if (authority.getAuthority().equals("ROLE_ARTIST")) {
                    userRole = "ARTIST";
                    displayRole = "Artist";
                    break;
                }
            }
            
            if (!userRole.equals("ADMIN")) {
                User user = userRepository.findByUsername(username).orElse(null);
                if (user != null) {
                    displayName = user.getFirstName() + " " + user.getLastName();
                }
            }
            
            model.addAttribute("isLoggedIn", true);
            model.addAttribute("loggedUsername", username);
            model.addAttribute("loggedUserRole", userRole);
            model.addAttribute("loggedDisplayRole", displayRole);
            model.addAttribute("displayName", displayName);
            System.out.println("=== LOGGED USER: " + username + " | DISPLAY NAME: " + displayName + " | ROLE: " + userRole + " ===");
        }
        
        return "index";
    }
}
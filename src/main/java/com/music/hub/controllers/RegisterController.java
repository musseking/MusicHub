package com.music.hub.controllers;

import com.music.hub.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;

@Controller
public class RegisterController {
    private final UserService userService;

    public RegisterController(UserService userService) {
        this.userService = userService;
    }

    // Prikaz forme za registrovanje običnih korisnika
    @GetMapping("/register")
    public String showRegisterForm(Model model, Authentication authentication) {
        // Ako je korisnik već ulogovan, preusmeri ga na početnu stranicu
        if (authentication != null && authentication.isAuthenticated()) {
            return "redirect:/";
        }
        
        model.addAttribute("title", "Register - MusicHub");
        return "register";
    }

    // Obrada registrovanja običnih korisnika
    @PostMapping("/register")
    public String registerUser(@RequestParam String username,
                             @RequestParam String email,
                             @RequestParam String password,
                             @RequestParam String firstName,
                             @RequestParam String lastName,
                             Model model) {
        try {
            userService.registerUser(username, email, password, firstName, lastName, false);
            model.addAttribute("success", "Registration successful! Please login.");
            return "redirect:/login?success=true";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("username", username);
            model.addAttribute("email", email);
            model.addAttribute("firstName", firstName);
            model.addAttribute("lastName", lastName);
            return "register";
        }
    }

    // Pomocna metoda za proveru admin role
    private boolean isAdmin(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }
        
        for (GrantedAuthority authority : authentication.getAuthorities()) {
            if (authority.getAuthority().equals("ROLE_ADMIN")) {
                return true;
            }
        }
        return false;
    }
}
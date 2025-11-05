package com.music.hub.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {
    
    @GetMapping("/login")
    public String login(@RequestParam(value = "error", required = false) String error,
                       @RequestParam(value = "logout", required = false) String logout,
                       Model model) { 
        System.out.println("=== LOGIN PAGE ACCESSED ===");
        
        if (error != null) {
            model.addAttribute("error", "Invalid username or password!");
            System.out.println("=== LOGIN ERROR ===");
        }
        
        if (logout != null) {
            model.addAttribute("message", "You have been logged out successfully.");
            System.out.println("=== LOGOUT SUCCESS ===");
        }
        
        return "login"; 
    }

    @GetMapping("/register")
    public String register() {
        System.out.println("=== REGISTER PAGE - PUBLIC ACCESS ===");
        return "register";
    }
}
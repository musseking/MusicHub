package com.music.hub.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {
    
    @GetMapping("/login")
    public String login() { 
        System.out.println("=== LOGIN PAGE - PUBLIC ACCESS ===");
        return "login"; 
    }

    @GetMapping("/register")
    public String register() {
        System.out.println("=== REGISTER PAGE - PUBLIC ACCESS ===");
        return "register";
    }
}
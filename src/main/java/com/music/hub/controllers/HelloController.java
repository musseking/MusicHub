package com.music.hub.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.ui.Model;

@Controller
public class HelloController {
  @GetMapping("/hello")
  public String hello(Model model) {
    System.out.println("=== HELLO CONTROLLER HIT! ===");
    model.addAttribute("title", "Hello works");
    return "index";
  }
}
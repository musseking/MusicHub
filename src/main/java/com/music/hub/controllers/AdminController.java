package com.music.hub.controllers;

import com.music.hub.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;

@Controller
public class AdminController {
	private final UserService userService;

	public AdminController(UserService userService) {
		this.userService = userService;
	}

	@GetMapping("/users")
	public String showAllUsers(Model model, Authentication authentication) {
		if (authentication == null || !authentication.isAuthenticated()) {
			return "redirect:/login";
		}

		var users = userService.getAllUsers();
		model.addAttribute("title", "All Users - MusicHub");
		model.addAttribute("users", users);
		model.addAttribute("totalUsers", users.size());
		model.addAttribute("totalArtists", userService.getAllArtists().size());
		model.addAttribute("totalRegularUsers", userService.getAllRegularUsers().size());
		model.addAttribute("isAdmin", isAdmin(authentication));

		return "users";
	}

	@GetMapping("/admin/register-user")
	public String showRegisterUserForm(Model model, Authentication authentication) {
		if (!isAdmin(authentication)) {
			return "redirect:/";
		}

		model.addAttribute("title", "Add New User - MusicHub Admin");
		return "register-user";
	}

	@PostMapping("/admin/register-user")
	public String registerUser(@RequestParam String username, @RequestParam String email, @RequestParam String password,
			@RequestParam String firstName, @RequestParam String lastName, @RequestParam String userType, 
			@RequestParam(required = false) String bio, Model model, Authentication authentication) {

		if (!isAdmin(authentication)) {
			return "redirect:/";
		}

		try {
			boolean isArtist = "ARTIST".equals(userType);
			var user = userService.registerUser(username, email, password, firstName, lastName, isArtist);
			
			if (isArtist && bio != null && !bio.trim().isEmpty()) {
				user.setBio(bio);
				userService.updateUserBio(user.getId(), bio);
			}
			
			return "redirect:/admin/register-user?success=true";
		} catch (RuntimeException e) {
			model.addAttribute("error", e.getMessage());
			model.addAttribute("username", username);
			model.addAttribute("email", email);
			model.addAttribute("firstName", firstName);
			model.addAttribute("lastName", lastName);
			model.addAttribute("bio", bio);
			return "register-user";
		}
	}

	@PostMapping("/admin/users/{id}/deactivate")
	public String deactivateUser(@PathVariable Long id, Authentication authentication) {
		if (!isAdmin(authentication)) {
			return "redirect:/";
		}

		userService.deactivateUser(id);
		return "redirect:/users?deactivated=true";
	}

	@PostMapping("/admin/users/{id}/activate")
	public String activateUser(@PathVariable Long id, Authentication authentication) {
		if (!isAdmin(authentication)) {
			return "redirect:/";
		}

		userService.activateUser(id);
		return "redirect:/users?activated=true";
	}

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
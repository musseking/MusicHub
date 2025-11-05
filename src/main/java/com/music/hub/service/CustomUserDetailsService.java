package com.music.hub.service;

import com.music.hub.entity.User;
import com.music.hub.repository.UserRepository;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        System.out.println("=== LOADING USER: " + username + " ===");
        
        // Prvo proveri sa običnim findByUsername
        Optional<User> userOpt = userRepository.findByUsername(username);
        System.out.println("=== USER EXISTS (basic): " + userOpt.isPresent() + " ===");
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            System.out.println("=== USER DETAILS ===");
            System.out.println("=== Username: " + user.getUsername() + " ===");
            System.out.println("=== Password: " + user.getPassword() + " ===");
            System.out.println("=== IsActive: " + user.getIsActive() + " ===");
            System.out.println("=== IsAdmin: " + user.getIsAdmin() + " ===");
            System.out.println("=== IsArtist: " + user.getIsArtist() + " ===");
        }
        
        // Sada koristi findActiveUserByUsername
        User user = userRepository.findActiveUserByUsername(username)
                .orElseThrow(() -> {
                    System.out.println("=== USER NOT FOUND OR INACTIVE VIA ACTIVE QUERY ===");
                    return new UsernameNotFoundException("User not found or inactive: " + username);
                });

        System.out.println("=== USER SUCCESSFULLY LOADED VIA ACTIVE QUERY ===");
        
        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                getAuthorities(user)
        );
    }

    private List<GrantedAuthority> getAuthorities(User user) {
        List<GrantedAuthority> authorities = new ArrayList<>();
        
        // SVI korisnici dobijaju ROLE_USER
        authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
        
        // Ako je admin, dodaj ROLE_ADMIN
        if (Boolean.TRUE.equals(user.getIsAdmin())) {
            authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
        }
        
        // Ako je artist, dodaj ROLE_ARTIST  
        if (Boolean.TRUE.equals(user.getIsArtist())) {
            authorities.add(new SimpleGrantedAuthority("ROLE_ARTIST"));
        }
        
        System.out.println("=== FINAL AUTHORITIES: " + authorities + " ===");
        return authorities;
    }
}
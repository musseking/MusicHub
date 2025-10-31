package com.music.hub.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        System.out.println("=== CONFIGURING SECURITY - ALLOWING PUBLIC ACCESS ===");
        
        http
            // 1. DOZVOLI SVE ZAHTEVE BEZ AUTENTIFIKACIJE (PRIVREMENO)
            .authorizeHttpRequests(authz -> authz
                .anyRequest().permitAll()  // DOZVOLI SVE BEZ LOGINA!
            )
            
            // 2. ISKLJUČI FORM LOGIN PRIVREMENO
            .formLogin(form -> form.disable())
            
            // 3. ISKLJUČI LOGOUT PRIVREMENO
            .logout(logout -> logout.disable())
            
            // 4. ISKLJUČI CSRF
            .csrf(csrf -> csrf.disable())
            
            // 5. ISKLJUČI HEADERS
            .headers(headers -> headers.disable());

        return http.build();
    }

    @Bean
    public UserDetailsService userDetailsService(PasswordEncoder passwordEncoder) {
        System.out.println("=== CREATING DEMO USERS ===");
        
        UserDetails user = User.builder()
            .username("user")
            .password(passwordEncoder.encode("password"))
            .roles("USER")
            .build();

        return new InMemoryUserDetailsManager(user);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
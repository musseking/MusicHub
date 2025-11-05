package com.music.hub.security;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final UserDetailsService userDetailsService;

    public SecurityConfig(UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        System.out.println("=== CONFIGURING SECURITY - PUBLIC ACCESS WITH LOGIN OPTION ===");
        
        http
            .authorizeHttpRequests(authz -> authz
                // JAVNE RUTE - svi mogu pristupiti (i nelogovani)
                .requestMatchers(
                    "/", "/index",  
                    "/login", "/static/**",
                    "/css/**", "/js/**", "/images/**",
                    "/WEB-INF/jsp/**"  // dozvoli pristup JSP fajlovima
                ).permitAll()
                
                // ZAŠTIĆENE RUTE - samo za logovane korisnike
                .requestMatchers("/download/**", "/user/**").authenticated()
                
                // ADMIN RUTE - samo za admine
                .requestMatchers("/admin/**").hasRole("ADMIN")
                
                // ARTIST RUTE - samo za artiste
                .requestMatchers("/artist/**").hasRole("ARTIST")
                
                // SVE OSTALO - dozvoli svima (kao što želiš)
                .anyRequest().permitAll()
            )
            
            // OMOGUĆI FORM LOGIN (kao što želiš)
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .defaultSuccessUrl("/", true)  // nakon logina, vrati na index
                .failureUrl("/login?error=true")
                .permitAll()
            )
            
            // OMOGUĆI LOGOUT (opciono)
            .logout(logout -> logout
                .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                .logoutSuccessUrl("/?logout=true")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            )
            
            // KORISTI CUSTOM USER DETAILS SERVICE
            .userDetailsService(userDetailsService)
            
            // CSRF može ostati disable za testiranje
            .csrf(csrf -> csrf.disable());

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Bean
    public CommandLineRunner testPassword() {
        return args -> {
            PasswordEncoder encoder = passwordEncoder();
            String testPassword = "password123";
            String encoded = encoder.encode(testPassword);
            
            System.out.println("=== PASSWORD ENCODING TEST ===");
            System.out.println("Raw password: " + testPassword);
            System.out.println("Encoded: " + encoded);
            System.out.println("Matches stored: " + encoder.matches(testPassword, "$2a$10$8.UnVuG9HHgffUDAlk8qfOuW6.5d1uZ1V.8A9a7J.F.6zB0.7Q.6K"));
            System.out.println("=== END TEST ===");
        };
    }
    
 // Dodaj ovo privremeno u SecurityConfig
    @Bean
    public CommandLineRunner resetPassword() {
        return args -> {
            PasswordEncoder encoder = passwordEncoder();
            String newEncodedPassword = encoder.encode("password123");
            System.out.println("=== NEW PASSWORD HASH ===");
            System.out.println(newEncodedPassword);
            System.out.println("=== UPDATE YOUR DATABASE WITH THIS ===");
            
            // Kopiraj ovaj hash i update-uj bazu:
            // UPDATE users SET password = 'NEW_HASH_HERE' WHERE username = 'boris_brejcha';
        };
    }
}